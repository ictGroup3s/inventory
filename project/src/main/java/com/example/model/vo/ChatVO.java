package com.example.model.vo;

import lombok.Data;

@Data
public class ChatVO {
	private Integer chat_no;
	private String chat_file;
	private String chat_time;
	private String customer_id;
	private String admin_id;
}
