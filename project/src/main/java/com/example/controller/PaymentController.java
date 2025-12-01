package com.example.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.service.CheckOutService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class PaymentController {
	
	@GetMapping("/checkout")
	public String checkoutPage() {
	    return "checkout";  // checkout.jsp
	}
	
    @PostMapping("/start")
    public ResponseEntity<Map<String, String>> startPayment(@RequestBody Map<String, Object> data) {

        String productName = (String) data.get("productName");
        int totalPayAmount = (Integer) data.get("totalPayAmount");

        // 1) 네이버페이 API 호출해서 merchantPayKey 발급
        String merchantPayKey = CheckOutService.requestMerchantPayKey(productName, totalPayAmount);

        // 2) 응답 반환
        Map<String, String> response = new HashMap<>();
        response.put("merchantPayKey", merchantPayKey);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/return")
    public String paymentReturn() {
        // 결제 완료 후 돌아오는 페이지
        return "shop.jsp"; // JSP 이름
    }
}