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

    // ChatRepository에 findRoleByUserId가 추가되어 정상 호출됩니다.
    public String getUserRole(String userId) {
        return chatRepository.findRoleByUserId(userId);
    }

    public List<ChatVO> getChatRooms(String userId, String role) {
        if("customer".equals(role)) {
            return chatRepository.findRoomsByCustomer(userId);
        } else {
            return chatRepository.findRoomsByAdmin(userId);
        }
    }

    // ChatRepository의 findChatByNo가 findChatById로 변경되어 정상 호출됩니다.
    public ChatVO getChatById(Integer chatNo) {
        return chatRepository.findChatById(chatNo);
    }

    public void saveChat(ChatVO chatVO) {
        chatRepository.saveChat(chatVO);
    }
}