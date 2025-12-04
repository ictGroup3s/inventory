package com.example.chat;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.stereotype.Service;

@Service
public class ChatService {

	private final Map<String, Deque<ChatMessage>> store = new ConcurrentHashMap<>();
    private final int MAX_HISTORY = 100;

    public void saveMessage(String roomId, ChatMessage msg) {
        store.computeIfAbsent(roomId, k -> new ArrayDeque<>());
        Deque<ChatMessage> dq = store.get(roomId);
        synchronized (dq) {
            if (dq.size() >= MAX_HISTORY) dq.removeFirst();
            dq.addLast(msg);
        }
    }

    public List<ChatMessage> getHistory(String roomId) {
        Deque<ChatMessage> dq = store.getOrDefault(roomId, new ArrayDeque<>());
        synchronized (dq) {
            return new ArrayList<>(dq);
        }
    }
}
