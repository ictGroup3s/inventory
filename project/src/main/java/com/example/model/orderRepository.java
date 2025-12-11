package com.example.model;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.order_detailVO;
import com.example.model.vo.ordersVO;

@Repository
public class orderRepository {

    @Autowired
    private SqlSession sqlSession;

    // 주문 생성
    public int insertOrder(ordersVO order) {
        sqlSession.insert("orderMapper.insertOrder", order);
        return order.getOrder_no(); // selectKey로 자동 설정된 값 반환
    }

    // 주문 상세 저장
    public void insertOrderDetail(Map<String, Object> params) {
        sqlSession.insert("orderMapper.insertOrderDetail", params);
    }

    // 주문 번호로 조회
    public ordersVO selectOrderByNo(int orderNo) {
        return sqlSession.selectOne("orderMapper.selectOrderByNo", orderNo);
    }

    // 고객 ID로 주문 목록 조회
    public List<ordersVO> selectOrdersByCustomerId(String customerId) {
        return sqlSession.selectList("orderMapper.selectOrdersByCustomerId", customerId);
    }

    // 주문 상태 업데이트
    public void updateOrderStatus(Map<String, Object> params) {
        sqlSession.update("orderMapper.updateOrderStatus", params);
    }

    // 주문 상세 조회
    public List<order_detailVO> getOrderDetail(int orderNo) {
        return sqlSession.selectList("orderMapper.getOrderDetail", orderNo);
    }

    // 전체 주문내역 조회
    public List<order_detailVO> getDeliveryList(String customerId) {
        return sqlSession.selectList("orderMapper.getDeliveryList", customerId);
    }
}