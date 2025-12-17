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

import com.example.model.vo.crVO;
import com.example.model.vo.order_detailVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class crRepository {

	 @Autowired
	    private DataSource dataSource;

	    /**
	     * 취소/반품/교환 목록 조회 (고객별)
	     */
	    public List<crVO> getCRListByCustomerId(String customerId) throws SQLException {
	        log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
	        log.info("┃  📋 취소/반품/교환 목록 조회 (Repository)           ┃");
	        log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
	        log.info("   - loginUser: {}", customerId);
	        
	        List<crVO> list = new ArrayList<>();
	        
	        String sql = """
	        		SELECT
	        		cr.cr_no,
	        		cr.order_no,
	        		cr.type,
	        		cr.return_cnt,
	        		cr.reason,
	        		cr.status,
	        		cr.re_date,
	        		p.item_name
	        		FROM cr
	        		JOIN orders o ON cr.order_no = o.order_no
	        		JOIN order_detail od ON o.order_no = od.order_no
	        		JOIN product p ON od.item_no = p.item_no
	        		WHERE o.customer_id = ?
	        		ORDER BY cr.re_date DESC
	        """;
	        
	        log.info("   - 실행 SQL: {}", sql.replaceAll("\\s+", " "));
	        
	        try (Connection conn = dataSource.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {

	            pstmt.setString(1, customerId);
	            ResultSet rs = pstmt.executeQuery();

	            while (rs.next()) {
	            	crVO vo = new crVO();
	                vo.setCr_no(rs.getInt("cr_no"));
	                vo.setOrder_no(rs.getInt("order_no"));
	                vo.setType(rs.getString("type"));
	                
	                vo.setReturn_cnt(rs.getObject("return_cnt", Integer.class));
	                
	                vo.setReason(rs.getString("reason"));
	                vo.setStatus(rs.getString("status"));
	                vo.setRe_date(rs.getTimestamp("re_date"));
	                vo.setItem_name(rs.getString("item_name")); 
	                
	                list.add(vo);
	            }
	            
	            log.info("   ✅ 조회 성공: {} 건", list.size());
	        } catch (Exception e) {
	            log.error("   ❌ 조회 실패!", e);
	            throw e;
	        }
	        
	        return list;
	    }

	    /* ===============================
	       취소/반품/교환 신청
	       =============================== */
	    public int insertCR(crVO crVO) throws SQLException {

	        String sql = """
	            INSERT INTO cr
	            (cr_no, order_no, type, return_cnt, reason, status, re_date)
	            VALUES (cr_seq.NEXTVAL, ?, ?, ?, ?, ?, SYSDATE)
	        """;

	        try (
	            Connection conn = dataSource.getConnection();
	            PreparedStatement pstmt = conn.prepareStatement(sql)
	        ) {
	            pstmt.setInt(1, crVO.getOrder_no());
	            pstmt.setString(2, crVO.getType());

	            if (crVO.getReturn_cnt() != null) {
	                pstmt.setInt(3, crVO.getReturn_cnt());
	            } else {
	                pstmt.setNull(3, java.sql.Types.INTEGER);
	            }

	            pstmt.setString(4, crVO.getReason());
	            pstmt.setString(5, crVO.getStatus());

	            return pstmt.executeUpdate();
	        }
	    }

	    /* ===============================
	       주문 상품 개수
	       =============================== */
	    public int getOrderItemCount(int orderNo) throws SQLException {

	        String sql = """
	            SELECT COUNT(*)
	            FROM order_detail
	            WHERE order_no = ?
	        """;

	        try (
	            Connection conn = dataSource.getConnection();
	            PreparedStatement pstmt = conn.prepareStatement(sql)
	        ) {
	            pstmt.setInt(1, orderNo);

	            try (ResultSet rs = pstmt.executeQuery()) {
	                if (rs.next()) return rs.getInt(1);
	            }
	        }
	        return 0;
	    }

	    /* ===============================
	       🔐 내 주문인지 확인 (보안 핵심)
	       =============================== */
	    public boolean isMyOrder(int orderNo, String customerId) throws SQLException {

	        String sql = """
	            SELECT COUNT(*)
	            FROM orders
	            WHERE order_no = ?
	            AND customer_id = ?
	        """;

	        try (
	            Connection conn = dataSource.getConnection();
	            PreparedStatement pstmt = conn.prepareStatement(sql)
	        ) {
	            pstmt.setInt(1, orderNo);
	            pstmt.setString(2, customerId);

	            try (ResultSet rs = pstmt.executeQuery()) {
	                rs.next();
	                return rs.getInt(1) > 0;
	            }
	        }
	    }
	   
	    public List<Integer> getMyOrderNos(String customerId) throws SQLException {

	        String sql = """
	            SELECT DISTINCT order_no
	            FROM orders
	            WHERE customer_id = ?
	            ORDER BY order_no DESC
	        """;

	        List<Integer> list = new ArrayList<>();

	        try (
	            Connection conn = dataSource.getConnection();
	            PreparedStatement pstmt = conn.prepareStatement(sql)
	        ) {
	            pstmt.setString(1, customerId);

	            try (ResultSet rs = pstmt.executeQuery()) {
	                while (rs.next()) {
	                    list.add(rs.getInt("order_no"));
	                }
	            }
	        }
	        return list;
	    }
	    
	    public List<order_detailVO> getOrderDetails(int orderNo) throws SQLException {

	        String sql = """
	            SELECT
	                od.detail_no,
	                od.order_no,
	                od.item_no,
	                p.item_name
	            FROM order_detail od
	            JOIN product p ON od.item_no = p.item_no
	            WHERE od.order_no = ?
	        """;

	        List<order_detailVO> list = new ArrayList<>();

	        try (
	            Connection conn = dataSource.getConnection();
	            PreparedStatement pstmt = conn.prepareStatement(sql)
	        ) {
	            pstmt.setInt(1, orderNo);

	            try (ResultSet rs = pstmt.executeQuery()) {
	                while (rs.next()) {
	                    order_detailVO vo = new order_detailVO();
	                    vo.setDetail_no(rs.getInt("detail_no"));
	                    vo.setOrder_no(rs.getInt("order_no"));
	                    vo.setItem_no(rs.getInt("item_no"));
	                    vo.setItem_name(rs.getString("item_name"));
	                    list.add(vo);
	                }
	            }
	        }
	        return list;
	    }
	}
