package com.example.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
	    
		@GetMapping("/ordercomplete")
		public String ordercomplete() {
			return "ordercomplete";
		}
		
		@GetMapping("/payment")
		public String processPayment(
			    @RequestParam("item_no") List<String> itemNos,
			    @RequestParam("qty") List<Integer> qtys,
			    @RequestParam("cartTotal") int cartTotal,
			    Model model) {

			    // 1. 디버깅 로그 확인 (값이 정상적으로 들어왔다면 이 로그는 찍힐 것입니다.)
			    System.out.println("상품 번호 리스트: " + itemNos);
			    
			    // 2. 받은 데이터를 Model에 담아 JSP로 전달합니다. (이 과정이 누락되었는지 확인)
			    model.addAttribute("itemNos", itemNos);
			    model.addAttribute("qtys", qtys);
			    model.addAttribute("cartTotal", cartTotal); 
			    
			    // 3. 결제 페이지에서 필요한 다른 정보(예: 사용자 정보)도 Model에 담아야 합니다.

			    return "payment"; // payment.jsp로 이동
			}
	}
