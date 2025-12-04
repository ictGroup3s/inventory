package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.example.model.CheckOutRepository;
import com.example.model.vo.cartVO;
import com.example.model.vo.ordersVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CheckOutService {
	
	@Autowired
	private CheckOutRepository repo;
	
	/*
	 * public String requestMerchantPayKey(String productName, int totalPayAmount) {
	 * // 실제로는 네이버페이 서버 API 호출해서 merchantPayKey 발급 // 여기서는 샘플용으로 임의 문자열 반환 return
	 * "MERCHANT_PAY_KEY_123456";
	 * 
	 * } // 결제 정보를 DB에 저장
	 * 
	 * @Transactional public void savePayment(ordersVO vo) {
	 * 
	 * // 시퀀스 조회 (Mapper에서 처리) checkOutRepository.savePayment(vo);
	 * //vo.setOrder_no(seq);
	 * 
	 * }
	 */
    
	public List<cartVO> selectCart(cartVO vo) {
		return repo.selectCart(vo);
	}
	
	public List<cartVO> deleteCart(cartVO vo){
		return repo.deleteCart(vo);
	}

}