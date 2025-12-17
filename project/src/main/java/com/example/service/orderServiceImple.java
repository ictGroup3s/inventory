package com.example.service;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.model.AdminRepository;
import com.example.model.CartRepository;
import com.example.model.orderRepository;
import com.example.model.vo.CartItemVO;
import com.example.model.vo.CustomerVO;
import com.example.model.vo.ProductVO;
import com.example.model.vo.StockVO;
import com.example.model.vo.ordersVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class orderServiceImple implements orderService {

	@Autowired
	private orderRepository orderRepository;

	@Autowired
	private CartRepository cartRepository;

	@Autowired
	private AdminRepository adminRepository;

	@Override
	@Transactional
	public int createOrder(ordersVO order, List<CartItemVO> cartItems) {
		try {
			log.info("========== 주문 생성 시작 ==========");
			// ⭐ 총 금액 계산
			int totalAmount = 0;
			for (CartItemVO item : cartItems) {
				totalAmount += item.getProduct().getSales_p() * item.getQty();
			}

			order.setTotal_amount(totalAmount); // ⭐ 총 금액 설정

			log.info("총 주문 금액: {}", totalAmount);
			log.info("주문자 정보: {}", order);
			log.info("장바구니 아이템 수: {}", cartItems != null ? cartItems.size() : 0);

			// 1. 주문 메인 정보 저장 (orders 테이블)
			int orderNo = orderRepository.insertOrder(order);
			log.info("✅ 주문 생성 완료. 주문번호: {}", orderNo);

			// 2. ⭐ CartItemVO에 item_no와 item_price 설정
			if (cartItems != null && !cartItems.isEmpty()) {
				for (CartItemVO item : cartItems) {
					item.setItem_no(item.getProduct().getItem_no());
					item.setItem_price(item.getProduct().getSales_p());

					// ⭐ 재고 차감 및 출고 이력 저장
					int itemNo = item.getProduct().getItem_no();
					int qty = item.getQty();

					// 현재 재고 조회
					ProductVO product = adminRepository.getProductByNo(itemNo);
					int beforeQty = product.getStock_cnt();
					int afterQty = beforeQty - qty;

					// product 재고 업데이트
					product.setStock_cnt(afterQty);
					adminRepository.updateStockOnly(product); // 재고만 업데이트하는 메서드

					// stock 테이블에 출고 이력 저장
					StockVO stockVO = new StockVO();
					stockVO.setItem_no(itemNo);
					stockVO.setStock(afterQty);
					stockVO.setStock_in(0);
					stockVO.setStock_out(qty);
					stockVO.setOrder_no(orderNo); // 주문번호 연결!

					adminRepository.insertStockHistory(stockVO);

					log.info("✅ 상품 {} 출고: {} → {} (출고수량: {})", itemNo, beforeQty, afterQty, qty);
				}

				// 주문 상세 정보 저장 (order_detail 테이블)
				orderRepository.insertOrderDetail(orderNo, cartItems);
				log.info("✅ 주문 상세 {} 건 저장 완료", cartItems.size());
			}

			// 3. ⭐ DB 장바구니 비우기
			if (order.getCustomer_id() != null) {
				try {
					cartRepository.deleteCartByCustomer(order.getCustomer_id());
					log.info("✅ DB 장바구니 삭제 완료");
				} catch (Exception e) {
					log.warn("⚠️ DB 장바구니 삭제 실패 (무시하고 진행)", e);
				}
			}

			log.info("========== 주문 생성 완료 ==========");
			return orderNo;

		} catch (SQLException e) {
			log.error("❌ orderService - 주문 저장 실패!", e);
			throw new RuntimeException("주문 저장 중 오류 발생", e);
		} catch (Exception e) {
			log.error("❌ orderService - 예상치 못한 오류!", e);
			throw new RuntimeException("주문 처리 중 오류 발생", e);
		}
	}

	@Override
	public ordersVO getOrderByNo(int orderNo) {
		try {
			log.info("주문 조회 - 주문번호: {}", orderNo);
			ordersVO order = orderRepository.selectOrderByNo(orderNo);

			if (order != null) {
				log.info("✅ 주문 조회 성공: {}", order);
			} else {
				log.warn("⚠️ 주문을 찾을 수 없음 - 주문번호: {}", orderNo);
			}

			return order;
		} catch (SQLException e) {
			log.error("❌ 주문 조회 실패 - 주문번호: {}", orderNo, e);
			throw new RuntimeException("주문 조회 중 오류 발생", e);
		}
	}

	@Override
	public List<ordersVO> getOrdersByCustomerId(String customerId) {
		try {
			log.info("고객 주문 목록 조회 - 고객ID: {}", customerId);
			List<ordersVO> orders = orderRepository.selectOrdersByCustomerId(customerId);
			log.info("✅ 조회된 주문 개수: {}", orders.size());
			return orders;
		} catch (SQLException e) {
			log.error("❌ 고객 주문 목록 조회 실패 - 고객ID: {}", customerId, e);
			throw new RuntimeException("주문 목록 조회 중 오류 발생", e);
		}
	}

	@Override
	public void updateOrderStatus(int orderNo, String status) {
		try {
			log.info("주문 상태 업데이트 - 주문번호: {}, 상태: {}", orderNo, status);
			orderRepository.updateOrderStatus(orderNo, status);
			log.info("✅ 주문 상태 업데이트 완료");
		} catch (SQLException e) {
			log.error("❌ 주문 상태 업데이트 실패 - 주문번호: {}", orderNo, e);
			throw new RuntimeException("주문 상태 업데이트 중 오류 발생", e);
		}
	}

	// ⭐⭐⭐ 새로 추가되는 메서드들 ⭐⭐⭐
	@Override
	public List<ordersVO> getOrders(CustomerVO loginUser) {
		try {
			log.info("마이페이지 주문 목록 조회 - 고객ID: {}", loginUser.getCustomer_id());
			List<ordersVO> orders = orderRepository.selectOrdersByCustomerId(loginUser.getCustomer_id());
			log.info("✅ 조회된 주문 개수: {}", orders != null ? orders.size() : 0);
			return orders;
		} catch (SQLException e) {
			log.error("❌ 주문 목록 조회 실패 - 고객ID: {}", loginUser.getCustomer_id(), e);
			throw new RuntimeException("주문 목록 조회 중 오류 발생", e);
		}
	}

	@Override
	public List<ordersVO> getDeliveries(CustomerVO loginUser) {
		try {
			log.info("마이페이지 배송 목록 조회 - 고객ID: {}", loginUser.getCustomer_id());
			// 기본적으로 주문 목록을 가져옴 (배송 관련 정보 포함)
			List<ordersVO> deliveries = orderRepository.selectOrdersByCustomerId(loginUser.getCustomer_id());
			log.info("✅ 조회된 배송 개수: {}", deliveries != null ? deliveries.size() : 0);
			return deliveries;
		} catch (SQLException e) {
			log.error("❌ 배송 목록 조회 실패 - 고객ID: {}", loginUser.getCustomer_id(), e);
			throw new RuntimeException("배송 목록 조회 중 오류 발생", e);
		}
	}
}