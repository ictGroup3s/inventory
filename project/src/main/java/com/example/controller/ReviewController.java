package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.model.vo.ReviewVO;
import com.example.service.ReviewService;

@RestController
@RequestMapping("/review")
public class ReviewController {

	@Autowired
	private ReviewService reviewService;
	
	@GetMapping("/list")
	public List<ReviewVO> getReviewList(@RequestParam("item_no") Integer item_no){
		return reviewService.getReviewList(item_no);
		
	}
	
	@PostMapping("/add")
	public String addReview(@RequestBody ReviewVO review) {
		reviewService.addReview(review);
		return "리뷰가 등록되었습니다." + review.getItem_no();
	}
	
	@PostMapping("/delete")
	public String deleteReview(@RequestParam("review_no") Integer review_no) {
		reviewService.deleteReview(review_no);
		return "success";
	}

	@PostMapping("/update")
	public String updateReview(@RequestBody ReviewVO review) {
		reviewService.updateReview(review);
		return "success";
	}
}