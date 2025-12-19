package com.example.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.ReviewRepository;
import com.example.model.ReviewImageRepository;
import com.example.model.vo.ReviewImageVO;
import com.example.model.vo.ReviewVO;

@Service
public class ReviewServiceImpl implements ReviewService {

	
	@Autowired
	private ReviewRepository reviewRepository;

	@Autowired
	private ReviewImageRepository reviewImageRepository;
	
	// 상품 번호(item_no)로 리뷰 가져오기
	public List<ReviewVO> getReviewList(Integer item_no) {
		List<ReviewVO> reviews = reviewRepository.selectReviewsByItemNo(item_no);
		if (reviews == null || reviews.isEmpty()) return reviews;

		List<ReviewImageVO> images = reviewImageRepository.selectImagesByItemNo(item_no);
		if (images == null || images.isEmpty()) return reviews;

		Map<Integer, List<String>> imageUrlsByReviewNo = new HashMap<>();
		Map<Integer, List<ReviewImageVO>> imageMetasByReviewNo = new HashMap<>();
		for (ReviewImageVO image : images) {
			if (image == null || image.getReview_no() == null || image.getImg_path() == null) continue;
			imageUrlsByReviewNo
				.computeIfAbsent(image.getReview_no(), k -> new ArrayList<>())
				.add("/img/review/" + image.getImg_path());
			imageMetasByReviewNo
				.computeIfAbsent(image.getReview_no(), k -> new ArrayList<>())
				.add(image);
		}

		for (ReviewVO review : reviews) {
			if (review == null || review.getReview_no() == null) continue;
			review.setImages(imageUrlsByReviewNo.getOrDefault(review.getReview_no(), new ArrayList<>()));
			review.setImageMetas(imageMetasByReviewNo.getOrDefault(review.getReview_no(), new ArrayList<>()));
		}
		return reviews;
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
		// FK 설정 여부와 상관없이 안전하게 먼저 이미지 레코드를 삭제
		try {
			reviewImageRepository.deleteByReviewNo(review_no);
		} catch (Exception ignored) {
			// 이미지 테이블이 아직 없거나(초기 적용 전) 매퍼 미적용 환경을 고려
		}
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