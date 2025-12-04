package com.example.handler;

import org.springframework.web.socket.*;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.client.RestTemplate;

import lombok.extern.slf4j.Slf4j;

import java.util.*;

@Slf4j
public class ChatHandler extends TextWebSocketHandler {
	
	private Map<String, WebSocketSession> sessions = new HashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        String userId = getParam(session, "userId");
        sessions.put(userId, session);

        session.sendMessage(new TextMessage("채팅 연결됨"));
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

        String msg = message.getPayload();
        String userId = getParam(session, "userId");
        String adminId = getParam(session, "adminId");

        // 1) 저장 요청
        RestTemplate rest = new RestTemplate();

        Map<String, String> data = new HashMap<>();
        data.put("userId", userId);
        data.put("adminId", adminId);
        data.put("message", "[" + userId + "] " + msg);

        rest.postForObject("http://localhost:8080/chat/save", data, String.class);

        // 2) 브로드캐스트
        for (WebSocketSession s : sessions.values()) {
            s.sendMessage(new TextMessage(userId + ": " + msg));
        }
    }

    private String getParam(WebSocketSession session, String name) {
        String query = session.getUri().getQuery();
        for (String p : query.split("&")) {
            if (p.startsWith(name + "=")) return p.split("=")[1];
        }
        return null;
    }
	
	/*
    private Map<String, WebSocketSession> sessions = new HashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        String userId = getParam(session, "userId");

        sessions.put(userId, session);

        System.out.println("### 연결됨: " + userId);

        session.sendMessage(new TextMessage("채팅에 연결되었습니다."));
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

        String msg = message.getPayload();
        String userId = getParam(session, "userId");
        String adminId = getParam(session, "adminId");

        // -----------------------------
        //   📌 1) Controller로 저장 요청
        // -----------------------------
        RestTemplate rest = new RestTemplate();

        Map<String, String> data = new HashMap<>();
        data.put("userId", userId);
        data.put("adminId", adminId);
        data.put("message", msg);

        rest.postForObject("http://localhost:8080/chat/save", data, String.class);


        // -----------------------------
        //   📌 2) 웹소켓 사용자들에게 전달
        // -----------------------------
        for (WebSocketSession s : sessions.values()) {
            s.sendMessage(new TextMessage(userId + ": " + msg));
        }

        System.out.println("메시지 저장 및 전송 완료: " + msg);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        String userId = getParam(session, "userId");
        sessions.remove(userId);
        System.out.println("### 연결 종료됨: " + userId);
    }

    private String getParam(WebSocketSession session, String name) {
        String query = Objects.requireNonNull(session.getUri()).getQuery();

        for (String part : query.split("&")) {
            if (part.startsWith(name + "=")) {
                return part.substring((name + "=").length());
            }
        }
        return null;
    }
    */
}
