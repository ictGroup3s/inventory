package com.example.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StatsRepository {

    @Autowired
    private SqlSessionTemplate sess;

    public List<Map<String, Object>> getDailySales() {
        return sess.selectList("statsmapper.getDailySales");
    }

    public List<Map<String, Object>> getCategorySales() {
        return sess.selectList("statsmapper.getCategorySales");
    }

    public List<Map<String, Object>> getIncomeExpense() {
        return sess.selectList("statsmapper.getIncomeExpense");
    }

    public List<Map<String, Object>> getDailyOrders() {
        return sess.selectList("statsmapper.getDailyOrders");
    }
    
    public void insertDailyStats() {
        sess.insert("statsmapper.insertDailyStats");
    }
    
    public List<Map<String, Object>> getMonthlyStats(String year) {
        Map<String, Object> param = new HashMap<>();
        param.put("year", year);
        return sess.selectList("statsmapper.getMonthlyStats", param);
    }

    public List<String> getAvailableYears() {
        return sess.selectList("statsmapper.getAvailableYears");
    }
}