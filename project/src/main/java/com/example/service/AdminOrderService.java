package com.example.service;

import java.util.List;
import java.util.Map;

public interface AdminOrderService {
	List<Map<String, Object>> getOrders(String orderNo, String customerName, String status, String startDate, String endDate);
    Map<String, Object> getOrderDetail(int orderNo);
    Map<String, Object> updateOrder(Map<String, Object> params);
    Map<String, Object> updateDetailStatus(Map<String, Object> params);
    Map<String, Object> restoreDetail(Map<String, Object> params);
    List<Map<String, Object>> getCRByOrder(int orderNo);
}