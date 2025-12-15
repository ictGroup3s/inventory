package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.ReviewRepository;
import com.example.model.vo.ReviewVO;

@Service
public class ReviewServiceImpl implements ReviewService {

	
	@Autowired
	private ReviewRepository reviewRepository;
	
	// 상품 번호(item_no)로 리뷰 가져오기
	public List<ReviewVO> getReviewList(Integer item_no) {
		return reviewRepository.selectReviewsByItemNo(item_no);
	}
	
	// 리뷰 작성
	public Integer addReview(ReviewVO review) {
		Integer result = reviewRepository.add(review);  // 매퍼 insert id값="add"
		return result;
	}
	
	public void deleteReview(Integer review_no) {
		reviewRepository.delete(review_no);
	}

	public void updateReview(ReviewVO review) {
		reviewRepository.update(review);
	}
	
}