package com.example.controller;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.model.orderRepository;
import com.example.model.vo.CustomerVO;
import com.example.model.vo.order_detailVO;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class mypageController {
	
	@Autowired
    private orderRepository orderRepository;
    
	/*
	 * // 주문내역 페이지
	 * 
	 * @GetMapping("/order/mypage") public String orderList(HttpSession session,
	 * Model model) { try { // 로그인 체크 CustomerVO loginUser = (CustomerVO)
	 * session.getAttribute("loginUser"); if (loginUser == null) { return
	 * "redirect:/login"; }
	 * 
	 * // 전체 주문내역 조회 List<order_detailVO> deliveryList =
	 * orderRepository.getDeliveryList(loginUser.getCustomer_id());
	 * 
	 * // 로그로 확인 log.info("주문내역 개수: {}", deliveryList.size()); for (order_detailVO d
	 * : deliveryList) { log.info("주문번호: {}, 상품명: {}, 금액: {}", d.getOrder_no(),
	 * d.getItem_name(), d.getAmount()); }
	 * 
	 * model.addAttribute("deliveryList", deliveryList); return "/mypage"; // JSP
	 * 파일명
	 * 
	 * } catch (SQLException e) { log.error("주문내역 조회 실패", e);
	 * model.addAttribute("error", "주문내역을 불러오는데 실패했습니다."); return "error"; } }
	 */
	

}
