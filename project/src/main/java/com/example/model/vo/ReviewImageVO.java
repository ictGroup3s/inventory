package com.example.model.vo;

import lombok.Data;

@Data
public class ReviewImageVO {
	private Integer review_img_no;
	private Integer review_no;
	private String img_path;
	private Integer sort_order;
	private String reg_date;
}
