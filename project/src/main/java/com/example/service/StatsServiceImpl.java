package com.example.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.StatsRepository;

@Service
public class StatsServiceImpl implements StatsService {

    @Autowired
    private StatsRepository statsRepository;

    @Override
    public List<Map<String, Object>> getDailySales() {
        return statsRepository.getDailySales();
    }

    @Override
    public List<Map<String, Object>> getCategorySales() {
        return statsRepository.getCategorySales();
    }

    @Override
    public List<Map<String, Object>> getIncomeExpense() {
        return statsRepository.getIncomeExpense();
    }

    @Override
    public List<Map<String, Object>> getDailyOrders() {
        return statsRepository.getDailyOrders();
    }
    
    @Override
    public void insertDailyStats() {
        statsRepository.insertDailyStats();
    }
}