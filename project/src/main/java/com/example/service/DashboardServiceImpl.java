package com.example.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.DashboardRepository;

@Service
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private DashboardRepository dashboardRepository;

    @Override
    public Map<String, Object> getSummary() {
        return dashboardRepository.getSummary();
    }

    @Override
    public List<Map<String, Object>> getRecentOrders(String date) {
        return dashboardRepository.getRecentOrders(date);
    }

    @Override
    public List<Map<String, Object>> getDailySales() {
        return dashboardRepository.getDailySales();
    }

    @Override
    public List<Map<String, Object>> getIncomeExpense() {
        return dashboardRepository.getIncomeExpense();
    }
}