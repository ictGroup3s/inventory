package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.example.model.CheckOutRepository;
import com.example.model.vo.cartVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CheckOutService {
	
	@Autowired
	private CheckOutRepository checkOutRepository;
	
	public List<cartVO> selectCart(cartVO vo);
	
}