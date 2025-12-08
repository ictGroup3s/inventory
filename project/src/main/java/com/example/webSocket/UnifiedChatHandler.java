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

/**
 * 관리자와 고객 간 실시간 채팅을 위한 통합 WebSocket 핸들러
 * roomId를 기준으로 관리자-고객 세션을 함께 관리
 */
@Component
public class UnifiedChatHandler extends TextWebSocketHandler {

    // roomId별 세션 관리 (관리자 + 고객 세션 모두 포함)
    private static final Map<String, Set<WebSocketSession>> roomSessions = new ConcurrentHashMap<>();
    
    // roomId별 파일명 관리
    private static final Map<String, String> roomFiles = new ConcurrentHashMap<>();
    
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final ChatService chatService;
    private final String CHAT_DIR = "src/main/resources/static/chat/";

    public UnifiedChatHandler(ChatService chatService) {
        this.chatService = chatService;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        System.out.println("✅ WebSocket 연결됨: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        try {
            Map<String, Object> chatMsg = objectMapper.readValue(message.getPayload(), Map.class);
            String customerId = (String) chatMsg.get("customerId");
            String adminId = (String) chatMsg.get("adminId");
            String msgContent = (String) chatMsg.get("message");
            String sender = (String) chatMsg.get("sender"); // "admin" 또는 "customer"

            // roomId 생성 (항상 동일한 형식으로)
            String roomId = customerId + "_" + adminId;

            // 세션 추가 (관리자든 고객이든 같은 roomId에 추가)
            roomSessions.putIfAbsent(roomId, Collections.synchronizedSet(new HashSet<>()));
            roomSessions.get(roomId).add(session);

            System.out.println("📬 [" + roomId + "] " + sender + " -> " + msgContent);
            System.out.println("🔗 현재 세션 수: " + roomSessions.get(roomId).size());

            // 파일명 생성 (한 번만)
            roomFiles.putIfAbsent(roomId, "chat_" + roomId + "_" + System.currentTimeMillis() + ".txt");
            String fileName = roomFiles.get(roomId);
            String filePath = CHAT_DIR + fileName;

            // 디렉토리 생성
            File file = new File(filePath);
            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }

            // 타임스탬프
            String timeStamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

            // 파일에 저장
            try (FileWriter fw = new FileWriter(file, true)) {
                String senderName = "admin".equals(sender) ? adminId : customerId;
                fw.write("[" + timeStamp + "] " + senderName + ": " + msgContent + "\n");
            } catch (IOException e) {
                e.printStackTrace();
            }

            // DB 저장 (중복 저장 방지 - 마지막 메시지만 업데이트)
            ChatVO chatVO = new ChatVO();
            chatVO.setCustomer_id(customerId);
            chatVO.setAdmin_id(adminId);
            chatVO.setChat_file(fileName);
            chatVO.setChat_time(timeStamp);

            // ========== 디버깅 로그 ==========
            System.out.println("=== DB 저장 직전 데이터 ===");
            System.out.println("customer_id: [" + customerId + "]");
            System.out.println("admin_id: [" + adminId + "]");
            System.out.println("chat_file: [" + fileName + "]");
            System.out.println("==========================");
            
            chatService.saveChat(chatVO);

            // 응답 메시지 생성
            Map<String, Object> responseMsg = new HashMap<>();
            responseMsg.put("customerId", customerId);
            responseMsg.put("adminId", adminId);
            responseMsg.put("message", msgContent);
            responseMsg.put("timestamp", timeStamp);
            responseMsg.put("sender", sender);

            TextMessage broadcast = new TextMessage(objectMapper.writeValueAsString(responseMsg));

            // 같은 roomId의 모든 세션에 브로드캐스트 (관리자 + 고객 모두)
            int successCount = 0;
            for (WebSocketSession s : roomSessions.get(roomId)) {
                if (s.isOpen()) {
                    s.sendMessage(broadcast);
                    successCount++;
                }
            }
            
            System.out.println("✉️ " + successCount + "개 세션에 메시지 전송 완료");

        } catch (Exception e) {
            System.err.println("❌ 메시지 처리 중 오류: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        // 모든 방에서 해당 세션 제거
        roomSessions.values().forEach(set -> set.remove(session));
        System.out.println("🔌 WebSocket 연결 종료: " + session.getId());
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        System.err.println("⚠️ WebSocket 전송 오류: " + exception.getMessage());
    }
}