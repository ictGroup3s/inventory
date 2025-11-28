package com.example.chat;

import java.util.ArrayDeque;
import java.util.Collections;
import java.util.Deque;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

/**
 * 채팅 메시지 저장 서비스 (DB 영속화 + 메모리 캐시)
 * - 메시지를 JPA 리포지토리에 저장하고, 최근 N개는 메모리에도 보관하여 빠른 조회 지원
 * - 저장 후 해당 룸의 unreadCount를 STOMP로 브로드캐스트하여 관리자 UI가 실시간으로 갱신되도록 함
 */
@Service
public class ChatService {

    private final ChatMessageRepository repository;
    private final SimpMessagingTemplate messagingTemplate;

    // 간단한 메모리 캐시: roomId -> Deque(최신순 유지)
    private final Map<String, Deque<ChatMessage>> cache = new ConcurrentHashMap<>();
    private final int MAX_HISTORY = 100;

    public ChatService(ChatMessageRepository repository, SimpMessagingTemplate messagingTemplate) {
        this.repository = repository;
        this.messagingTemplate = messagingTemplate;
    }

    // 메시지를 DB에 저장하고 메모리 캐시에 추가
    public void saveMessage(String roomId, ChatMessage msg) {
        if (msg.getId() == null || msg.getId().isEmpty()) {
            msg.setId(UUID.randomUUID().toString());
        }
        ChatMessageEntity e = new ChatMessageEntity(msg.getId(), roomId, msg.getSender(), msg.getContent(), msg.getType() == null ? null : msg.getType().name(), msg.getTimestamp());
        // 저장 시 기본 isRead는 false로 설정되어 있음
        repository.save(e);

        cache.computeIfAbsent(roomId, k -> new ArrayDeque<>());
        Deque<ChatMessage> dq = cache.get(roomId);
        synchronized (dq) {
            if (dq.size() >= MAX_HISTORY) dq.removeFirst();
            dq.addLast(msg);
        }

        // 저장 후 해당 룸의 미확인 개수 조회 및 브로드캐스트
        try {
            long unread = repository.countByRoomIdAndIsReadFalse(roomId);
            Map<String, Object> payload = new HashMap<>();
            payload.put("roomId", roomId);
            payload.put("unreadCount", unread);
            messagingTemplate.convertAndSend("/topic/chat/rooms", payload);
        } catch (Exception ex) {
            // 브로드캐스트 실패시 무시 (로깅 가능)
            System.err.println("Unread broadcast failed: " + ex.getMessage());
        }
    }

    // DB 조회로부터 히스토리를 가져오고, 필요시 메모리 캐시를 최신화
    public List<ChatMessage> getHistory(String roomId) {
        List<ChatMessageEntity> entities = repository.findTop100ByRoomIdOrderByTimestampDesc(roomId);
        // 엔티티는 최신순(desc)으로 오므로 역순으로 반환하여 오래된 순->최신 순으로 맞춤
        List<ChatMessage> list = entities.stream().map(e -> {
            ChatMessage m = new ChatMessage();
            m.setId(e.getId());
            m.setRoomId(e.getRoomId());
            m.setSender(e.getSender());
            m.setContent(e.getContent());
            try { m.setType(e.getType() == null ? null : ChatMessage.MessageType.valueOf(e.getType())); } catch(Exception ex) { }
            m.setTimestamp(e.getTimestamp());
            // 엔티티의 읽음 상태를 DTO에 반영
            try { m.setRead(e.isRead()); } catch (Exception ex) { /* ignore */ }
            return m;
        }).collect(Collectors.toList());
        Collections.reverse(list); // oldest -> newest
        return list;
    }
}