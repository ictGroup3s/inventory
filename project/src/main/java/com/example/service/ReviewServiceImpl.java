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
		if (review == null || review.getItem_no() == null) {
			throw new IllegalArgumentException("item_no is required");
		}
		if (review.getCustomer_id() == null || review.getCustomer_id().isBlank()) {
			throw new IllegalArgumentException("customer_id is required");
		}

		String customerId = review.getCustomer_id();
		Integer itemNo = review.getItem_no();

		int purchaseCount = reviewRepository.countPurchasesByItemAndCustomer(itemNo, customerId);
		if (purchaseCount <= 0) {
			throw new IllegalStateException("상품구매 이후 리뷰 작성이 가능합니다.");
		}
		int existingCount = reviewRepository.countReviewsByItemAndCustomer(itemNo, customerId);
		if (existingCount >= purchaseCount) {
			throw new IllegalStateException("구매 횟수만큼만 리뷰 작성이 가능합니다. (구매 " + purchaseCount + "회 / 작성 " + existingCount + "회)");
		}

		Integer result = reviewRepository.add(review);  // 매퍼 insert id값="add"
		return result;
	}
	
	public void deleteReview(Integer review_no) {
		reviewRepository.delete(review_no);
	}

	public void updateReview(ReviewVO review) {
		reviewRepository.update(review);
	}

	@Override
	public boolean canWriteReview(String customerId, Integer itemNo) {
		if (customerId == null || customerId.isBlank() || itemNo == null) return false;
		int purchaseCount = reviewRepository.countPurchasesByItemAndCustomer(itemNo, customerId);
		if (purchaseCount <= 0) return false;
		int existingCount = reviewRepository.countReviewsByItemAndCustomer(itemNo, customerId);
		return existingCount < purchaseCount;
	}

	@Override
	public String getReviewWriteBlockReason(String customerId, Integer itemNo) {
		if (customerId == null || customerId.isBlank()) return "로그인 후 리뷰 작성이 가능합니다.";
		if (itemNo == null) return "상품 정보가 올바르지 않습니다.";
		int purchaseCount = reviewRepository.countPurchasesByItemAndCustomer(itemNo, customerId);
		if (purchaseCount <= 0) return "상품 구매 이후 리뷰 작성이 가능합니다.";
		int existingCount = reviewRepository.countReviewsByItemAndCustomer(itemNo, customerId);
		if (existingCount >= purchaseCount) return "등록된 리뷰가 있습니다. (구매 " + purchaseCount + "회 / 작성 " + existingCount + "회)";
		return null;
	}
	
}