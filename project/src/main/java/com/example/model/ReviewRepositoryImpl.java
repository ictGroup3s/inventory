package com.example.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.ReviewVO;

import java.util.HashMap;
import java.util.Map;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class ReviewRepositoryImpl implements ReviewRepository {
	
	@Autowired
	private SqlSessionTemplate sess;
	
	public List<ReviewVO> selectReviewsByItemNo(Integer item_no) {
		List<ReviewVO> result =sess.selectList("com.example.model.ReviewRepository.selectReviewsByItemNo", item_no);
		
		return result;
	}
	
	public Integer add(ReviewVO review) {
		log.info("===> ReviewRepositoryImpl add() 호출");
		return sess.insert("com.example.model.ReviewRepository.add", review);		
	}
	
	public void delete(Integer review_no) {
		sess.delete("com.example.model.ReviewRepository.delete", review_no);		
	}
	public void update(ReviewVO review) {
		sess.update("com.example.model.ReviewRepository.update", review);		
	}

	@Override
	public int countReviewsByItemAndCustomer(Integer item_no, String customer_id) {
		Map<String, Object> param = new HashMap<>();
		param.put("item_no", item_no);
		param.put("customer_id", customer_id);
		Integer result = sess.selectOne("com.example.model.ReviewRepository.countReviewsByItemAndCustomer", param);
		return result == null ? 0 : result;
	}

	@Override
	public int countPurchasesByItemAndCustomer(Integer item_no, String customer_id) {
		Map<String, Object> param = new HashMap<>();
		param.put("item_no", item_no);
		param.put("customer_id", customer_id);
		Integer result = sess.selectOne("com.example.model.ReviewRepository.countPurchasesByItemAndCustomer", param);
		return result == null ? 0 : result;
	}

}