package com.example.service;

import java.util.List;

import jakarta.servlet.http.HttpSession;

import com.example.model.vo.CartItemVO;



public interface CartService {
    void addToCart(Integer itemNo, int qty, HttpSession session);
    void removeFromCart(Integer itemNo, HttpSession session);
    List<CartItemVO> getCartItems(HttpSession session);
    int getCartTotal(HttpSession session);
    // 세션 장바구니에 저장된 모든 항목을 로그인한 사용자의 DB 장바구니로 병합
    // 로그인전 남은 장바구니 내역이 로그인후 db에 반영
    void mergeSessionCartToDb(HttpSession session);
}