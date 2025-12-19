package com.example.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.model.vo.CartItemVO;
import com.example.model.vo.CustomerVO;
import com.example.model.vo.ordersVO;
import com.example.service.CartService;
import com.example.service.orderService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping
public class PaymentController {
	
		@Autowired
		private orderService orderService;
		
	    @Autowired
	    private CartService cartService; 
		
	
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
	        @RequestParam(required = false) String paymentType,  // ⭐⭐⭐ 추가!
	        HttpSession session
	    ) {
	        log.info("========== 결제 처리 시작 ==========");
	        log.info("받은 데이터 - 이름: {}, 전화번호: {}, 주소: {}", name, phone, address);
	        log.info("배송지 - 이름: {}, 전화번호: {}, 주소: {}", shipName, shipPhone, shipAddress);
	        log.info("⭐ 결제 방식: {}, 카드사: {}", paymentType, cardType);  // ⭐⭐⭐ 로그 추가!
	        
	        Map<String, Object> result = new HashMap<>();
	        
	        try {
	            // 1. 세션에서 로그인 사용자 정보 가져오기
	            CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
	            
	            if (loginUser == null) {
	                log.warn("❌ 로그인되지 않은 사용자");
	                result.put("success", false);
	                result.put("message", "로그인이 필요합니다.");
	                return result;
	            }
	            
	            String customerId = loginUser.getCustomer_id();
	            log.info("✅ 로그인 사용자: {}", customerId);
	            log.info("세션 ID: {}", session.getId());
	            
	            // 2. ⭐ 장바구니 정보 조회
	            List<CartItemVO> cartItems = cartService.getCartItems(session);
	            
	            if (cartItems == null || cartItems.isEmpty()) {
	                log.warn("❌ 장바구니가 비어있음");
	                result.put("success", false);
	                result.put("message", "장바구니가 비어있습니다.");
	                return result;
	            }
	            
	            log.info("장바구니 상품 개수: {}", cartItems.size());
	            for (CartItemVO item : cartItems) {
	                log.info("  - 상품번호: {}, 수량: {}, 가격: {}", 
	                    item.getProduct().getItem_no(), 
	                    item.getQty(), 
	                    item.getProduct().getSales_p());
	            }
	            // ⭐ 총 결제 금액 계산
	            int totalAmount = 0;
	            for (CartItemVO item : cartItems) {
	                totalAmount += item.getProduct().getSales_p() * item.getQty();
	            }
	            log.info("총 결제 금액: {}", totalAmount);
	            
	            // 3. 전화번호 처리
	            String cleanPhone = phone.replaceAll("[^0-9]", "");
	            String cleanShipPhone = (shipPhone != null && !shipPhone.isEmpty()) 
	                ? shipPhone.replaceAll("[^0-9]", "") 
	                : cleanPhone;
	            
	            log.info("정제된 전화번호: {}, 배송지 전화번호: {}", cleanPhone, cleanShipPhone);
	            
	            if (cleanPhone.isEmpty()) {
	                result.put("success", false);
	                result.put("message", "올바른 전화번호를 입력해주세요.");
	                return result;
	            }
	            
	            // ⭐⭐⭐ 4. 결제 방식 결정 로직 추가!
	            String finalPayment = "";
	            
	            if (paymentType != null && !paymentType.isEmpty()) {
	                switch (paymentType) {
	                    case "card":
	                        finalPayment = cardType != null ? cardType + " 카드결제" : "카드결제";
	                        break;
	                    case "bank":
	                        finalPayment = "계좌이체";
	                        break;
	                    case "naver":
	                        finalPayment = "네이버페이";
	                        break;
	                    case "kakao":
	                        finalPayment = "카카오페이";
	                        break;
	                    default:
	                        finalPayment = "카드결제";
	                }
	            } else {
	                // paymentType이 없는 경우 (기존 방식 호환)
	                finalPayment = cardType != null ? cardType : "카드결제";
	            }
	            
	            log.info("⭐ 최종 저장될 결제 방식: {}", finalPayment);
	            
	            // 5. ordersVO 객체 생성
	            ordersVO order = new ordersVO();
	            order.setOrder_name(shipName != null && !shipName.isEmpty() ? shipName : name);
	            order.setOrder_phone(Long.parseLong(cleanShipPhone));
	            order.setOrder_addr(shipAddress != null && !shipAddress.isEmpty() ? shipAddress : address);
	            order.setPayment(finalPayment);  // ⭐⭐⭐ 결제 방식 설정!
	            order.setOrder_status("결제완료");
	            order.setCustomer_id(customerId);
	            order.setTotal_amount(totalAmount);
	            order.setRequest(memo);  // 요청사항 추가
	            
	            log.info("생성된 주문 객체: {}", order);
	            log.info("DB 저장 시도...");
	            
	            // 6. ⭐ 주문 생성 (장바구니 아이템 포함)
	            int orderNo = orderService.createOrder(order, cartItems);
	            
	            log.info("✅ DB 저장 성공! 주문번호: {}", orderNo);
	            
	            // 7. 세션 장바구니 정보 제거
	            session.removeAttribute("cartItems");
	            session.removeAttribute("cartTotal");
	            session.removeAttribute("cartCount");
	            
	            result.put("success", true);
	            result.put("orderNo", orderNo);
	            result.put("totalAmount", totalAmount); 
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
	    
	    @PostMapping("/validateCheckout")
	    public String processPayment(
	        @RequestParam String name,
	        @RequestParam String email,
	        @RequestParam String phone,
	        @RequestParam String address,
	        Model model,
	        RedirectAttributes redirectAttributes
	    ) {
	        boolean hasError = false;
	        
	        if (name == null || name.trim().isEmpty()) {
	            model.addAttribute("nameError", "이름을 입력해주세요.");
	            hasError = true;
	        }
	        
	        if (email == null || email.trim().isEmpty()) {
	            model.addAttribute("emailError", "이메일을 입력해주세요.");
	            hasError = true;
	        } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
	            model.addAttribute("emailError", "올바른 이메일 형식이 아닙니다.");
	            hasError = true;
	        }
	        
	        if (phone == null || phone.trim().isEmpty()) {
	            model.addAttribute("phoneError", "전화번호를 입력해주세요.");
	            hasError = true;
	        }
	        
	        if (address == null || address.trim().isEmpty()) {
	            model.addAttribute("addressError", "주소를 입력해주세요.");
	            hasError = true;
	        }
	        
	        if (hasError) {
	            // 입력값 유지
	            model.addAttribute("name", name);
	            model.addAttribute("email", email);
	            model.addAttribute("phone", phone);
	            model.addAttribute("address", address);
	            return "checkout"; // 다시 결제 페이지로
	        }
	        
	        // 검증 통과 시 결제 처리
	        return "ordercomplete";
	    }
	}