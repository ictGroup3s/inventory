package com.example.model.vo;

import lombok.Data;

@Data
public class ChatVO {
    private Integer chat_no;      // 채팅번호
    private String chat_file;     // 채팅 파일명
    private String chat_time;     // 채팅 발생 시간 (DB에 기록)
    private String customer_id;   // 고객 ID
    private String admin_id;      // 관리자 ID
    private String read_flag;     // 읽음 여부 "Y"/"N"
}
