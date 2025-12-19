package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.model.ReviewImageRepository;
import com.example.model.vo.CustomerVO;
import com.example.model.vo.ReviewImageVO;
import com.example.model.vo.ReviewVO;
import com.example.service.ReviewService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/review")
public class ReviewController {

	@Autowired
	private ReviewService reviewService;

	@Autowired
	private ReviewImageRepository reviewImageRepository;
	
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

	@PostMapping(value = "/addWithImages", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	public ResponseEntity<String> addReviewWithImages(
			@RequestParam("item_no") Integer item_no,
			@RequestParam("re_title") String re_title,
			@RequestParam("re_content") String re_content,
			@RequestParam(value = "rating", required = false) Integer rating,
			@RequestParam(value = "images", required = false) MultipartFile[] images,
			HttpSession session) {

		CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
		if (loginUser == null || loginUser.getCustomer_id() == null || loginUser.getCustomer_id().isBlank()) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 후 리뷰 작성이 가능합니다.");
		}

		ReviewVO review = new ReviewVO();
		review.setItem_no(item_no);
		review.setRe_title(re_title);
		review.setRe_content(re_content);
		review.setRating(rating);
		review.setCustomer_id(loginUser.getCustomer_id());

		try {
			reviewService.addReview(review);
		} catch (IllegalArgumentException e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		} catch (IllegalStateException e) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
		}

