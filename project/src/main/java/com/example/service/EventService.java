package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.vo.ProductVO;

public interface EventService {
	List<ProductVO> getNewArrivals(int size,int offset);
	int getNewArrivalsCount();
	List<ProductVO> getDiscount(int size, int offset);
	int getDiscountCount();
	
	
	
}
