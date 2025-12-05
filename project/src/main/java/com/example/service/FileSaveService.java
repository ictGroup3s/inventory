package com.example.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class FileSaveService {

    private static final String CHAT_DIR = "C:/chat_logs/";

    public String saveChat(String customerId, String adminId, String msg) {
        File dir = new File(CHAT_DIR);
        if (!dir.exists())
            dir.mkdirs();

        String fileName = "chat_" + customerId + "_" + adminId + ".txt";
        File file = new File(dir, fileName);

        try (FileWriter fw = new FileWriter(file, true)) {
            fw.write(msg + "\n");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return fileName;
    }

    // 이전 채팅 읽기
    public List<String> readChat(String customerId, String adminId) {
        List<String> messages = new ArrayList<>();
        String fileName = CHAT_DIR + "chat_" + customerId + "_" + adminId + ".txt";
        File file = new File(fileName);

        if (!file.exists()) return messages;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while((line = br.readLine()) != null) {
                messages.add(line);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return messages;
    }
}

