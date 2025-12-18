package com.example.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.example.service.AdminOrderService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/orders")
public class AdminOrderController {

    @Autowired
    private AdminOrderService adminOrderService;

    // 주문 목록 조회
    @GetMapping
    public List<Map<String, Object>> getOrders(
            @RequestParam(required = false) String orderNo,
            @RequestParam(required = false) String customerName,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        log.info("===== 주문 목록 조회 ===== orderNo: {}, customerName: {}, status: {}, startDate: {}, endDate: {}",
                orderNo, customerName, status, startDate, endDate);
        return adminOrderService.getOrders(orderNo, customerName, status, startDate, endDate);
    }

    // 주문 상세 조회
    @GetMapping("/{orderNo}")
    public Map<String, Object> getOrderDetail(@PathVariable int orderNo) {
        log.info("===== 주문 상세 조회 ===== orderNo: {}", orderNo);
        return adminOrderService.getOrderDetail(orderNo);
    }

    // 주문 상태/운송장 수정
    @PutMapping("/{orderNo}")
    public Map<String, Object> updateOrder(@PathVariable int orderNo, @RequestBody Map<String, Object> params) {
        log.info("===== 주문 수정 ===== orderNo: {}, params: {}", orderNo, params);
        params.put("order_no", orderNo);
        return adminOrderService.updateOrder(params);
    }

    // 상품별 상태 변경 (취소/반품/교환)
    @PutMapping("/detail/{detailNo}/status")
    public Map<String, Object> updateDetailStatus(@PathVariable int detailNo, @RequestBody Map<String, Object> params) {
        log.info("===== 상품 상태 변경 ===== detailNo: {}, params: {}", detailNo, params);
        params.put("detail_no", detailNo);
        return adminOrderService.updateDetailStatus(params);
    }

    // 상품 복구
    @PutMapping("/detail/{detailNo}/restore")
    public Map<String, Object> restoreDetail(@PathVariable int detailNo, @RequestBody Map<String, Object> params) {
        log.info("===== 상품 복구 ===== detailNo: {}, params: {}", detailNo, params);
        params.put("detail_no", detailNo);
        return adminOrderService.restoreDetail(params);
    }

    // 취소/반품 내역 조회
    @GetMapping("/{orderNo}/cr")
    public List<Map<String, Object>> getCRByOrder(@PathVariable int orderNo) {
        log.info("===== 취소/반품 내역 조회 ===== orderNo: {}", orderNo);
        return adminOrderService.getCRByOrder(orderNo);
    }
}