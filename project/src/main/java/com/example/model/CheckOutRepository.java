package com.example.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.cartVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class CheckOutRepository {

	@Autowired
	private SqlSessionTemplate sess;

	public List<cartVO> selectCart(cartVO vo) {
		log.info("[CheckOutRepository-selectCart()]");
		return sess.selectList("com.example.model.CheckOutRepository.selectCart", vo);
	}
	public List<cartVO> deleteCart(cartVO vo) {
		log.info("[CheckOutRepository-selectCart()]");
		return sess.selectList("com.example.model.CheckOutRepository.deleteCart", vo);
	
	}
}