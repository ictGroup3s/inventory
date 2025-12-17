package com.example.service;


import java.util.List;

import com.example.model.vo.CartItemVO;
import com.example.model.vo.CustomerVO;
import com.example.model.vo.ordersVO;

public interface orderService {

	// 장바구니 아이템들과 함께 주문 생성
	 int createOrder(ordersVO order, List<CartItemVO> cartItems);
    
    // 주문 번호로 주문 조회
    ordersVO getOrderByNo(int orderNo);
    
    // 고객 ID로 주문 목록 조회
    List<ordersVO> getOrdersByCustomerId(String loginUser);
    
    // 주문 상태 업데이트
    void updateOrderStatus(int orderNo, String status);
    
    List<ordersVO> getOrders(CustomerVO loginUser);

    List<ordersVO> getDeliveries(CustomerVO loginUser);
    
    List<ordersVO> getDeliveryGroupedList(String loginUser);
    
   
    

}
