package com.example.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AdminOrderRepository {

    @Autowired
    private SqlSessionTemplate sess;

    public List<Map<String, Object>> getOrders(Map<String, Object> params) {
        return sess.selectList("adminordermapper.getOrders", params);
    }

    public Map<String, Object> getOrder(int orderNo) {
        return sess.selectOne("adminordermapper.getOrder", orderNo);
    }

    public List<Map<String, Object>> getOrderItems(int orderNo) {
        return sess.selectList("adminordermapper.getOrderItems", orderNo);
    }

    public void updateOrder(Map<String, Object> params) {
        sess.update("adminordermapper.updateOrder", params);
    }

    public void restoreStock(int orderNo) {
        sess.update("adminordermapper.restoreStock", orderNo);
    }

    public void deductStock(int orderNo) {
        sess.update("adminordermapper.deductStock", orderNo);
    }

    public void updateDetailStatus(Map<String, Object> params) {
        sess.update("adminordermapper.updateDetailStatus", params);
    }

    public void restoreDetailStatus(Map<String, Object> params) {
        sess.update("adminordermapper.restoreDetailStatus", params);
    }

    public void restoreItemStock(Map<String, Object> params) {
        sess.update("adminordermapper.restoreItemStock", params);
    }

    public void deductItemStock(Map<String, Object> params) {
        sess.update("adminordermapper.deductItemStock", params);
    }

    // ===== CR (취소/반품) 관련 =====
    public void insertCR(Map<String, Object> params) {
        sess.insert("adminordermapper.insertCR", params);
    }

    public List<Map<String, Object>> getCRByOrder(int orderNo) {
        return sess.selectList("adminordermapper.getCRByOrder", orderNo);
    }

    public void updateCRStatus(Map<String, Object> params) {
        sess.update("adminordermapper.updateCRStatus", params);
    }
    
    public void updateCRStatusByDetail(Map<String, Object> params) {
        sess.update("adminordermapper.updateCRStatusByDetail", params);
    }
    
    public void updateCRStatusByOrder(Map<String, Object> params) {
        sess.update("adminordermapper.updateCRStatusByOrder", params);
    }
}