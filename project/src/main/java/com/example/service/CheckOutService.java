package com.example.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.vo.ordersVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CheckOutService {
	
    public String requestMerchantPayKey(String productName, int totalPayAmount) {
        // 실제로는 네이버페이 서버 API 호출해서 merchantPayKey 발급
        // 여기서는 샘플용으로 임의 문자열 반환
        return "MERCHANT_PAY_KEY_123456";
        
    }
}