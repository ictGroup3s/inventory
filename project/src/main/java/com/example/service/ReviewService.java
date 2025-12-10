package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.ReviewRepository;
import com.example.model.vo.ReviewVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ReviewService {
	
	@Autowired
	private ReviewRepository reviewRepo;
	
	  // 상품 번호(item_no)로 리뷰 가져오기
    public List<ReviewVO> getReviewsByItemNo(Integer item_no) {
        return reviewRepo.selectReviewsByItemNo(item_no);
    }
    
    // 리뷰 작성
    public void addReview(ReviewVO review) {
        reviewRepo.add(review);   //매퍼 insert id값

    }
}