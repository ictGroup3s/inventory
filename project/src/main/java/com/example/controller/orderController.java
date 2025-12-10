package com.example.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.model.orderRepository;
import com.example.model.vo.CartItemVO;
import com.example.model.vo.order_detailVO;
import com.example.service.CartService;

import jakarta.servlet.http.HttpSession;

@Controller
public class orderController {

	    private final orderRepository repo;
	    private final CartService cartService; // 장바구니 서비스

	    public orderController(orderRepository repo, CartService cartService) {
	        this.repo = repo;
	        this.cartService = cartService;
	    }

	    // 결제 버튼 클릭 → 주문 저장 → 결제 완료 페이지 이동
	    @PostMapping("/checkout")
	    public String processCheckout(HttpSession session) throws Exception {
	        String customerId = (String) session.getAttribute("customerId");

	        // 1. 주문 저장
	        int orderNo = repo.insertOrder(customerId);

	        // 2. 장바구니 기반 주문 상세 저장
	        List<CartItemVO> cartItems = cartService.getCartItems(session);
	        repo.insertOrderDetail(orderNo, cartItems);

	        // 3. 방금 주문한 번호를 세션에 저장
	        session.setAttribute("lastOrderNo", orderNo);

	        // 4. 결제 완료 페이지로 이동
	        return "redirect:/ordercomplete";
	    }

	    // 결제 완료 페이지
	    @GetMapping("/ordercomplete")
	    public String showSuccessPage() {
	        return "ordercomplete"; // success.jsp
	    }

	    // 주문내역 페이지
	    @GetMapping("/order/mypage")
	    public String showMyPage(@RequestParam(value="view", required=false) String view,
	                             HttpSession session,
	                             Model model) throws Exception {

	        if ("last".equals(view)) {
	            Integer orderNo = (Integer) session.getAttribute("lastOrderNo");
	            if (orderNo != null) {
	                List<order_detailVO> list = repo.getOrderDetail(orderNo);
	                model.addAttribute("deliveryList", list);
	            }
	        } else {
	            String customerId = (String) session.getAttribute("customerId");
	            List<order_detailVO> list = repo.getDeliveryList(customerId);
	            model.addAttribute("deliveryList", list);
	        }

	        return "mypage"; // mypage.jsp
	    }
	}
