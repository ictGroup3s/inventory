package com.example.controller;

import java.sql.SQLException;
import java.util.ArrayList;
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
	    
	    System.out.println("=== mypage 컨트롤러 시작 ===");
	    
	    // 1. 세션에서 로그인 정보 가져오기
	    CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
	    
	    if (loginUser == null) {
	        System.out.println("로그인 정보 없음 - 로그인 페이지로 이동");
	        return "redirect:/login";
	    }
	    
	    System.out.println("로그인 사용자: " + loginUser.getCustomer_id());
	    
	    try {
	        // 2. 주문 목록 가져오기
	        List<ordersVO> orderList = orderService.getOrders(loginUser);
	        System.out.println("주문 목록 개수: " + (orderList != null ? orderList.size() : 0));
	        model.addAttribute("orderList", orderList);
	        
	        // 3. 배송 목록 가져오기
	        List<ordersVO> deliveryList = orderService.getDeliveries(loginUser);
	        System.out.println("배송 목록 개수: " + (deliveryList != null ? deliveryList.size() : 0));
	        model.addAttribute("deliveryList", deliveryList);
	        
	        // 4. CS 목록 가져오기
	        List<crVO> crList = crService.getCrList(loginUser.getCustomer_id());
	        System.out.println("CS 목록 개수: " + (crList != null ? crList.size() : 0));
	        model.addAttribute("crList", crList);
	        
	     // ⭐ 주문번호만 추출해서 리스트로 만들기
	        List<Integer> orderNoList = new ArrayList<>();
	        if (orderList != null) {
	            for (ordersVO order : orderList) {
	                orderNoList.add(order.getOrder_no());
	            }
	        }
	        model.addAttribute("orderList", orderNoList); // 주문번호만 담긴 리스트
	        log.info("주문번호 리스트: {}", orderNoList);

	    } catch (Exception e) {
	        System.out.println("데이터 조회 중 오류 발생: " + e.getMessage());
	        e.printStackTrace();
	    }
	    
	    System.out.println("=== mypage 컨트롤러 종료 ===");
	    
	    return "/mypage";
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