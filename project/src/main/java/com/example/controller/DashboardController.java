package com.example.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.service.DashboardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class DashboardController {

	@Autowired
	private DashboardService dashboardService;

	// 대시보드 요약 정보 (카드 4개용)
	@GetMapping("/api/dashboard/summary")
	public Map<String, Object> getSummary() {
		log.info("===== 대시보드 요약 API 호출 =====");
		return dashboardService.getSummary();
	}

	// 주문 목록
	@GetMapping("/api/dashboard/recent-orders")
	public List<Map<String, Object>> getRecentOrders(@RequestParam(required = false) String date) {
		log.info("===== 주문 조회 API 호출 ===== date: {}", date);
		return dashboardService.getRecentOrders(date);
	}

	// 일별 매출 (차트용)
	@GetMapping("/api/dashboard/daily-sales")
	public List<Map<String, Object>> getDailySales() {
		log.info("===== 대시보드 일별 매출 API 호출 =====");
		return dashboardService.getDailySales();
	}

	// 수입/지출 (차트용)
	@GetMapping("/api/dashboard/income-expense")
	public List<Map<String, Object>> getIncomeExpense() {
		log.info("===== 대시보드 수입/지출 API 호출 =====");
		return dashboardService.getIncomeExpense();
	}

	
}