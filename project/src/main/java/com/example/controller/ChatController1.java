package com.example.controller;

import java.time.Instant;
import java.util.UUID;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.example.chat.ChatMessage;
import com.example.chat.ChatService;

@Controller
public class ChatController1 {

	private final SimpMessagingTemplate messagingTemplate;
	private final ChatService chatService;  // optional, 히스토리 저장용
	
	public ChatController1(SimpMessagingTemplate messagingTemplate, ChatService chatService) {
		this.messagingTemplate = messagingTemplate;
		this.chatService = chatService;
	}

	// 클라이언트가 /app/chat.send 로 메시지를 보냄
    @MessageMapping("/chat.send")
    public void sendMessage(@Payload ChatMessage message) {
        if (message.getId() == null || message.getId().isEmpty()) {
            // 클라이언트가 id를 안 넣은 경우 서버에서 생성(선택)
            message.setId(UUID.randomUUID().toString());
        }
        message.setTimestamp(Instant.now().toEpochMilli());
        chatService.saveMessage(message.getRoomId(), message);
        messagingTemplate.convertAndSend("/topic/chat/" + message.getRoomId(), message);
    }
}