package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.model.crRepository;
import com.example.model.vo.CustomerVO;
import com.example.model.vo.crVO;
import com.example.model.vo.ordersVO;
import com.example.service.crService;
import com.example.service.orderService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class mypageController {
	
	@Autowired
	private orderService orderService;
	@Autowired
	private crService crService;
   @Autowired
    private crRepository crRepository; 

	@GetMapping("/mypage")
	public String mypage(HttpSession session, Model model) {

	    log.info("=== mypage 컨트롤러 시작 ===");

	    CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        return "redirect:/login";
	    }

	    try {
	        String customerId = loginUser.getCustomer_id();

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

	        // 4️⃣ ⭐ 주문번호 목록 추가 (신청 모달용)
	        List<Integer> orderList = crRepository.getMyOrderNos(customerId);
	        model.addAttribute("orderList", orderList);

	        log.info("최근 주문 수: {}", recentOrders.size());
	        log.info("CS 수: {}", crList.size());
	        log.info("주문번호 목록 수: {}", orderList.size());

	    } catch (Exception e) {
	        log.error("mypage 데이터 조회 오류", e);
	    }

	    log.info("=== mypage 컨트롤러 종료 ===");
	    return "mypage";
	}
	
	

}