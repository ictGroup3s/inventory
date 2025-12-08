// 기존 파일 내용 전체 삭제 → 아래 코드로 교체

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
    
    // 배정 방식 설정 (하나만 선택!)
    // 테스트용: "SPECIFIC" / 운영용: "RANDOM" / 부하분산: "LEAST_BUSY"
    private static final String ASSIGNMENT_MODE = "SPECIFIC";

    public String getUserRole(String userId) {
        return chatRepository.findRoleByUserId(userId);
    }

    public List<ChatVO> getChatRooms(String userId, String role) {
        if ("customer".equals(role)) {
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

    // ============ 자동 배정 기능 ============
    public String assignAdminToCustomer(String customerId) {
        // 1. 기존 채팅방 확인
        ChatVO existingChat = chatRepository.findExistingChatRoom(customerId);
        
        if (existingChat != null && existingChat.getAdmin_id() != null) {
            System.out.println("✅ 기존 관리자 재연결: " + existingChat.getAdmin_id());
            return existingChat.getAdmin_id();
        }
        
        // 2. 신규 고객 → 관리자 자동 배정
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
    
	/*
	 * public String assignAdminToCustomer(String customerId) { // 1. 기존 채팅방 확인
	 * ChatVO existingChat = chatRepository.findExistingChatRoom(customerId);
	 * 
	 * if (existingChat != null && existingChat.getAdmin_id() != null) {
	 * System.out.println("✅ 기존 관리자 재연결: " + existingChat.getAdmin_id()); return
	 * existingChat.getAdmin_id(); }
	 * 
	 * // 2. 신규 고객 → 관리자 자동 배정 String assignedAdmin = null;
	 * 
	 * switch (ASSIGNMENT_MODE) { case "SPECIFIC": assignedAdmin =
	 * chatRepository.findSpecificAdmin();
	 * System.out.println("🔧 테스트 모드: 특정 관리자 배정 - " + assignedAdmin); break;
	 * 
	 * case "RANDOM": assignedAdmin = chatRepository.findRandomAdmin();
	 * System.out.println("🎲 랜덤 배정: " + assignedAdmin); break;
	 * 
	 * case "LEAST_BUSY": assignedAdmin = chatRepository.findLeastBusyAdmin();
	 * System.out.println("⚖️ 부하 분산 배정: " + assignedAdmin); break;
	 * 
	 * default: assignedAdmin = chatRepository.findRandomAdmin(); break; }
	 * 
	 * if (assignedAdmin == null) { throw new RuntimeException("사용 가능한 관리자가 없습니다.");
	 * }
	 * 
	 * System.out.println("✅ 신규 고객 " + customerId + " → 관리자 " + assignedAdmin +
	 * " 배정 완료"); return assignedAdmin; }
	 */
}