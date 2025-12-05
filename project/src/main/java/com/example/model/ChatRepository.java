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
}
