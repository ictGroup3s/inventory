package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.example.model.CheckOutRepository;
import com.example.model.vo.cartVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CheckOutService {
	
	@Autowired
	private CheckOutRepository repo;

    // 장바구니 조회
    public List<cartVO> selectCart(cartVO vo) {
        return repo.selectCart(vo);
    }

    // 장바구니 삭제
    public List<cartVO> deleteCart(cartVO vo){
        return repo.deleteCart(vo);
    }
    /*
     * // 예시: 결제 처리 (필요 시 구현)
     * @Transactional
     * public void savePayment(ordersVO vo) {
     *     repo.savePayment(vo);
     * }
     */
}