		Integer reviewNo = review.getReview_no();
		if (reviewNo == null) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("리뷰 저장에 실패했습니다.");
		}

		// 이미지 저장 (선택)
		if (images != null && images.length > 0) {
			String savePath = System.getProperty("user.dir") + "\\src\\main\\resources\\static\\img\\review";
			File dir = new File(savePath);
			if (!dir.exists()) {
				dir.mkdirs();
			}

			List<String> savedFileNames = new ArrayList<>();
			for (int i = 0; i < images.length; i++) {
				MultipartFile file = images[i];
				if (file == null || file.isEmpty()) continue;

				String safeOriginal = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
				String fileName = System.currentTimeMillis() + "_" + i + "_" + safeOriginal;
				File dest = new File(dir, fileName);
				try {
					file.transferTo(dest);
					savedFileNames.add(fileName);
				} catch (IOException e) {
					log.error("Review image file save failed. dest={}, reviewNo={}, customerId={}", dest.getAbsolutePath(), reviewNo, loginUser.getCustomer_id(), e);
					return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
							.body("리뷰는 등록되었지만, 이미지 저장에 실패했습니다.");
				} catch (Exception e) {
					log.error("Review image file save failed (unexpected). dest={}, reviewNo={}, customerId={}", dest.getAbsolutePath(), reviewNo, loginUser.getCustomer_id(), e);
					// 파일 저장 실패는 전체 리뷰를 실패로 만들지 않고(이미 리뷰는 저장됨), 메시지만 반환
					return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
							.body("리뷰는 등록되었지만, 이미지 저장에 실패했습니다.");
				}
			}

			for (int i = 0; i < savedFileNames.size(); i++) {
				ReviewImageVO image = new ReviewImageVO();
				image.setReview_no(reviewNo);
				image.setImg_path(savedFileNames.get(i));
				image.setSort_order(i);
				try {
					reviewImageRepository.insert(image);
				} catch (Exception e) {
					log.error("Review image DB insert failed. reviewNo={}, fileName={}, customerId={}", reviewNo, savedFileNames.get(i), loginUser.getCustomer_id(), e);
					// DB 저장 실패 시, 이미 저장된 파일은 정리(최대한)
					try {
						for (String fn : savedFileNames) {
							File f = new File(dir, fn);
							if (f.exists()) {
								boolean deleted = f.delete();
								if (!deleted) {
									log.warn("Failed to delete orphan review image file: {}", f.getAbsolutePath());
								}
							}
						}
					} catch (Exception cleanupEx) {
						log.warn("Cleanup after DB failure failed. reviewNo={}", reviewNo, cleanupEx);
					}
					return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
							.body("리뷰는 등록되었지만, 이미지 DB 저장에 실패했습니다.");
				}
			}
		}

		return ResponseEntity.ok("리뷰가 등록되었습니다.");
	}

	@PostMapping(value = "/updateWithImages", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	public ResponseEntity<String> updateReviewWithImages(
			@RequestParam("review_no") Integer review_no,
			@RequestParam("re_content") String re_content,
			@RequestParam(value = "rating", required = false) Integer rating,
			@RequestParam(value = "delete_img_no", required = false) List<Integer> delete_img_no,
			@RequestParam(value = "images", required = false) MultipartFile[] images,
			HttpSession session) {

		CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
		if (loginUser == null || loginUser.getCustomer_id() == null || loginUser.getCustomer_id().isBlank()) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 후 이용 가능합니다.");
		}
		if (review_no == null) {
			return ResponseEntity.badRequest().body("review_no is required");
		}

		// 1) 내용/평점 업데이트
		ReviewVO review = new ReviewVO();
		review.setReview_no(review_no);
		review.setRe_content(re_content);
		review.setRating(rating);
		try {
			reviewService.updateReview(review);
		} catch (Exception e) {
			log.error("Review update failed. reviewNo={}, customerId={}", review_no, loginUser.getCustomer_id(), e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("리뷰 수정에 실패했습니다.");
		}

		String savePath = System.getProperty("user.dir") + "\\src\\main\\resources\\static\\img\\review";
		File dir = new File(savePath);
		if (!dir.exists()) {
			dir.mkdirs();
		}

		// 2) 선택 이미지 삭제 (DB + 파일)
		if (delete_img_no != null && !delete_img_no.isEmpty()) {
			Set<Integer> deleteSet = new HashSet<>(delete_img_no);
			try {
				List<ReviewImageVO> existing = reviewImageRepository.selectImagesByReviewNo(review_no);
				if (existing != null) {
					for (ReviewImageVO img : existing) {
						if (img == null || img.getReview_img_no() == null) continue;
						if (!deleteSet.contains(img.getReview_img_no())) continue;
						if (img.getImg_path() != null) {
							File f = new File(dir, img.getImg_path());
							if (f.exists() && !f.delete()) {
								log.warn("Failed to delete review image file: {}", f.getAbsolutePath());
							}
						}
					}
				}

				reviewImageRepository.deleteByIds(delete_img_no);
			} catch (Exception e) {
				log.error("Review image delete failed. reviewNo={}, deleteIds={}, customerId={}", review_no, delete_img_no, loginUser.getCustomer_id(), e);
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이미지 삭제에 실패했습니다.");
			}
		}

		// 3) 새 이미지 추가
		if (images != null && images.length > 0) {
			int startOrder = 0;
			try {
				List<ReviewImageVO> remaining = reviewImageRepository.selectImagesByReviewNo(review_no);
				startOrder = remaining == null ? 0 : remaining.size();
			} catch (Exception ignored) {
				startOrder = 0;
			}

			List<String> savedFileNames = new ArrayList<>();
			for (int i = 0; i < images.length; i++) {
				MultipartFile file = images[i];
				if (file == null || file.isEmpty()) continue;
				String safeOriginal = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
				String fileName = System.currentTimeMillis() + "_" + i + "_" + safeOriginal;
				File dest = new File(dir, fileName);
				try {
					file.transferTo(dest);
					savedFileNames.add(fileName);
				} catch (Exception e) {
					log.error("Review image file save failed during update. dest={}, reviewNo={}, customerId={}", dest.getAbsolutePath(), review_no, loginUser.getCustomer_id(), e);
					return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이미지 저장에 실패했습니다.");
				}
			}

			for (int i = 0; i < savedFileNames.size(); i++) {
				ReviewImageVO image = new ReviewImageVO();
				image.setReview_no(review_no);
				image.setImg_path(savedFileNames.get(i));
				image.setSort_order(startOrder + i);
				try {
					reviewImageRepository.insert(image);
				} catch (Exception e) {
					log.error("Review image DB insert failed during update. reviewNo={}, fileName={}, customerId={}", review_no, savedFileNames.get(i), loginUser.getCustomer_id(), e);
					return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이미지 DB 저장에 실패했습니다.");
				}
			}
		}

		return ResponseEntity.ok("success");
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