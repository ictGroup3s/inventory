package com.example.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DashboardRepository {

    @Autowired
    private SqlSessionTemplate sess;

    public Map<String, Object> getSummary() {
        return sess.selectOne("dashboardmapper.getSummary");
    }

    public List<Map<String, Object>> getRecentOrders() {
        return sess.selectList("dashboardmapper.getRecentOrders");
    }

    public List<Map<String, Object>> getDailySales() {
        return sess.selectList("dashboardmapper.getDailySales");
    }

    public List<Map<String, Object>> getIncomeExpense() {
        return sess.selectList("dashboardmapper.getIncomeExpense");
    }
    
    public List<Map<String, Object>> getRecentOrders(String date) {
        return sess.selectList("dashboardmapper.getRecentOrders", date);
    }
}