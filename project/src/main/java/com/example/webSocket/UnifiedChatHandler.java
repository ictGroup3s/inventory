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
public class UnifiedChatHandler extends TextWebSocketHandler {

	private static final Map<String, Set<WebSocketSession>> roomSessions = new ConcurrentHashMap<>();
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
			String sender = (String) chatMsg.get("sender");

			String roomId = customerId + "_" + adminId;

			// 세션 추가
			roomSessions.putIfAbsent(roomId, Collections.synchronizedSet(new HashSet<>()));
			roomSessions.get(roomId).add(session);

			// JOIN 메시지는 세션만 등록하고 저장/브로드캐스트 안 함
			if ("__JOIN__".equals(msgContent)) {
				System.out.println("🚪 " + sender + " 방 입장 (세션 등록만)");
				return;
			}

			// CLOSE 메시지는 종료 알림만 전송 (파일/DB 저장 안 함)
			if ("__CLOSE__".equals(msgContent)) {
				System.out.println("🔒 채팅 종료 알림 전송: " + roomId);

				// 캐시에서 파일명 제거 (새 채팅 시 새 파일 생성되도록)
				roomFiles.remove(roomId);

				Map<String, Object> closeMsg = new HashMap<>();
				closeMsg.put("customerId", customerId);
				closeMsg.put("adminId", adminId);
				closeMsg.put("message", "__CLOSE__");
				closeMsg.put("sender", "system");
				closeMsg.put("type", "close");

				TextMessage broadcast = new TextMessage(objectMapper.writeValueAsString(closeMsg));

				for (WebSocketSession s : roomSessions.get(roomId)) {
					if (s.isOpen()) {
						s.sendMessage(broadcast);
					}
				}
				return;
			}

			System.out.println("📬 [" + roomId + "] " + sender + " -> " + msgContent);
			System.out.println("🔗 현재 세션 수: " + roomSessions.get(roomId).size());

			// 파일명 결정 (기존 채팅방 있으면 그 파일 사용)
			String fileName;
			if (roomFiles.containsKey(roomId)) {
				fileName = roomFiles.get(roomId);
			} else {
				// DB에서 기존 채팅방 파일 찾기
				ChatVO existingChat = chatService.getExistingChatRoom(customerId);
				if (existingChat != null && existingChat.getChat_file() != null && existingChat.getAdmin_id() != null
						&& existingChat.getAdmin_id().equals(adminId)) {
					fileName = existingChat.getChat_file();
					System.out.println("📂 기존 파일 사용: " + fileName);
				} else {
					fileName = "chat_" + roomId + "_" + System.currentTimeMillis() + ".txt";
					System.out.println("📂 새 파일 생성: " + fileName);
				}
				roomFiles.put(roomId, fileName);
			}

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

			// DB 저장 (MERGE - 있으면 UPDATE, 없으면 INSERT)
			ChatVO chatVO = new ChatVO();
			chatVO.setCustomer_id(customerId);
			chatVO.setAdmin_id(adminId);
			chatVO.setChat_file(fileName);
			chatVO.setChat_time(timeStamp);

			// 관리자가 보낸 메시지면 read_flag = 'Y' (관리자가 보낸 거니까 관리자는 읽은 상태)
			// 고객이 보낸 메시지면 read_flag = 'N' (관리자가 아직 안읽음)
			if ("admin".equals(sender)) {
				chatVO.setRead_flag("Y"); // 관리자가 보냄 → 관리자는 이미 읽음
			} else {
				chatVO.setRead_flag("N"); // 고객이 보냄 → 관리자가 안읽음
			}

			chatService.saveChat(chatVO);

			// 응답 메시지 생성
			Map<String, Object> responseMsg = new HashMap<>();
			responseMsg.put("customerId", customerId);
			responseMsg.put("adminId", adminId);
			responseMsg.put("message", msgContent);
			responseMsg.put("timestamp", timeStamp);
			responseMsg.put("sender", sender);

			TextMessage broadcast = new TextMessage(objectMapper.writeValueAsString(responseMsg));

			// 브로드캐스트
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
		roomSessions.values().forEach(set -> set.remove(session));
		System.out.println("🔌 WebSocket 연결 종료: " + session.getId());
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		System.err.println("⚠️ WebSocket 전송 오류: " + exception.getMessage());
	}
}