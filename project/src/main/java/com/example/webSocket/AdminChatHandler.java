package com.example.webSocket;

import com.example.model.vo.ChatVO;
import com.example.service.ChatService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.*;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class AdminChatHandler extends TextWebSocketHandler {

    private final Map<String, Set<WebSocketSession>> roomSessions = new ConcurrentHashMap<>();
    private final Map<String, String> roomFiles = new ConcurrentHashMap<>();

    private final ObjectMapper objectMapper = new ObjectMapper();
    private final ChatService chatService;

    private final String CHAT_DIR = "src/main/resources/static/chat/";

    public AdminChatHandler(ChatService chatService) {
        this.chatService = chatService;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        System.out.println("관리자 연결됨: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        Map<String, Object> chatMsg = objectMapper.readValue(message.getPayload(), Map.class);
        String customerId = (String) chatMsg.get("customerId");
        String adminId = (String) chatMsg.get("adminId");
        String msgContent = (String) chatMsg.get("message");

        String roomId = customerId + "_" + adminId;

        // 세션 관리
        roomSessions.putIfAbsent(roomId, Collections.synchronizedSet(new HashSet<>()));
        roomSessions.get(roomId).add(session);

        // 파일 관리
        roomFiles.putIfAbsent(roomId, "chat_" + customerId + "_" + adminId + "_" + System.currentTimeMillis() + ".txt");
        String fileName = roomFiles.get(roomId);
        String filePath = CHAT_DIR + fileName;

        File file = new File(filePath);
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }

        String timeStamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

        // 파일에 저장
        try (FileWriter fw = new FileWriter(file, true)) {
            fw.write("[" + timeStamp + "] " + adminId + ": " + msgContent + "\n");
        } catch (IOException e) {
            e.printStackTrace();
        }

        // DB 저장
        ChatVO chatVO = new ChatVO();
        chatVO.setCustomer_id(customerId);
        chatVO.setAdmin_id(adminId);
        chatVO.setChat_file(fileName);
        chatVO.setChat_time(timeStamp);
        chatService.saveChat(chatVO);

        // 브로드캐스트
        TextMessage broadcast = new TextMessage(objectMapper.writeValueAsString(chatMsg));
        for (WebSocketSession s : roomSessions.get(roomId)) {
            if (s.isOpen()) s.sendMessage(broadcast);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        roomSessions.values().forEach(set -> set.remove(session));
        System.out.println("관리자 연결 종료: " + session.getId());
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        System.out.println("관리자 전송 오류: " + exception.getMessage());
    }
}
