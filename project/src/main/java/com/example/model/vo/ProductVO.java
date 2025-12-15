package com.example.model.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ProductVO {
	private Integer item_no;
	private String item_img;	//DB용
	private MultipartFile item_imgFile; // 업로드용
	private String item_name;
	private String item_content;
	private Integer origin_p;
	private Integer sales_p;
	private Integer stock_cnt;
	private Integer cate_no;
	private Integer dis_rate;
	private String cate_name;
	
	private Integer stock_in;   // 총 입고량
    private Integer stock_out;  // 총 출고량
	// 리뷰 평점 및 개수
	private Double avg_rating;
	private Integer review_cnt;
}
