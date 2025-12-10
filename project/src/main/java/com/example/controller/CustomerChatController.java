package com.example.controller;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.*;

import com.example.model.vo.ChatVO;
import com.example.service.ChatService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/chat")
@RequiredArgsConstructor
public class CustomerChatController {

	private final ChatService chatService;

	// 사용자 역할 확인
	@GetMapping("/role/{userId}")
	public String getUserRole(@PathVariable String userId) {
		return chatService.getUserRole(userId);
	}

	// 채팅방 목록 (종료된 것 포함)
	@GetMapping("/rooms/{userId}")
	public List<ChatVO> getChatRooms(@PathVariable String userId) {
	    String role = chatService.getUserRole(userId);
	    return chatService.getChatRooms(userId, role);  
	}

	// 이전 채팅 불러오기 (고객용)
	@GetMapping("/history/{chatNo}")
	public ChatVO getChatHistory(@PathVariable Integer chatNo) {
		return chatService.getChatById(chatNo);
	}

	// 채팅 상태 확인
	@GetMapping("/status/{chatNo}")
	public String getChatStatus(@PathVariable int chatNo) {
		ChatVO chat = chatService.getChatById(chatNo);
		if (chat == null)
			return "NOT_FOUND";
		return chat.getStatus() != null ? chat.getStatus() : "ACTIVE";
	}

	// ============ 자동 배정 API ============
	@PostMapping("/assign-admin")
	public String assignAdmin(@RequestBody Map<String, String> request) {
		String customerId = request.get("customerId");

		if (customerId == null || customerId.trim().isEmpty()) {
			throw new IllegalArgumentException("고객 ID가 필요합니다.");
		}

		return chatService.assignAdminToCustomer(customerId);
	}

	// 안읽은 메시지 개수
	@GetMapping("/unread/{customerId}")
	public int getUnreadCount(@PathVariable String customerId) {
		return chatService.countUnreadForCustomer(customerId);
	}

	// 읽음 처리
	@PostMapping("/read/{customerId}")
	public void markAsRead(@PathVariable String customerId) {
		chatService.markAsReadForCustomer(customerId);
	}

	// 모든 채팅방 목록 (종료된 것 포함)
	@GetMapping("/rooms/all/{userId}")
	public List<ChatVO> getAllChatRooms(@PathVariable String userId) {
		String role = chatService.getUserRole(userId);
		return chatService.getChatRooms(userId, role);
	}
	
	// 채팅 삭제
	@DeleteMapping("/delete/{chatNo}")
	public void deleteChat(@PathVariable int chatNo) {
	    chatService.deleteChat(chatNo);
	}
}