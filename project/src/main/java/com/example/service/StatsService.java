package com.example.service;

import java.util.List;
import java.util.Map;

public interface StatsService {
    public List<Map<String, Object>> getDailySales();
    public List<Map<String, Object>> getCategorySales();
    public List<Map<String, Object>> getIncomeExpense();
    public List<Map<String, Object>> getDailyOrders();
    public void insertDailyStats();
    public List<Map<String, Object>> getMonthlyStats(String year);
    public List<String> getAvailableYears();}