package com.example.webSocket;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.CopyOnWriteArraySet;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.example.model.vo.ChatVO;
import com.example.service.ChatService;

import lombok.RequiredArgsConstructor;
import org.json.JSONObject;

@Component
@RequiredArgsConstructor
public class ChatHandler extends TextWebSocketHandler {

    private final ChatService chatService;
    private final CopyOnWriteArraySet<WebSocketSession> sessions = new CopyOnWriteArraySet<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        sessions.add(session);
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        ChatMessage chatMsg = ChatMessage.fromJson(payload);

        // 파일 저장
        String fileName = saveMessageToFile(chatMsg);

        // DB 저장
        ChatVO chatVO = new ChatVO();
        chatVO.setCustomer_id(chatMsg.getCustomerId());
        chatVO.setAdmin_id(chatMsg.getAdminId());
        chatVO.setChat_file(fileName);
        chatVO.setChat_time(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        chatVO.setRead_flag("N");
        chatService.saveChat(chatVO);

        // 모든 세션에 메시지 전송
        TextMessage sendMsg = new TextMessage(payload);
        for (WebSocketSession s : sessions) {
            if (s.isOpen()) {
                s.sendMessage(sendMsg);
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        sessions.remove(session);
    }

    private String saveMessageToFile(ChatMessage msg) throws IOException {
        String fileName = "chat_" + System.currentTimeMillis() + ".txt";
        File file = new File("chat/" + fileName);
        file.getParentFile().mkdirs();
        try (FileWriter writer = new FileWriter(file, true)) {
            writer.write("[" + msg.getSender() + "] : " + msg.getMessage() + "\n");
        }
        return fileName;
    }

    private static class ChatMessage {
        private String customerId;
        private String adminId;
        private String message;

        public String getSender() {
            return customerId != null ? customerId : adminId;
        }

        public String getReceiver() {
            return customerId != null ? adminId : customerId;
        }

        public static ChatMessage fromJson(String json) {
            JSONObject obj = new JSONObject(json);
            ChatMessage msg = new ChatMessage();
            msg.customerId = obj.optString("customerId", null);
            msg.adminId = obj.optString("adminId", null);
            msg.message = obj.getString("message");
            return msg;
        }

        public String getCustomerId() { return customerId; }
        public String getAdminId() { return adminId; }
        public String getMessage() { return message; }
    }
}
