package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.CheckOutRepository;
import com.example.model.vo.cartVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CheckOutServiceImple {
	
	@Autowired
	private CheckOutRepository repo;

	public List<cartVO> selectCart(cartVO vo) {
		log.info("[CheckOutService-selectCart()]");
		return repo.selectCart(vo);
	}
	
	 public List<cartVO> deleteCart(cartVO vo){
		 log.info("[CheckOutService-deleteCart]");
		 return repo.deleteCart(vo);
		 
	 }
}
