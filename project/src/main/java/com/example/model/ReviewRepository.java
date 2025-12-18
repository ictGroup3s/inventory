package com.example.model;

import java.util.List;
import com.example.model.vo.ReviewVO;


public interface ReviewRepository {

	List<ReviewVO> selectReviewsByItemNo(Integer item_no);	
	public Integer add(ReviewVO review);
	public void delete(Integer review_no);
	public void update(ReviewVO review);
	
	int countReviewsByItemAndCustomer(Integer item_no, String customer_id);
	int countPurchasesByItemAndCustomer(Integer item_no, String customer_id);
}