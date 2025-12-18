package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/chat")
public class UserChatController {

    // 채팅 파일 불러오기
    @GetMapping(value = "/files/{fileName}", produces = MediaType.TEXT_PLAIN_VALUE)
    public String getChatFile(@PathVariable String fileName) throws IOException {
        // 파일 경로 (UnifiedChatHandler와 동일해야 함)
        String filePath = "src/main/resources/static/chat/" + fileName;
        File file = new File(filePath);
        
        System.out.println("📁 파일 경로: " + file.getAbsolutePath());
        
        if (!file.exists()) {
            System.out.println("❌ 파일 없음: " + fileName);
            return "";
        }
        
        System.out.println("✅ 파일 찾음: " + fileName);
        String content = Files.readString(file.toPath());
        System.out.println("📝 파일 내용 길이: " + content.length());
        
        return content;
    }
}