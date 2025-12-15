package com.example.model;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.example.model.vo.crVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class crRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // RowMapper 정의
    private RowMapper<crVO> crRowMapper = new RowMapper<crVO>() {
        @Override
        public crVO mapRow(ResultSet rs, int rowNum) throws SQLException {
            crVO vo = new crVO();
            vo.setCr_no(rs.getInt("cr_no"));
            vo.setOrder_no(rs.getInt("order_no"));
            vo.setDetail_no(rs.getObject("detail_No", Integer.class));
            vo.setType(rs.getString("type"));
            vo.setReturn_cnt(rs.getInt("return_cnt"));
            vo.setStatus(rs.getString("status"));
            vo.setReason(rs.getString("reason"));
            vo.setRe_date(rs.getTimestamp("re_date"));
            return vo;
        }
    };

    // 사용자별 취소/반품/교환 내역 조회
    public List<crVO> findByUserId(String loginUser) {
        log.info("사용자 {} 취소/반품/교환 내역 조회", loginUser);
        
        String sql ="SELECT " +
        	    	    "c.cr_no, " +
        	    	    "c.order_no, " +
        	    	    "c.detail_no, " +
        	    	    "c.type AS type, " +
        	    	    "c.return_cnt, " +
        	    	    "c.status AS status, " +
        	    	    "c.reason, " +
        	    	    "c.re_date " +
        	    	    "FROM cr c " +
        	    	    "JOIN orders o ON c.order_no = o.order_no " +
        	    	    "WHERE o.customer_id = ? " +
        	    	    "ORDER BY c.re_date DESC";

        return jdbcTemplate.query(sql, crRowMapper, loginUser);
    }

    // 취소/반품/교환 상세 조회
    public crVO findById(Integer crNo) {
        log.info("취소/반품/교환 상세 조회: {}", crNo);
        
        String sql = "SELECT * FROM cr WHERE cr_no = ?";

        try {
            return jdbcTemplate.queryForObject(sql, crRowMapper, crNo);
        } catch (Exception e) {
            log.error("상세 조회 실패: crNo={}", crNo, e);
            return null;
        }
    }

    // 취소/반품/교환 신청
    public int insert(crVO vo) {
        log.info("취소/반품/교환 신청: {}", vo);
        
        String sql = "INSERT INTO cr (order_no, detail_no, type, return_no, status, reason, re_date) " +
                     "VALUES (?, ?, ?, ?, '신청', ?, sysdate())";

        return jdbcTemplate.update(
            sql,
            vo.getOrder_no(),
            vo.getDetail_no(),
            vo.getType(),
            vo.getReturn_cnt(),
            vo.getReason()
        );
    }

    // 상태 업데이트
    public int updateStatus(Integer crNo, String status) {
        log.info("상태 변경: crNo={}, status={}", crNo, status);
        
        String sql = "UPDATE cr SET status = ? WHERE cr_no = ?";

        return jdbcTemplate.update(sql, status, crNo);
    }

    // 주문번호로 조회
    public List<crVO> findByOrderNo(Integer orderNo) {
        log.info("주문번호 {} 취소/반품/교환 내역 조회", orderNo);
        
        String sql = "SELECT * FROM cr WHERE order_no = ? ORDER BY re_date DESC";

        return jdbcTemplate.query(sql, crRowMapper, orderNo);
    }

    // 중복 신청 체크
    public int countByDetailNo(Integer detailNo) {
        log.info("중복 신청 체크: detailNo={}", detailNo);
        
        String sql = "SELECT COUNT(*) FROM cr " +
                     "WHERE detail_no = ? AND status IN ('신청', '승인')";

        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, detailNo);
        return count != null ? count : 0;
    }

    // 전체 목록 조회
    public List<crVO> findAll() {
        log.info("전체 취소/반품/교환 내역 조회");
        
        String sql = "SELECT * FROM cr ORDER BY re_date DESC";

        return jdbcTemplate.query(sql, crRowMapper);
    }

    // 상태별 조회
    public List<crVO> findByStatus(String status) {
        log.info("상태별 취소/반품/교환 내역 조회: status={}", status);
        
        String sql = "SELECT * FROM cr WHERE status = ? ORDER BY re_date DESC";

        return jdbcTemplate.query(sql, crRowMapper, status);
    }

    // 유형별 조회
    public List<crVO> findByType(String type) {
        log.info("유형별 취소/반품/교환 내역 조회: type={}", type);
        
        String sql = "SELECT * FROM cr WHERE type = ? ORDER BY re_date DESC";

        return jdbcTemplate.query(sql, crRowMapper, type);
    }
}