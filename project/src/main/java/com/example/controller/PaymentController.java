package com.example.controller;


import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.model.vo.CustomerVO;
import com.example.model.vo.ordersVO;
import com.example.service.orderService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping
public class PaymentController {
	
		@Autowired
		private orderService orderService;
	
		/* 카카오결제 */
	    @GetMapping("/kakao")
	    public String kakaoPay() {
	        return "kakao"; // WEB-INF/views/payment/kakao.jsp
	    }
	    /* 네이버결제 */
	    @GetMapping("/naver")
	    public String naverPay() {
	        return "naver"; // WEB-INF/views/payment/naver.jsp
	    }
	    
	    @PostMapping("/processPayment")
	    @ResponseBody
	    public Map<String, Object> processPayment(
	        @RequestParam String name,
	        @RequestParam String phone,
	        @RequestParam String address,
	        @RequestParam(required = false) String shipName,
	        @RequestParam(required = false) String shipPhone,
	        @RequestParam(required = false) String shipAddress,
	        @RequestParam(required = false) String memo,
	        @RequestParam(required = false) String cardType,
	        HttpSession session
	    ) {
	    	log.info("========== 결제 처리 시작 ==========");
	        log.info("받은 데이터 - 이름: {}, 전화번호: {}, 주소: {}", name, phone, address);
	        log.info("배송지 - 이름: {}, 전화번호: {}, 주소: {}", shipName, shipPhone, shipAddress);
	        
	        Map<String, Object> result = new HashMap();
	        
	        try {
	            // 전화번호 처리 - 하이픈 제거 및 유효성 검사
	            String cleanPhone = phone.replaceAll("[^0-9]", ""); // 숫자만 추출
	            String cleanShipPhone = (shipPhone != null && !shipPhone.isEmpty()) 
	                ? shipPhone.replaceAll("[^0-9]", "") 
	                : cleanPhone;
	            
	            log.info("정제된 전화번호: {}, 배송지 전화번호: {}", cleanPhone, cleanShipPhone);
	            // 전화번호가 비어있거나 숫자가 아닌 경우 처리
	            if (cleanPhone.isEmpty()) {
	                result.put("success", false);
	                result.put("message", "올바른 전화번호를 입력해주세요.");
	                return result;
	            }
	            
	            // ordersVO 객체 생성
	            ordersVO order = new ordersVO();
	            order.setOrder_name(shipName != null && !shipName.isEmpty() ? shipName : name);
	            order.setOrder_phone(Integer.parseInt(cleanShipPhone)); // 정제된 전화번호 사용
	            order.setOrder_addr(shipAddress != null && !shipAddress.isEmpty() ? shipAddress : address);
	            order.setPayment(cardType != null ? cardType : "카드결제");
	            order.setOrder_status("결제완료");
	            
	            // 세션에서 사용자 ID 가져오기 (로그인 되어 있다면)
	            CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");

	            if (loginUser != null) {
	                String customerId = loginUser.getCustomer_id();
	                order.setCustomer_id(customerId);
	                log.info("세션에서 가져온 customerId: {}", customerId);
	            } else {
	                log.info("로그인된 사용자 없음 → customerId는 null");
	            }
	            
	            log.info("세션에서 가져온 customerId: {}", loginUser);
		        log.info("세션 ID: {}", session.getId());
	            log.info("DB 저장 시도...");
	            
	            // 주문 저장
	            int orderNo = orderService.createOrder(order);
	            log.info("✅ DB 저장 성공! 주문번호: {}", orderNo);
	            log.info("생성된 주문 객체: {}", order);
	        
	            // 장바구니 비우기
	            session.removeAttribute("cartItems");
	            session.removeAttribute("cartTotal");
	            session.removeAttribute("cartCount");
	            
	            result.put("success", true);
	            result.put("orderNo", orderNo);
	            log.info("========== 결제 처리 완료 ==========");
	            return result;
	            
	        } catch (NumberFormatException e) {
	            log.error("전화번호 변환 오류: ", e);
	            result.put("success", false);
	            result.put("message", "전화번호 형식이 올바르지 않습니다.");
	            return result;
	            
	        } catch (Exception e) {
	            log.error("주문 처리 오류: ", e);
	            result.put("success", false);
	            result.put("message", "주문 처리 중 오류가 발생했습니다.");
	            return result;
	        }
	    }
	}