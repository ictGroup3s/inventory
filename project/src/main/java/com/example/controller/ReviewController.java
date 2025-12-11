package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.model.vo.ReviewVO;
import com.example.service.ReviewServiceImpl;

@RestController
@RequestMapping("/review")
public class ReviewController {

	@Autowired
	private ReviewServiceImpl reviewService;
	
	@GetMapping("/list")
	public List<ReviewVO> getReviewList(@RequestParam("item_no") Integer item_no){
		return reviewService.getReviewList(item_no);
		
	}
	
	@PostMapping("/add")
	public String addReview(ReviewVO review) {
		reviewService.addReview(review);
		return "등록성공";
	}
}
