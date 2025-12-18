package com.example.model;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;


import com.example.model.vo.ProductVO;

@Mapper
public interface EventRepository { 
	
	List<ProductVO> selectNewArrivals(Map<String, Object>params);
	int selectNewArrivalsCount();
	List<ProductVO> selectDiscount(Map<String, Object>params);
	int selectDiscountCount();
}
