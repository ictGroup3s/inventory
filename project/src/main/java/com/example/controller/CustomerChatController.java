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
    
    // 채팅방 목록
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
    
    // ============ 자동 배정 API 추가 ============
    
    /**
     * 고객에게 관리자를 자동 배정하는 API
     * - 기존 채팅방이 있으면 기존 관리자 반환
     * - 없으면 새로운 관리자 배정
     */
    @PostMapping("/assign-admin")
    public String assignAdmin(@RequestBody Map<String, String> request) {
        String customerId = request.get("customerId");
        
        if (customerId == null || customerId.trim().isEmpty()) {
            throw new IllegalArgumentException("고객 ID가 필요합니다.");
        }
        
        // 자동 배정 로직 실행
        String assignedAdminId = chatService.assignAdminToCustomer(customerId);
        
        return assignedAdminId;
    }
}