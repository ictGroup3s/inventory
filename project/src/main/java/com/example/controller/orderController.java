package com.example.controller;


import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.model.orderRepository;
import com.example.model.vo.CartItemVO;
import com.example.model.vo.CustomerVO;
import com.example.model.vo.order_detailVO;
import com.example.model.vo.ordersVO;
import com.example.service.CartService;
import com.example.service.orderService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class orderController {

	    private final orderRepository repo;
	    private final CartService cartService; // 장바구니 서비스
	    private orderService service;

	    public orderController(orderRepository repo, CartService cartService) {
	        this.repo = repo;
	        this.cartService = cartService;
	    }

	    // 결제 버튼 클릭 → 주문 저장 → 결제 완료 페이지 이동
	    @PostMapping("/checkout")
	    public String processCheckout(HttpSession session) throws Exception {
	        String loginUser = (String) session.getAttribute("loginUser");

	        // 1. 주문 저장
	        int orderNo = repo.insertOrder(loginUser);

	        // 2. 장바구니 기반 주문 상세 저장
	        List<CartItemVO> cartItems = cartService.getCartItems(session);
	        repo.insertOrderDetail(orderNo, cartItems);

	        // 3. 방금 주문한 번호를 세션에 저장
	        session.setAttribute("lastOrderNo", orderNo);

	        // 4. 결제 완료 페이지로 이동
	        return "redirect:/ordercomplete";
	    }

	    
	 // ⭐⭐⭐ 주문내역 페이지 - 결제완료된 주문만 조회
	    @GetMapping("/orderhistory")
	    public String orderHistory(HttpSession session, Model model) {
	        log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
	        log.info("┃  🔍 주문내역 조회 시작                              ┃");
	        log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
	        
	        try {
	            // 1. 세션 확인
	            log.info("📌 STEP 1: 세션 확인");
	            log.info("   - 세션 ID: {}", session.getId());
	            log.info("   - 세션 속성 목록:");
	            session.getAttributeNames().asIterator().forEachRemaining(name -> {
	                log.info("     * {}: {}", name, session.getAttribute(name));
	            });
	            
	            // 2. 로그인 체크
	            log.info("📌 STEP 2: 로그인 사용자 확인");
	            CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
	            
	            if (loginUser == null) {
	                log.error("❌ 로그인 정보 없음! 로그인 페이지로 리다이렉트");
	                return "redirect:/login";
	            }
	            
	            String customerId = loginUser.getCustomer_id();
	            log.info("   ✅ 로그인 사용자 정보:");
	            log.info("      - ID: {}", customerId);
	            log.info("      - 이름: {}", loginUser.getName());
	            log.info("      - 이메일: {}", loginUser.getEmail());
	            
	            // 3. DB 조회
	            log.info("📌 STEP 3: DB 조회 시작");
	            log.info("   - 조회 대상 customer_id: {}", customerId);
	            log.info("   - orderRepository 객체: {}", repo != null ? "정상" : "NULL!");
	            
	            List<order_detailVO> deliveryList = null;
	            
	            try {
	                deliveryList = repo.getDeliveryList(customerId);
	                log.info("   ✅ DB 조회 성공!");
	            } catch (SQLException e) {
	                log.error("   ❌ DB 조회 중 SQL 에러 발생!", e);
	                log.error("   SQL 에러 메시지: {}", e.getMessage());
	                log.error("   SQL State: {}", e.getSQLState());
	                log.error("   Error Code: {}", e.getErrorCode());
	                throw e;
	            }
	            
	            // 4. 조회 결과 확인
	            log.info("📌 STEP 4: 조회 결과 확인");
	            log.info("   - deliveryList 객체: {}", deliveryList != null ? "정상" : "NULL!");
	            log.info("   - 조회된 주문 개수: {}", deliveryList != null ? deliveryList.size() : 0);
	            
	            if (deliveryList != null && !deliveryList.isEmpty()) {
	                log.info("   ✅ 주문 내역 상세:");
	                for (int i = 0; i < deliveryList.size(); i++) {
	                    order_detailVO item = deliveryList.get(i);
	                    log.info("   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
	                    log.info("   [주문 #{}]", (i + 1));
	                    log.info("      - 주문번호: {}", item.getOrder_no());
	                    log.info("      - 상품명: {}", item.getItem_name());
	                    log.info("      - 상품번호: {}", item.getItem_no());
	                    log.info("      - 수량: {}", item.getItem_cnt());
	                    log.info("      - 단가: {}원", item.getItem_price());
	                    log.info("      - 금액: {}원", item.getAmount());
	                    log.info("      - 주문상태: {}", item.getOrder_status());
	                    log.info("      - 주문일시: {}", item.getOrder_date());
	                }
	            } else {
	                log.warn("   ⚠️ 조회된 주문내역이 없습니다!");
	                log.warn("   💡 확인사항:");
	                log.warn("      1. DB에 customer_id = '{}' 인 주문이 있나요?", customerId);
	                log.warn("      2. 주문 상태가 '결제완료' 인가요?");
	                log.warn("      3. orders 테이블과 order_detail 테이블에 데이터가 있나요?");
	            }
	            
	            // 5. Model에 데이터 추가
	            log.info("📌 STEP 5: JSP로 데이터 전달");
	            model.addAttribute("deliveryList", deliveryList);
	            log.info("   - Model에 deliveryList 추가 완료");
	            log.info("   - 반환할 JSP: orderhistory.jsp");
	            
	            log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
	            log.info("┃  ✅ 주문내역 조회 완료                              ┃");
	            log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
	            
	            return "orderhistory";
	            
	        } catch (SQLException e) {
	            log.error("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
	            log.error("┃  ❌ SQL 에러 발생!                                  ┃");
	            log.error("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
	            log.error("에러 메시지: {}", e.getMessage());
	            e.printStackTrace();
	            model.addAttribute("error", "주문내역을 불러오는데 실패했습니다: " + e.getMessage());
	            return "orderhistory";
	            
	        } catch (Exception e) {
	            log.error("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
	            log.error("┃  ❌ 예상치 못한 에러 발생!                          ┃");
	            log.error("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
	            log.error("에러 타입: {}", e.getClass().getName());
	            log.error("에러 메시지: {}", e.getMessage());
	            e.printStackTrace();
	            model.addAttribute("error", "주문내역을 불러오는데 실패했습니다: " + e.getMessage());
	            return "orderhistory";
	        }
	    }
	    
	    // 기존 /order/mypage 매핑 (필요하면 유지)
	    @GetMapping("/mydelivery")
	    public String myDelivery(HttpSession session, Model model) {
	        try {
	            log.info("========== 배송내역 조회 시작 ==========");
	            
	            CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
	            if (loginUser == null) {
	                return "redirect:/login";
	            }
	            
	            String customerId = loginUser.getCustomer_id();
	            
	            // ⭐ 그룹핑된 주문 목록 조회
	            List<ordersVO> orderList = repo.getDeliveryGroupedList(customerId);
	            
	            log.info("조회된 주문 개수: {}", orderList.size());
	            
	            // ⭐⭐⭐ 디버깅: 각 주문의 detailList 확인
	            for (ordersVO order : orderList) {
	                log.info("주문번호: {}, detailList 크기: {}", 
	                    order.getOrder_no(), 
	                    order.getDetailList() != null ? order.getDetailList().size() : "NULL");
	                
	                if (order.getDetailList() != null) {
	                    for (order_detailVO detail : order.getDetailList()) {
	                        log.info("  - 상품: {}", detail.getItem_name());
	                    }
	                }
	            }
	            
	            model.addAttribute("orderList", orderList);
	            
	            return "mydelivery";
	            
	        } catch (Exception e) {
	            log.error("❌ 배송내역 조회 중 오류 발생", e);
	            e.printStackTrace();
	            return "mydelivery";
	        }
	    }
	    
	    
}