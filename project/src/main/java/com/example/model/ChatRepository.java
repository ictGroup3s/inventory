package com.example.model;
import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.example.model.vo.ChatVO;

@Repository
public class ChatRepository {
    
    @Autowired
    private SqlSessionTemplate sqlSession;
    
    // 사용자 ID로 역할 조회 (고객/관리자)
    public String findRoleByUserId(String userId) {
        return sqlSession.selectOne("chatMapper.findRoleByUserId", userId);
    }
    
    // 채팅 저장
    public void saveChat(ChatVO chat) {
        sqlSession.insert("chatMapper.insertChat", chat);
    }
    
    // 채팅번호로 조회
    public ChatVO findChatById(Integer chatNo) {
        return sqlSession.selectOne("chatMapper.selectChatByNo", chatNo);
    }
    
    // 고객별 채팅방 목록
    public List<ChatVO> findRoomsByCustomer(String customerId) {
        return sqlSession.selectList("chatMapper.selectRoomsByCustomer", customerId);
    }
    
    // 관리자별 채팅방 목록
    public List<ChatVO> findRoomsByAdmin(String adminId) {
        return sqlSession.selectList("chatMapper.selectRoomsByAdmin", adminId);
    }
    
    // 읽음 처리
    public void markAsRead(int chatNo) {
        sqlSession.update("chatMapper.updateReadFlag", chatNo);
    }
    
    // ============ 자동 배정 관련 메서드 추가 ============
    
    // 고객의 기존 채팅방 찾기 (이전에 배정된 관리자 확인)
    public ChatVO findExistingChatRoom(String customerId) {
        return sqlSession.selectOne("chatMapper.findExistingChatRoom", customerId);
    }
    
    // 특정 관리자 ID 가져오기 (테스트용)
    public String findSpecificAdmin() {
        return sqlSession.selectOne("chatMapper.findSpecificAdmin");
    }
    
    // 랜덤 관리자 선택
    public String findRandomAdmin() {
        return sqlSession.selectOne("chatMapper.findRandomAdmin");
    }
    
    // 채팅 개수가 가장 적은 관리자 선택
    public String findLeastBusyAdmin() {
        return sqlSession.selectOne("chatMapper.findLeastBusyAdmin");
    }
    
    // 모든 관리자 목록
    public List<String> findAllAdmins() {
        return sqlSession.selectList("chatMapper.findAllAdmins");
    }
}