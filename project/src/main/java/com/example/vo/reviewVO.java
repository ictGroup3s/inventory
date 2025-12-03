package com.example.vo;

import lombok.Data;

@Data
public class reviewVO {

	private Integer review_no;
	private String re_title;
	private String re_content;
	private String re_date;
	private Integer item_no;
	private String customer_id;
	
}
