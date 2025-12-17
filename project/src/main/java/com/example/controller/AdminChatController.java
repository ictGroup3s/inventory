package com.example.controller;

import com.example.model.vo.ChatVO;
import com.example.service.ChatService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/admin/chat") // 관리자 전용 URL prefix
public class AdminChatController {

	private final ChatService chatService;

	public AdminChatController(ChatService chatService) {
		this.chatService = chatService;
	}

	// 관리자 채팅방 목록 (종료된 것 포함)
	@GetMapping("/rooms")
	public List<ChatVO> getChatRooms(@RequestParam String adminId) {
	    return chatService.getAllRoomsByAdmin(adminId);
	}

	// 이전 채팅 불러오기 (관리자용)
	@GetMapping("/history/{chatNo}")
	public ChatVO getChatHistory(@PathVariable Integer chatNo) {
		return chatService.getChatById(chatNo);
	}

	// 안읽은 메시지 개수
	@GetMapping("/unread/{adminId}")
	public int getUnreadCount(@PathVariable String adminId) {
		return chatService.countUnreadForAdmin(adminId);
	}

	// 읽음 처리
	@PostMapping("/read")
	public void markAsRead(@RequestParam String adminId, @RequestParam String customerId) {
		chatService.markAsReadForAdmin(adminId, customerId);
	}
	
	// 특정 고객의 안읽은 메시지 개수
	@GetMapping("/unread")
	public int getUnreadByCustomer(@RequestParam String adminId, @RequestParam String customerId) {
	    return chatService.countUnreadByCustomer(adminId, customerId);
	}

	// 채팅 종료
	@PostMapping("/close/{chatNo}")
	public void closeChat(@PathVariable int chatNo) {
	    chatService.closeChat(chatNo);
	}
	
	// 채팅 삭제
	@DeleteMapping("/delete/{chatNo}")
	public void deleteChat(@PathVariable int chatNo) {
	    chatService.deleteChat(chatNo);
	}
}
