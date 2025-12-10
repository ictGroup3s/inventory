package com.example.model;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.example.model.vo.ReviewVO;

@Repository
@Mapper
public interface ReviewRepository {
	
	List<ReviewVO> selectReviewsByItemNo(@Param("item_no") Integer item_no);
	
	void add(ReviewVO review);
}