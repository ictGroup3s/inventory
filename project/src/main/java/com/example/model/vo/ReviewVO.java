package com.example.model.vo;

import java.util.List;

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
	private List<String> images; // "/img/review/{filename}" 형태 의 리뷰이미지 경로 리스트
	private List<ReviewImageVO> imageMetas; // 삭제/수정용 메타 (review_img_no, img_path 등)
	
}