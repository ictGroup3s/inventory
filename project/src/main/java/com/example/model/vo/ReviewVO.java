package com.example.model.vo;

import lombok.Data;

@Data
public class ReviewVO {

	private Integer review_no;
	private String re_title;
	private String re_content;
	private String re_date;
	private Integer item_no;
	private String customer_id;
	private Integer rating; // 평점 (1~5)
	
}