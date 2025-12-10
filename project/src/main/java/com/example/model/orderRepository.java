package com.example.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.CartItemVO;
import com.example.model.vo.order_detailVO;
import com.example.model.vo.ordersVO;


@Repository
public class orderRepository {
	
	 @Autowired
	    private DataSource dataSource;

	    // ordersVO를 받는 insertOrder 메서드 추가
	    public int insertOrder(ordersVO order) throws SQLException {
	        int orderNo = 0;
	        try (Connection conn = dataSource.getConnection()) {
	            // 1. 시퀀스에서 orderNo 가져오기
	            String seqSql = "SELECT orders_seq.NEXTVAL FROM dual";
	            try (PreparedStatement seqStmt = conn.prepareStatement(seqSql)) {
	                ResultSet rs = seqStmt.executeQuery();
	                if (rs.next()) {
	                    orderNo = rs.getInt(1);
	                }
	            }

	            // 2. orders 테이블에 INSERT (전체 정보 저장)
	            String insertSql = "INSERT INTO orders (order_no, customer_id, order_name, order_addr, order_phone, order_date, order_status, payment) VALUES (?, ?, ?, ?, ?, SYSDATE, ?, ?)";
	            try (PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
	                pstmt.setInt(1, orderNo);
	                pstmt.setString(2, order.getCustomer_id());
	                pstmt.setString(3, order.getOrder_name());
	                pstmt.setString(4, order.getOrder_addr());
	                pstmt.setInt(5, order.getOrder_phone());
	                pstmt.setString(6, order.getOrder_status());
	                pstmt.setString(7, order.getPayment());
	                pstmt.executeUpdate();
	            }
	            
	            // orderNo를 order 객체에 설정
	            order.setOrder_no(orderNo);
	        }
	        return orderNo;
	    }

	    // 기존 메서드 (customerId만 받는 버전) - 필요하면 유지
	    public int insertOrder(String customerId) throws SQLException {
	        int orderNo = 0;
	        try (Connection conn = dataSource.getConnection()) {
	            String seqSql = "SELECT orders_seq.NEXTVAL FROM dual";
	            try (PreparedStatement seqStmt = conn.prepareStatement(seqSql)) {
	                ResultSet rs = seqStmt.executeQuery();
	                if (rs.next()) {
	                    orderNo = rs.getInt(1);
	                }
	            }

	            String insertSql = "INSERT INTO orders (order_no, customer_id, order_date, order_status) VALUES (?, ?, SYSDATE, '결제대기')";
	            try (PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
	                pstmt.setInt(1, orderNo);
	                pstmt.setString(2, customerId);
	                pstmt.executeUpdate();
	            }
	        }
	        return orderNo;
	    }

