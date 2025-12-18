package com.example.model;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.ChatVO;

@Repository
public class ChatRepository {
    
    @Autowired
    private SqlSessionTemplate sess;
    
    // 사용자 ID로 역할 조회 (고객/관리자)
    public String findRoleByUserId(String userId) {
        return sess.selectOne("chatMapper.findRoleByUserId", userId);
    }
    
    // 채팅 저장
    public void saveChat(ChatVO chat) {
        sess.insert("chatMapper.insertChat", chat);
    }
    
    // 채팅번호로 조회
    public ChatVO findChatById(Integer chatNo) {
        return sess.selectOne("chatMapper.selectChatByNo", chatNo);
    }
    
    // 고객별 채팅방 목록
    public List<ChatVO> findRoomsByCustomer(String customerId) {
        return sess.selectList("chatMapper.selectRoomsByCustomer", customerId);
    }
    
    // 관리자별 채팅방 목록
    public List<ChatVO> findRoomsByAdmin(String adminId) {
        return sess.selectList("chatMapper.selectRoomsByAdmin", adminId);
    }
    
    // 읽음 처리
    public void markAsRead(int chatNo) {
        sess.update("chatMapper.updateReadFlag", chatNo);
    }
    
    // ============ 자동 배정 관련 메서드 추가 ============
    
    // 고객의 기존 채팅방 찾기 (이전에 배정된 관리자 확인)
    public ChatVO findExistingChatRoom(String customerId) {
        return sess.selectOne("chatMapper.findExistingChatRoom", customerId);
    }
    
    // 특정 관리자 ID 가져오기 (테스트용)
    public String findSpecificAdmin() {
        return sess.selectOne("chatMapper.findSpecificAdmin");
    }
    
    // 랜덤 관리자 선택
    public String findRandomAdmin() {
        return sess.selectOne("chatMapper.findRandomAdmin");
    }
    
    // 채팅 개수가 가장 적은 관리자 선택
    public String findLeastBusyAdmin() {
        return sess.selectOne("chatMapper.findLeastBusyAdmin");
    }
    
    // 모든 관리자 목록
    public List<String> findAllAdmins() {
        return sess.selectList("chatMapper.findAllAdmins");
    }
    
	// 안읽은 메시지 개수 (고객용)
	public int countUnreadForCustomer(String customerId) {
		Integer count = sess.selectOne("chatMapper.countUnreadForCustomer", customerId);
		return count != null ? count : 0;
	}

    // 안읽은 메시지 개수 (관리자용)
    public int countUnreadForAdmin(String adminId) {
        Integer count = sess.selectOne("chatMapper.countUnreadForAdmin", adminId);
        return count != null ? count : 0;
    }

    // 읽음 처리 (고객용)
    public void markAsReadForCustomer(String customerId) {
        sess.update("chatMapper.markAsReadForCustomer", customerId);
    }

    // 읽음 처리 (관리자용)
    public void markAsReadForAdmin(String adminId, String customerId) {
        Map<String, String> params = new HashMap<>();
        params.put("adminId", adminId);
        params.put("customerId", customerId);
        sess.update("chatMapper.markAsReadForAdmin", params);
    }
    
 // 특정 고객의 안읽은 메시지 개수 (관리자용)
    public int countUnreadByCustomer(String adminId, String customerId) {
        Map<String, String> params = new HashMap<>();
        params.put("adminId", adminId);
        params.put("customerId", customerId);
        Integer count = sess.selectOne("chatMapper.countUnreadByCustomer", params);
        return count != null ? count : 0;
    }

    // 채팅 종료
    public void closeChat(int chatNo) {
        sess.update("chatMapper.closeChat", chatNo);
    }

    // 진행 중인 채팅방 조회 (고객용)
    public List<ChatVO> findActiveRoomsByCustomer(String customerId) {
        return sess.selectList("chatMapper.selectActiveRoomsByCustomer", customerId);
    }

    // 진행 중인 채팅방 조회 (관리자용)
    public List<ChatVO> findActiveRoomsByAdmin(String adminId) {
        return sess.selectList("chatMapper.selectActiveRoomsByAdmin", adminId);
    }
    
 // 채팅 삭제
    public void deleteChat(int chatNo) {
        sess.delete("chatMapper.deleteChat", chatNo);
    }

    // 관리자용 모든 채팅방 조회 (종료된 것 포함)
    public List<ChatVO> findAllRoomsByAdmin(String adminId) {
        return sess.selectList("chatMapper.selectAllRoomsByAdmin", adminId);
    }
}