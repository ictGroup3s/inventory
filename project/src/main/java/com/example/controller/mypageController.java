package com.example.controller;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.model.orderRepository;
import com.example.model.vo.CustomerVO;
import com.example.model.vo.crVO;
import com.example.model.vo.order_detailVO;
import com.example.model.vo.ordersVO;
import com.example.service.crService;
import com.example.service.orderService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class mypageController {
	
	@Autowired
    private orderRepository orderRepository;
	@Autowired
	private orderService orderService;
	@Autowired
	private crService crService;
	
	@GetMapping("/mypage")
	public String mypage(HttpSession session, Model model) {

	    log.info("=== mypage 컨트롤러 시작 ===");

	    CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        return "redirect:/login";
	    }

	    try {
	        String customerId  = loginUser.getCustomer_id();

	        // 1️⃣ 전체 주문 조회 (주문 + 상세 포함)
	        List<ordersVO> allOrders = orderService.getDeliveryGroupedList(customerId);

	        // 2️⃣ 최근 주문 5건만 자르기 ⭐⭐⭐
	        List<ordersVO> recentOrders = allOrders.size() > 5
	                ? allOrders.subList(0, 5)
	                : allOrders;

	        model.addAttribute("deliveryList", recentOrders);

	        // 3️⃣ CS 목록
	        List<crVO> crList = crService.getCrList(customerId);
	        model.addAttribute("crList", crList);

	        log.info("최근 주문 수: {}", recentOrders.size());
	        log.info("CS 수: {}", crList.size());

	    } catch (Exception e) {
	        log.error("mypage 데이터 조회 오류", e);
	    }

	    log.info("=== mypage 컨트롤러 종료 ===");
	    return "mypage";
	}
	
    // 주문내역 페이지
    @GetMapping("/order/mypage")
    public String orderList(HttpSession session, Model model) {
        try {
            // 로그인 체크
            CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
            if (loginUser == null) {
                return "redirect:/login";
            }
            
            // 전체 주문내역 조회
            List<order_detailVO> deliveryList = orderRepository.getDeliveryList(loginUser.getCustomer_id());
            
            // 로그로 확인
            log.info("주문내역 개수: {}", deliveryList.size());
            for (order_detailVO d : deliveryList) {
                log.info("주문번호: {}, 상품명: {}, 금액: {}", 
                    d.getOrder_no(), d.getItem_name(), d.getAmount());
            }
            
            model.addAttribute("deliveryList", deliveryList);
            return "/mypage";  // JSP 파일명
            
        } catch (SQLException e) {
            log.error("주문내역 조회 실패", e);
            model.addAttribute("error", "주문내역을 불러오는데 실패했습니다.");
            return "error";
        }
    }
	

}