	    // 주문 번호로 조회 메서드 추가
	    public ordersVO selectOrderByNo(int orderNo) throws SQLException {
	        ordersVO order = null;
	        String sql = "SELECT * FROM orders WHERE order_no = ?";
	        
	        try (Connection conn = dataSource.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {
	            
	            pstmt.setInt(1, orderNo);
	            ResultSet rs = pstmt.executeQuery();
	            
	            if (rs.next()) {
	                order = new ordersVO();
	                order.setOrder_no(rs.getInt("order_no"));
	                order.setOrder_name(rs.getString("order_name"));
	                order.setOrder_addr(rs.getString("order_addr"));
	                order.setOrder_phone(rs.getInt("order_phone"));
	                order.setOrder_status(rs.getString("order_status"));
	                order.setPayment(rs.getString("payment"));
	                order.setCustomer_id(rs.getString("customer_id"));
	                order.setOrder_date(rs.getString("order_date"));
	            }
	        }
	        return order;
	    }

	    // 고객 ID로 주문 목록 조회 메서드 추가
	    public List<ordersVO> selectOrdersByCustomerId(String customerId) throws SQLException {
	        List<ordersVO> list = new ArrayList<>();
	        String sql = "SELECT * FROM orders WHERE customer_id = ? ORDER BY order_date DESC";
	        
	        try (Connection conn = dataSource.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {
	            
	            pstmt.setString(1, customerId);
	            ResultSet rs = pstmt.executeQuery();
	            
	            while (rs.next()) {
	                ordersVO order = new ordersVO();
	                order.setOrder_no(rs.getInt("order_no"));
	                order.setOrder_name(rs.getString("order_name"));
	                order.setOrder_addr(rs.getString("order_addr"));
	                order.setOrder_phone(rs.getInt("order_phone"));
	                order.setOrder_status(rs.getString("order_status"));
	                order.setPayment(rs.getString("payment"));
	                order.setCustomer_id(rs.getString("customer_id"));
	                order.setOrder_date(rs.getString("order_date"));
	                list.add(order);
	            }
	        }
	        return list;
	    }

	    // 주문 상태 업데이트 메서드 추가
	    public void updateOrderStatus(int orderNo, String status) throws SQLException {
	        String sql = "UPDATE orders SET order_status = ? WHERE order_no = ?";
	        
	        try (Connection conn = dataSource.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {
	            
	            pstmt.setString(1, status);
	            pstmt.setInt(2, orderNo);
	            pstmt.executeUpdate();
	        }
	    }

	    // 주문 상세 저장
	    public void insertOrderDetail(int orderNo, List<CartItemVO> cartItems) throws SQLException {
	        String sql = "INSERT INTO order_detail (order_no, item_no, item_cnt, item_price) VALUES (?, ?, ?, ?)";
	        try (Connection conn = dataSource.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {
	            for (CartItemVO item : cartItems) {
	                pstmt.setInt(1, orderNo);
	                pstmt.setInt(2, item.getItem_no());
	                pstmt.setInt(3, item.getQty());
	                pstmt.setInt(4, item.getItem_price());
	                pstmt.addBatch();
	            }
	            pstmt.executeBatch();
	        }
	    }

	    // 방금 주문 상세 조회
	    public List<order_detailVO> getOrderDetail(int orderNo) throws SQLException {
	        List<order_detailVO> list = new ArrayList<>();
	        String sql = """
	            SELECT od.detail_no, od.order_no, od.item_no, od.item_cnt, od.item_price,
	                   p.item_name, TO_CHAR(o.order_date,'YYYY-MM-DD HH24:MI:SS') AS order_date,
	                   o.order_status
	            FROM order_detail od
	            JOIN orders o ON od.order_no = o.order_no
	            JOIN product p ON od.item_no = p.item_no
	            WHERE od.order_no = ?
	        """;

	        try (Connection conn = dataSource.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {

	            pstmt.setInt(1, orderNo);
	            ResultSet rs = pstmt.executeQuery();

	            while (rs.next()) {
	                order_detailVO d = new order_detailVO();
	                d.setDetail_no(rs.getInt("detail_no"));
	                d.setOrder_no(rs.getInt("order_no"));
	                d.setItem_no(rs.getInt("item_no"));
	                d.setItem_cnt(rs.getInt("item_cnt"));
	                d.setItem_price(rs.getInt("item_price"));
	                d.setItem_name(rs.getString("item_name"));
	                d.setOrder_date(rs.getString("order_date"));
	                d.setOrder_status(rs.getString("order_status"));
	                list.add(d);
	            }
	        }
	        return list;
	    }

	    // 전체 주문내역 조회
	    public List<order_detailVO> getDeliveryList(String customerId) throws SQLException {
	        List<order_detailVO> list = new ArrayList<>();
	        String sql = """
	            SELECT od.detail_no, od.order_no, od.item_no, od.item_cnt, od.item_price,
	                   p.item_name, TO_CHAR(o.order_date,'YYYY-MM-DD HH24:MI:SS') AS order_date,
	                   o.order_status
	            FROM order_detail od
	            JOIN orders o ON od.order_no = o.order_no
	            JOIN product p ON od.item_no = p.item_no
	            WHERE o.customer_id = ?
	            ORDER BY o.order_date DESC
	        """;

	        try (Connection conn = dataSource.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {

	            pstmt.setString(1, customerId);
	            ResultSet rs = pstmt.executeQuery();

	            while (rs.next()) {
	                order_detailVO d = new order_detailVO();
	                d.setDetail_no(rs.getInt("detail_no"));
	                d.setOrder_no(rs.getInt("order_no"));
	                d.setItem_no(rs.getInt("item_no"));
	                d.setItem_cnt(rs.getInt("item_cnt"));
	                d.setItem_price(rs.getInt("item_price"));
	                d.setItem_name(rs.getString("item_name"));
	                d.setOrder_date(rs.getString("order_date"));
	                d.setOrder_status(rs.getString("order_status"));
	                list.add(d);
	            }
	        }
	        return list;
	    }
}

