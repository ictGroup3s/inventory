package com.example.model;

import java.util.List;

import java.util.List;

import com.example.model.vo.ReviewImageVO;

public interface ReviewImageRepository {
	int insert(ReviewImageVO image);
	List<ReviewImageVO> selectImagesByItemNo(Integer item_no);
	List<ReviewImageVO> selectImagesByReviewNo(Integer review_no);
	int deleteByReviewNo(Integer review_no);
	int deleteByIds(List<Integer> review_img_no_list);
}
