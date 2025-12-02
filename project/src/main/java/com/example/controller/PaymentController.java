package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping
public class PaymentController {
	
	    @GetMapping("/kakao")
	    public String kakaoPay() {
	        return "kakao"; // WEB-INF/views/payment/kakao.jsp
	    }

	    @GetMapping("/naver")
	    public String naverPay() {
	        return "naver"; // WEB-INF/views/payment/naver.jsp
	    }
	}

