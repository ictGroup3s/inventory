package com.example.model;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.ordersVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class CheckOutRepository {
	
	@Autowired
	private SqlSessionTemplate sess;
	
	public void savePayment(ordersVO vo) {
		sess.insert("CheckOutMapper.savePayment", vo);
	}
}
