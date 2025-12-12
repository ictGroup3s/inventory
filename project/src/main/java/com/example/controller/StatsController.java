package com.example.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.service.StatsService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class StatsController {

    @Autowired
    private StatsService statsService;

    // 통계 페이지
    @GetMapping("/stats")
    public String statsPage(Model model) {
        return "stats";
    }

    // 일별 매출 데이터 (최근 7일)
    @GetMapping("/api/stats/daily-sales")
    @ResponseBody
    public List<Map<String, Object>> getDailySales() {
        return statsService.getDailySales();
    }

    // 카테고리별 매출
    @GetMapping("/api/stats/category-sales")
    @ResponseBody
    public List<Map<String, Object>> getCategorySales() {
        return statsService.getCategorySales();
    }

    // 수입/지출 (입고비용 vs 판매수입)
    @GetMapping("/api/stats/income-expense")
    @ResponseBody
    public List<Map<String, Object>> getIncomeExpense() {
        return statsService.getIncomeExpense();
    }

    // 일별 주문건수 (최근 7일)
    @GetMapping("/api/stats/daily-orders")
    @ResponseBody
    public List<Map<String, Object>> getDailyOrders() {
        return statsService.getDailyOrders();
    }
    
    // 수동으로 통계 집계 실행 (테스트용)
    @GetMapping("/api/stats/generate")
    @ResponseBody
    public Map<String, Object> generateStats() {
        Map<String, Object> result = new HashMap<>();
        try {
            statsService.insertDailyStats();
            result.put("success", true);
            result.put("message", "통계 집계 완료");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "집계 실패: " + e.getMessage());
        }
        return result;
    }
}