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

    // ----------------- 관리자 채팅방 목록 -----------------
    @GetMapping("/rooms")
    public List<ChatVO> getChatRooms(@RequestParam String adminId) {
        return chatService.getChatRooms(adminId, "admin");
    }
    
    //관리자
    // ----------------- 관리자 채팅 기록 -----------------
    @GetMapping("/admin/chat/history/{chatNo}") 
    public ChatVO getChatHistory(@PathVariable Integer chatNo) {
        return chatService.getChatById(chatNo);
    }
}
