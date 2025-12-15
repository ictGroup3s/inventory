package com.example.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.ReviewVO;

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

}