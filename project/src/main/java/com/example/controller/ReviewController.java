package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.model.vo.CustomerVO;
import com.example.model.vo.ReviewVO;
import com.example.service.ReviewService;

import jakarta.servlet.http.HttpSession;

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
	public ResponseEntity<String> addReview(@RequestBody ReviewVO review, HttpSession session) {
		CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
		if (loginUser == null || loginUser.getCustomer_id() == null || loginUser.getCustomer_id().isBlank()) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 후 리뷰 작성이 가능합니다.");
		}

		if (review == null) {
			return ResponseEntity.badRequest().body("요청 데이터가 올바르지 않습니다.");
		}
		// 클라이언트에서 넘어온 customer_id는 신뢰하지 않음 (세션 기준으로 강제)
		review.setCustomer_id(loginUser.getCustomer_id());

		try {
			reviewService.addReview(review);
			return ResponseEntity.ok("리뷰가 등록되었습니다.");
		} catch (IllegalArgumentException e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		} catch (IllegalStateException e) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
		}
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