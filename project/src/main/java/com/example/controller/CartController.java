package com.example.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.model.CartRepository;
import com.example.model.vo.CartItemVO;
import com.example.model.vo.ProductVO;
import com.example.service.CartService;
import com.example.service.ProductService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CartController {

	@Autowired
    private ProductService productService;
	@Autowired
    private CartService cartService;
    @Autowired
    private CartRepository cartRepository;
    
    @GetMapping("cart")
    public String cart(Model m, HttpSession session) {
        try {
            // 사용자가 방금 로그인했거나 세션에 장바구니 항목이 있으면, 먼저 세션 장바구니를 DB의 장바구니와 병합
            try {
                cartService.mergeSessionCartToDb(session);
            } catch (Exception e) {
                log.warn("장바구니: 세션 장바구니를 DB와 병합하지 못했습니다", e);
            }
           
            try {
                Object u = session.getAttribute("user");
                log.info("cart() 호출 - sessionId={}, user={}", session.getId(), u);
            } catch (Exception ex) {
                log.warn("cart() 디버그 로그 기록에 실패했습니다", ex);
            }
            java.util.List<CartItemVO> items = cartService.getCartItems(session);
            int totalPrice = cartService.getCartTotal(session);
            int cartCount = 0;
            for (CartItemVO ci : items) cartCount += ci.getQty();
            m.addAttribute("cartItems", items);
            m.addAttribute("cartTotal", totalPrice);
            m.addAttribute("cart_cnt", cartCount);
        } catch (Exception e) {
            m.addAttribute("cartItems", new ArrayList<>());
            m.addAttribute("cartTotal", 0);
            m.addAttribute("cart_cnt", 0);
        }
        return "cart";
    }

    @PostMapping("/cart/add")
    @ResponseBody
    public Map<String, Object> addToCart(@RequestParam("item_no") Integer item_no,
                                         @RequestParam(value = "qty", required = false) Integer qty,
                                         HttpSession session) {
        log.info("/cart/add called: item_no={}, qty={}", item_no, qty);
        Map<String, Object> resp = new HashMap<>();
        if (item_no == null) {
            resp.put("success", false);
            resp.put("message", "item_no required");
            return resp;
        }
        int addQty = (qty == null || qty <= 0) ? 1 : qty;
        try {
            cartService.addToCart(item_no, addQty, session);
            int totalCount = cartService.getCartItems(session).stream().mapToInt(CartItemVO::getQty).sum();
            resp.put("success", true);
            resp.put("cartCount", totalCount);
            log.info("Session ID after add: {}", session.getId());
        } catch (Exception ex) {
            log.warn("Failed to add to cart", ex);
            resp.put("success", false);
            resp.put("message", "추가 실패");
        }
        return resp;
    }

    @PostMapping("/cart/remove")
    public String removeFromCart(Integer item_no, HttpSession session) {
        try {
            log.info("장바구니 삭제 요청 수신 item_no={} sessionId={}", item_no, session.getId());
            if (item_no != null) {
                cartService.removeFromCart(item_no, session);
                log.info("장바구니 삭제 처리 완료 item_no={} sessionId={}", item_no, session.getId());
            } else {
                log.warn("장바구니 삭제: item_no가 누락되어 처리하지 않음 sessionId={}", session.getId());
            }
        } catch (Exception e) {
            log.warn("장바구니 삭제 처리 중 예외 발생", e);
        }
        return "redirect:/cart";
    }

    @PostMapping("/cart/addForm")
    public String addToCartForm(@RequestParam("item_no") Integer item_no,
                                @RequestParam(value = "qty", required = false) Integer qty,
                                HttpSession session) {
        if (item_no == null) return "redirect:/selectall";
        int addQty = (qty == null || qty <= 0) ? 1 : qty;
        try {
            cartService.addToCart(item_no, addQty, session);
        } catch (Exception e) {
            log.warn("장바구니 추가 실패 (form)", e);
        }
        return "redirect:/cart";
    }

    @GetMapping("/cart/count")
    @ResponseBody
    public Map<String, Object> cartCount(HttpSession session) {
        Map<String, Object> resp = new HashMap<>();
        int totalCount = 0;
        try {
            totalCount = cartService.getCartItems(session).stream().mapToInt(CartItemVO::getQty).sum();
        } catch (Exception e) {
            log.warn("카트 수량 계산 실패", e);
        }
        resp.put("cartCount", totalCount);
        return resp;
    }
    
    @PostMapping("/cart/update")
    @ResponseBody
    public Map<String, Object> updateCartQuantity(@RequestParam("item_no") Integer item_no,
                                                  @RequestParam("qty") Integer qty,
                                                  HttpSession session) {
        Map<String, Object> resp = new HashMap<>();
        if (item_no == null || qty == null || qty < 0) {
            resp.put("success", false);
            resp.put("message", "invalid parameters");
            return resp;
        }
        try {
            if (qty == 0) {
                cartService.removeFromCart(item_no, session);
            } else {
                // 절대 수량 설정: 기존 항목을 삭제한 뒤 원하는 수량을 추가
                // 현재 CartService는 addToCart(증가)와 removeFromCart를 제공
                // 절대 수량을 설정하려면 기존 항목을 제거한 후 요청한 수량을 추가
                cartService.removeFromCart(item_no, session);
                if (qty > 0) cartService.addToCart(item_no, qty, session);
            }
            java.util.List<CartItemVO> items = cartService.getCartItems(session);
            int totalCount = items.stream().mapToInt(CartItemVO::getQty).sum();
            int cartTotal = items.stream().mapToInt(ci -> ci.getSubtotal()).sum();
            // 변경된 항목의 소계를 계산
            int itemSubtotal = 0;
            try {
                ProductVO p = productService.getProductById(item_no);
                if (p != null && p.getSales_p() != null) {
                    itemSubtotal = p.getSales_p() * qty;
                }
            } catch (Exception ex) { }
            resp.put("success", true);
            resp.put("cartCount", totalCount);
            resp.put("cartTotal", cartTotal);
            resp.put("itemSubtotal", itemSubtotal);
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("message", "failed to update");
        }
        return resp;
    }
}
