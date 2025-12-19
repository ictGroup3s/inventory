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
	 

	 /* ===============================
     고객용 메서드
     =============================== */

  /**
   * 취소/반품/교환 목록 조회 (고객별)
   */
  public List<crVO> getCRListByCustomerId(String customerId) throws SQLException {
      log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
      log.info("┃  📋 취소/반품/교환 목록 조회 (Repository)           ┃");
      log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
      log.info("   - customerId: {}", customerId);
      
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
      		MIN(p.item_name) || ' 외 ' || (COUNT(*)- 1) || '건' AS item_name
      		FROM cr
      		JOIN orders o ON cr.order_no = o.order_no
      		JOIN order_detail od ON o.order_no = od.order_no
      		JOIN product p ON od.item_no = p.item_no
      		WHERE o.customer_id = ?
      		GROUP BY
      		cr.cr_no,
      		cr.order_no,
      		cr.type,
      		cr.return_cnt,
      		cr.reason,
      		cr.status,
      		cr.re_date
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

  /**
   * 취소/반품/교환 신청
   */
  public int insertCR(crVO crVO) throws SQLException {

      log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
      log.info("┃  📝 CR 신청 등록                                    ┃");
      log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");

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

          int result = pstmt.executeUpdate();
          
          log.info("   ✅ CR 신청 등록 완료 - 주문번호: {}, 유형: {}", 
              crVO.getOrder_no(), crVO.getType());
          
          return result;
      }
  }

  /**
   * 주문 상품 개수
   */
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
              if (rs.next()) {
                  int count = rs.getInt(1);
                  log.info("   - 주문 {} 상품 개수: {}", orderNo, count);
                  return count;
              }
          }
      }
      return 0;
  }

  /**
   * 🔐 내 주문인지 확인 (보안 핵심)
   */
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
              boolean isMine = rs.getInt(1) > 0;
              log.info("   - 주문 {} 소유 확인: {}", orderNo, isMine);
              return isMine;
          }
      }
  }
 
  /**
   * 내 주문번호 목록 조회
   */
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
      
      log.info("   - 고객 {} 주문번호 개수: {}", customerId, list.size());
      
      return list;
  }
  
  /**
   * 주문 상세 조회 (상품 목록)
   */
  public List<order_detailVO> getOrderDetails(int orderNo) throws SQLException {

      String sql = """
          SELECT
              od.detail_no,
              od.order_no,
              od.item_no,
              od.qty,
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
                  vo.setQty(rs.getInt("qty"));
                  vo.setItem_name(rs.getString("item_name"));
                  list.add(vo);
              }
          }
      }
      
      log.info("   - 주문 {} 상세 조회: {} 건", orderNo, list.size());
      
      return list;
  }

  /* ===============================
     관리자용 메서드
     =============================== */

  /**
   * CR 번호로 CR 정보 조회 (관리자용)
   */
  public crVO getCRById(int crNo) throws SQLException {
      
      log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
      log.info("┃  🔍 CR 상세 조회 - CR 번호: {}                      ┃", crNo);
      log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
      
      String sql = """
          SELECT
              cr.cr_no,
              cr.order_no,
              cr.type,
              cr.return_cnt,
              cr.reason,
              cr.status,
              cr.re_date
          FROM cr
          WHERE cr_no = ?
      """;
      
      try (
          Connection conn = dataSource.getConnection();
          PreparedStatement pstmt = conn.prepareStatement(sql)
      ) {
          pstmt.setInt(1, crNo);
          
          try (ResultSet rs = pstmt.executeQuery()) {
              if (rs.next()) {
                  crVO vo = new crVO();
                  vo.setCr_no(rs.getInt("cr_no"));
                  vo.setOrder_no(rs.getInt("order_no"));
                  vo.setType(rs.getString("type"));
                  vo.setReturn_cnt(rs.getObject("return_cnt", Integer.class));
                  vo.setReason(rs.getString("reason"));
                  vo.setStatus(rs.getString("status"));
                  vo.setRe_date(rs.getTimestamp("re_date"));
                  
                  log.info("   ✅ CR 조회 완료 - 주문번호: {}, 유형: {}", 
                      vo.getOrder_no(), vo.getType());
                  
                  return vo;
              }
          }
      }
      
      log.warn("   ⚠️  CR 정보 없음 - crNo: {}", crNo);
      return null;
  }

  /**
   * 모든 CR 목록 조회 (관리자용)
   */
  public List<crVO> getAllCRList() throws SQLException {
      
      log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
      log.info("┃  📋 전체 CR 목록 조회 (관리자)                      ┃");
      log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
      
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
              o.customer_id,
              p.item_name
          FROM cr
          JOIN orders o ON cr.order_no = o.order_no
          JOIN order_detail od ON o.order_no = od.order_no
          JOIN product p ON od.item_no = p.item_no
          ORDER BY cr.re_date DESC
      """;
      
      try (Connection conn = dataSource.getConnection();
           PreparedStatement pstmt = conn.prepareStatement(sql)) {

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
              // customer_id 필드가 있다면 추가
              // vo.setCustomer_id(rs.getString("customer_id"));
              
              list.add(vo);
          }
          
          log.info("   ✅ 전체 CR 조회 성공: {} 건", list.size());
      } catch (Exception e) {
          log.error("   ❌ 조회 실패!", e);
          throw e;
      }
      
      return list;
  }

  /**
   * CR 상태 업데이트 (관리자용)
   */
  public int updateCRStatus(int crNo, String status) throws SQLException {
      
      log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
      log.info("┃  🔄 CR 상태 업데이트                                ┃");
      log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
      
      String sql = """
          UPDATE cr
          SET status = ?
          WHERE cr_no = ?
      """;
      
      try (
          Connection conn = dataSource.getConnection();
          PreparedStatement pstmt = conn.prepareStatement(sql)
      ) {
          pstmt.setString(1, status);
          pstmt.setInt(2, crNo);
          
          int result = pstmt.executeUpdate();
          
          log.info("   ✅ CR 상태 업데이트 - crNo: {}, 새 상태: {}", crNo, status);
          
          return result;
      }
  }

  /* ===============================
     재고 복구 메서드
     =============================== */

  /**
   * 주문 취소/반품 시 재고 복구
   */
  public int restoreStock(int orderNo) throws SQLException {
      
      log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
      log.info("┃  📦 재고 복구 시작 - 주문번호: {}                    ┃", orderNo);
      log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
      
      String sql = """
          UPDATE product p
          SET stock = stock + (
              SELECT od.qty
              FROM order_detail od
              WHERE od.order_no = ?
              AND od.item_no = p.item_no
          )
          WHERE item_no IN (
              SELECT item_no
              FROM order_detail
              WHERE order_no = ?
          )
      """;
      
      try (
          Connection conn = dataSource.getConnection();
          PreparedStatement pstmt = conn.prepareStatement(sql)
      ) {
          pstmt.setInt(1, orderNo);
          pstmt.setInt(2, orderNo);
          
          int result = pstmt.executeUpdate();
          
          log.info("   ✅ 재고 복구 완료 - 영향받은 상품 수: {}", result);
          
          return result;
          
      } catch (Exception e) {
          log.error("   ❌ 재고 복구 실패!", e);
          throw e;
      }
  }

  /**
   * 주문의 총 수량 조회
   */
  public int getTotalQtyByOrderNo(int orderNo) throws SQLException {
      
      String sql = """
          SELECT SUM(qty) as total_qty
          FROM order_detail
          WHERE order_no = ?
      """;
      
      try (
          Connection conn = dataSource.getConnection();
          PreparedStatement pstmt = conn.prepareStatement(sql)
      ) {
          pstmt.setInt(1, orderNo);
          
          try (ResultSet rs = pstmt.executeQuery()) {
              if (rs.next()) {
                  int totalQty = rs.getInt("total_qty");
                  log.info("   - 주문 {} 총 수량: {}", orderNo, totalQty);
                  return totalQty;
              }
          }
      }
      return 0;
  }

  /**
   * 주문 상태 업데이트 (취소/반품/교환 완료 시)
   */
  public int updateOrderStatus(int orderNo, String status) throws SQLException {
      
      log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
      log.info("┃  🔄 주문 상태 업데이트                              ┃");
      log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
      
      String sql = """
          UPDATE orders
          SET order_status = ?
          WHERE order_no = ?
      """;
      
      try (
          Connection conn = dataSource.getConnection();
          PreparedStatement pstmt = conn.prepareStatement(sql)
      ) {
          pstmt.setString(1, status);
          pstmt.setInt(2, orderNo);
          
          int result = pstmt.executeUpdate();
          
          log.info("   ✅ 주문 상태 업데이트 - orderNo: {}, 새 상태: {}", orderNo, status);
          
          return result;
      }
  }
}
