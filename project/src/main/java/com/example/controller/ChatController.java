package com.example.controller;

import java.security.Principal;
import java.time.Instant;
import java.util.UUID;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.example.chat.ChatMessage;
import com.example.chat.ChatService;

/**
 * 관리자/사용자 간 실시간 채팅을 처리하는 STOMP 컨트롤러
 * - 클라이언트가 /app/chat.send 로 보낸 메시지를 처리
 * - 메시지에 id/timestamp를 보완하고 저장한 뒤, /topic/chat/{roomId}로 브로드캐스트
 */
@Controller
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;  // 히스토리 저장용 서비스

    public ChatController(SimpMessagingTemplate messagingTemplate, ChatService chatService) {
        this.messagingTemplate = messagingTemplate;
        this.chatService = chatService;
    }

    /**
     * 클라이언트가 STOMP로 보낸 채팅 메시지를 처리합니다.
     * - Principal(인증 사용자)이 존재하면 sender를 서버 측 이름으로 덮어씀
     * - 메시지 id가 없으면 생성
     * - timestamp를 현재 시각으로 설정
     * - 히스토리에 저장한 뒤 해당 room의 토픽으로 브로드캐스트
     */
    @MessageMapping("/chat.send")
    public void sendMessage(Principal principal, @Payload ChatMessage message) {
        // 인증된 사용자가 있으면 서버에서 sender를 덮어써서 위변조를 방지
        if (principal != null && principal.getName() != null && !principal.getName().isEmpty()) {
            message.setSender(principal.getName());
        }

        if (message.getId() == null || message.getId().isEmpty()) {
            // 클라이언트가 id를 안 넣은 경우 서버에서 생성(선택)
            message.setId(UUID.randomUUID().toString());
        }
        message.setTimestamp(Instant.now().toEpochMilli());
        chatService.saveMessage(message.getRoomId(), message);
        messagingTemplate.convertAndSend("/topic/chat/" + message.getRoomId(), message);
    }
}