package com.example.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.ReviewVO;

@Repository
public class ReviewRepositoryImpl implements ReviewRepository {
	
	@Autowired
	SqlSessionTemplate sqlsession;
	
	public List<ReviewVO> selectReviewsByItemNo(Integer item_no) {
		List<ReviewVO> result =sqlsession.selectList("com.example.model.ReviewRepository.selectReviewsByItemNo", item_no);
		
		return result;
	}
	
	public void add(ReviewVO review) {
		sqlsession.insert("com.example.model.ReviewRepository.add", review);
	}

}
