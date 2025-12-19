package com.example.model.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class crVO {
	
	private Integer cr_no;
	private Integer order_no;
	private Integer detail_no;
	private String type;
	private Integer return_cnt;// 교환일 경우 변경된 상품 detail_no
	private String status;
	private String reason;
	private Timestamp re_date; // 신청일
	
	private String item_name;
	private Integer item_count;
}
