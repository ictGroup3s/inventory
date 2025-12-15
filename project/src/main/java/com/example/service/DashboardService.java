package com.example.service;

import java.util.List;
import java.util.Map;

public interface DashboardService {
    public Map<String, Object> getSummary();
    public List<Map<String, Object>> getRecentOrders();
    public List<Map<String, Object>> getDailySales();
    public List<Map<String, Object>> getIncomeExpense();
}
