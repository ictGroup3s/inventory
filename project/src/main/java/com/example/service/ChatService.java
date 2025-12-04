package com.example.service;

import java.io.File;
import java.io.FileWriter;

import org.springframework.stereotype.Service;

import com.example.model.ChatRepository;
import com.example.model.vo.ChatVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRepository chatRepo;

    // 채팅 저장 로직 (파일 + DB)
    public void saveChat(ChatVO vo) throws Exception {

        // 1) 채팅 내용 txt 저장
        String folder = "C:/chat_files/";
        File dir = new File(folder);
        if (!dir.exists()) dir.mkdirs();

        String fileName = "chat_" + vo.getCustomer_id() + ".txt";
        String filePath = folder + fileName;

        FileWriter fw = new FileWriter(filePath, true);
        //fw.write(vo.getMessage() + "\n");
        fw.close();

        // 2) DB 저장
        vo.setChat_file(fileName);
        chatRepo.saveChat(vo);
    }
}
