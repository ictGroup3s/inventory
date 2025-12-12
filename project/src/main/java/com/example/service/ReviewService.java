package com.example.service;

import java.util.List;

import com.example.model.vo.ReviewVO;

public interface ReviewService {

	List<ReviewVO> getReviewList(Integer item_no);
	Integer addReview(ReviewVO review);
	void deleteReview(Integer review_no);
	void updateReview(ReviewVO review);
}