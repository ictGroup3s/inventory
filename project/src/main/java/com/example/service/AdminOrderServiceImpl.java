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
	public List<Map<String, Object>> getOrders(String orderNo, String customerName, String status, String startDate,
			String endDate) {
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
		result.put("crList", adminOrderRepository.getCRByOrder(orderNo)); // CR 내역 추가
		return result;
	}

	@Override
	public Map<String, Object> updateOrder(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<>();
		try {
			String newStatus = (String) params.get("order_status");
			String originalStatus = (String) params.get("original_status");
			int orderNo = (int) params.get("order_no");
			String reason = (String) params.get("reason");

			log.info("===== updateOrder 시작 =====");
			log.info("newStatus: {}, originalStatus: {}, orderNo: {}", newStatus, originalStatus, orderNo);

			boolean isNewCancelType = "취소".equals(newStatus) || "반품".equals(newStatus) || "교환".equals(newStatus);
			boolean isOriginalCancelType = "취소".equals(originalStatus) || "반품".equals(originalStatus)
					|| "교환".equals(originalStatus);

			// 1. 정상 → 취소/반품/교환 (처음 취소/반품/교환하는 경우)
			if (isNewCancelType && !isOriginalCancelType) {
				log.info("===== 정상 → 취소/반품/교환 처리 =====");

				// 재고 복구
				adminOrderRepository.restoreStock(orderNo);

				// 전체 상품 조회 및 상태 변경
				List<Map<String, Object>> items = adminOrderRepository.getOrderItems(orderNo);
				for (Map<String, Object> item : items) {
					Object detailNoObj = item.get("DETAIL_NO") != null ? item.get("DETAIL_NO") : item.get("detail_no");

					// 상품 상태 변경
					Map<String, Object> detailParams = new HashMap<>();
					detailParams.put("detail_no", detailNoObj);
					detailParams.put("detail_status", newStatus);
					adminOrderRepository.updateDetailStatus(detailParams);

					// CR 테이블에 기록
					Map<String, Object> crParams = new HashMap<>();
					crParams.put("order_no", orderNo);
					crParams.put("detail_no", detailNoObj);
					crParams.put("type", newStatus);
					crParams.put("return_cnt",
							item.get("ITEM_CNT") != null ? item.get("ITEM_CNT") : item.get("item_cnt"));
					crParams.put("status", "승인");
					crParams.put("reason", reason != null && !reason.isEmpty() ? reason : "주문 전체 " + newStatus);
					adminOrderRepository.insertCR(crParams);
				}
				log.info("정상 → {} 처리 완료 ({}건)", newStatus, items.size());
			}

			// 2. 취소/반품/교환 → 다른 취소/반품/교환 (상태만 변경)
			if (isNewCancelType && isOriginalCancelType && !newStatus.equals(originalStatus)) {
				log.info("===== 취소/반품/교환 상태 변경 =====");

				// 전체 상품 상태 변경
				List<Map<String, Object>> items = adminOrderRepository.getOrderItems(orderNo);
				for (Map<String, Object> item : items) {
					Object detailNoObj = item.get("DETAIL_NO") != null ? item.get("DETAIL_NO") : item.get("detail_no");

					Map<String, Object> detailParams = new HashMap<>();
					detailParams.put("detail_no", detailNoObj);
					detailParams.put("detail_status", newStatus);
					adminOrderRepository.updateDetailStatus(detailParams);
				}
				log.info("{} → {} 상태 변경 완료", originalStatus, newStatus);
			}

			// 3. 취소/반품/교환 → 정상 (철회)
			if (!isNewCancelType && isOriginalCancelType) {
				log.info("===== 철회 처리 =====");

				// 재고 차감
				adminOrderRepository.deductStock(orderNo);

				// 전체 상품 상태를 '정상'으로 복구
				List<Map<String, Object>> items = adminOrderRepository.getOrderItems(orderNo);
				for (Map<String, Object> item : items) {
					Map<String, Object> detailParams = new HashMap<>();
					detailParams.put("detail_no",
							item.get("DETAIL_NO") != null ? item.get("DETAIL_NO") : item.get("detail_no"));
					adminOrderRepository.restoreDetailStatus(detailParams);
				}

				// CR 테이블 상태를 '철회'로 변경
				Map<String, Object> crParams = new HashMap<>();
				crParams.put("order_no", orderNo);
				crParams.put("status", "철회");
				adminOrderRepository.updateCRStatusByOrder(crParams);
				log.info("철회 처리 완료");
			}

			adminOrderRepository.updateOrder(params);
			result.put("success", true);
			result.put("message", "저장되었습니다.");
		} catch (Exception e) {
			log.error("주문 수정 실패: ", e);
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

			// CR 테이블에 기록 추가
			Map<String, Object> crParams = new HashMap<>();
			crParams.put("order_no", params.get("order_no"));
			crParams.put("detail_no", params.get("detail_no"));
			crParams.put("type", params.get("detail_status")); // 취소, 반품, 교환
			crParams.put("return_cnt", params.get("item_cnt"));
			crParams.put("status", "승인"); // 기본 승인 처리
			crParams.put("reason", params.get("reason") != null ? params.get("reason") : "관리자 처리");

			adminOrderRepository.insertCR(crParams);
			log.info("CR 테이블 기록 완료");

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

			// CR 테이블 상태를 '철회'로 변경
			Map<String, Object> crParams = new HashMap<>();
			crParams.put("detail_no", params.get("detail_no"));
			crParams.put("status", "철회");
			adminOrderRepository.updateCRStatusByDetail(crParams);
			log.info("CR 상태 철회로 변경 완료");

			result.put("success", true);
			result.put("message", "복구되었습니다.");
		} catch (Exception e) {
			log.error("복구 실패: ", e);
			result.put("success", false);
			result.put("message", "복구에 실패했습니다.");
		}
		return result;
	}

	@Override
	public List<Map<String, Object>> getCRByOrder(int orderNo) {
		return adminOrderRepository.getCRByOrder(orderNo);
	}
}