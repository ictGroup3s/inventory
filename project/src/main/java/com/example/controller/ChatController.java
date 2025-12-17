package com.example.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.model.vo.ChatVO;
import com.example.service.ChatService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    @PostMapping("/chat/save")
    public String saveChat(@RequestBody Map<String, String> data) throws Exception {

        ChatVO vo = new ChatVO();
        vo.setCustomer_id(data.get("userId"));
        vo.setAdmin_id(data.get("adminId"));
        //vo.setMessage(data.get("message"));

        chatService.saveChat(vo);

        return "OK";
    }
}