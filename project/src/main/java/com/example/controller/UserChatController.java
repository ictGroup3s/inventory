package com.example.controller;

import java.util.List;

import org.springframework.web.bind.annotation.*;

import com.example.model.vo.ChatVO;
import com.example.service.ChatService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/chat")
@RequiredArgsConstructor
public class UserChatController {

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

    // 채팅 저장
    @PostMapping("/save")
    public String saveChat(@RequestBody ChatVO chatVO) {
        chatService.saveChat(chatVO);
        return "success";
    }
}
