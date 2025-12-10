package com.example.model;

import java.util.List;
import com.example.model.vo.ReviewVO;


public interface ReviewRepository {

	List<ReviewVO> selectReviewsByItemNo(Integer item_no);	
	void add(ReviewVO review);
}
