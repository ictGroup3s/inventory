package com.example.model;

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
}