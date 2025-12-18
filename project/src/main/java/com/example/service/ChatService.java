package com.example.service;

import java.util.List;
import org.springframework.stereotype.Service;
import com.example.model.ChatRepository;
import com.example.model.vo.ChatVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatService {
	private final ChatRepository chatRepository;

	private static final String ASSIGNMENT_MODE = "SPECIFIC";

	public String getUserRole(String userId) {
		return chatRepository.findRoleByUserId(userId);
	}

	public List<ChatVO> getChatRooms(String userId, String role) {
		// role이 "0" 또는 "customer"이면 고객
		if ("customer".equals(role) || "0".equals(role)) {
			return chatRepository.findRoomsByCustomer(userId);
		} else {
			return chatRepository.findRoomsByAdmin(userId);
		}
	}

	public ChatVO getChatById(Integer chatNo) {
		return chatRepository.findChatById(chatNo);
	}

	public void saveChat(ChatVO chatVO) {
		chatRepository.saveChat(chatVO);
	}

	public void markAsRead(Integer chatNo) {
		chatRepository.markAsRead(chatNo);
	}

	public String assignAdminToCustomer(String customerId) {
		ChatVO existingChat = chatRepository.findExistingChatRoom(customerId);

		if (existingChat != null && existingChat.getAdmin_id() != null) {
			System.out.println("✅ 기존 관리자 재연결: " + existingChat.getAdmin_id());
			return existingChat.getAdmin_id();
		}

		String assignedAdmin = chatRepository.findSpecificAdmin();

		System.out.println("🔍 DB에서 조회한 관리자 ID: [" + assignedAdmin + "]");
		System.out.println("🔍 관리자 ID가 null인가? " + (assignedAdmin == null));
		System.out.println("🔍 관리자 ID 길이: " + (assignedAdmin != null ? assignedAdmin.length() : 0));

		if (assignedAdmin == null || assignedAdmin.trim().isEmpty()) {
			throw new RuntimeException("사용 가능한 관리자가 없습니다.");
		}

		System.out.println("✅ 신규 고객 " + customerId + " → 관리자 " + assignedAdmin + " 배정 완료");
		return assignedAdmin;
	}

	// 기존 채팅방 찾기 (핸들러에서 사용)
	public ChatVO getExistingChatRoom(String customerId) {
		return chatRepository.findExistingChatRoom(customerId);
	}

	public int countUnreadForCustomer(String customerId) {
		return chatRepository.countUnreadForCustomer(customerId);
	}

	public int countUnreadForAdmin(String adminId) {
		return chatRepository.countUnreadForAdmin(adminId);
	}

	public void markAsReadForCustomer(String customerId) {
		chatRepository.markAsReadForCustomer(customerId);
	}

	public void markAsReadForAdmin(String adminId, String customerId) {
		chatRepository.markAsReadForAdmin(adminId, customerId);
	}

	public int countUnreadByCustomer(String adminId, String customerId) {
		return chatRepository.countUnreadByCustomer(adminId, customerId);
	}

	public void closeChat(int chatNo) {
		chatRepository.closeChat(chatNo);
	}

	public List<ChatVO> getActiveRooms(String userId, String role) {
		if ("customer".equals(role) || "0".equals(role)) {
			return chatRepository.findActiveRoomsByCustomer(userId);
		} else {
			return chatRepository.findActiveRoomsByAdmin(userId);
		}
	}

	public void deleteChat(int chatNo) {
		chatRepository.deleteChat(chatNo);
	}

	public List<ChatVO> getAllRoomsByAdmin(String adminId) {
		return chatRepository.findAllRoomsByAdmin(adminId);
	}
}