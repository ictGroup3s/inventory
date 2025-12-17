package com.example.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.AdminOrderRepository;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminOrderServiceImpl implements AdminOrderService {

	@Autowired
	private AdminOrderRepository adminOrderRepository;

	@Override
	public List<Map<String, Object>> getOrders(String orderNo, String customerName, String status, String startDate, String endDate) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("orderNo", orderNo);
	    params.put("customerName", customerName);
	    params.put("status", status);
	    params.put("startDate", startDate);
	    params.put("endDate", endDate);
	    return adminOrderRepository.getOrders(params);
	}

	@Override
	public Map<String, Object> getOrderDetail(int orderNo) {
		Map<String, Object> result = new HashMap<>();
		result.put("order", adminOrderRepository.getOrder(orderNo));
		result.put("items", adminOrderRepository.getOrderItems(orderNo));
		return result;
	}

	@Override
	public Map<String, Object> updateOrder(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<>();
		try {
			String newStatus = (String) params.get("order_status");
			String originalStatus = (String) params.get("original_status");
			int orderNo = (int) params.get("order_no");

			// 취소로 변경 시 재고 복구
			if ("취소".equals(newStatus) && !"취소".equals(originalStatus)) {
				adminOrderRepository.restoreStock(orderNo);
			}

			// 취소에서 다른 상태로 변경 시 재고 차감
			if ("취소".equals(originalStatus) && !"취소".equals(newStatus)) {
				adminOrderRepository.deductStock(orderNo);
			}

			adminOrderRepository.updateOrder(params);
			result.put("success", true);
			result.put("message", "저장되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "저장에 실패했습니다.");
		}
		return result;
	}

	@Override
	public Map<String, Object> updateDetailStatus(Map<String, Object> params) {
	    Map<String, Object> result = new HashMap<>();
	    try {
	        log.info("===== 상품 상태 변경 시작 ===== params: {}", params);
	        
	        // 상태 변경
	        adminOrderRepository.updateDetailStatus(params);
	        log.info("상태 변경 완료");
	        
	        // 재고 복구
	        adminOrderRepository.restoreItemStock(params);
	        log.info("재고 복구 완료");
	        
	        result.put("success", true);
	        result.put("message", "처리되었습니다.");
	    } catch (Exception e) {
	        log.error("상품 상태 변경 실패: ", e);
	        result.put("success", false);
	        result.put("message", "처리에 실패했습니다.");
	    }
	    return result;
	}

	@Override
	public Map<String, Object> restoreDetail(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<>();
		try {
			// 상태 복구
			adminOrderRepository.restoreDetailStatus(params);

			// 재고 차감
			adminOrderRepository.deductItemStock(params);

			result.put("success", true);
			result.put("message", "복구되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "복구에 실패했습니다.");
		}
		return result;
	}
}