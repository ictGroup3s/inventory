package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.model.crRepository;
import com.example.model.vo.crVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class crServiceImple implements crService {
	
	@Autowired
	private crRepository crRepository;
    
    @Override
    public List<crVO> getCrList(String userId) {
        log.info("사용자 {}의 취소/반품/교환 내역 조회", userId);
        try {
            return crRepository.findByUserId(userId);
        } catch (Exception e) {
            log.error("취소/반품/교환 내역 조회 실패", e);
            throw new RuntimeException("내역 조회 중 오류가 발생했습니다.", e);
        }
    }
    
    @Override
    public crVO getCrDetail(Integer crNo) {
        log.info("취소/반품/교환 상세 조회: {}", crNo);
        try {
            return crRepository.findById(crNo);
        } catch (Exception e) {
            log.error("상세 조회 실패", e);
            throw new RuntimeException("상세 조회 중 오류가 발생했습니다.", e);
        }
    }
    
    @Override
    @Transactional
    public boolean applyCr(crVO crVO) {
        log.info("취소/반품/교환 신청: 주문번호={}, 유형={}", 
                 crVO.getOrder_no(), crVO.getType());
        
        try {
            // 중복 신청 체크
            if (isDuplicateRequest(crVO.getDetail_no())) {
                log.warn("이미 처리 중인 신청이 있습니다: detail_no={}", crVO.getDetail_no());
                throw new RuntimeException("이미 처리 중인 신청이 있습니다.");
            }
            
            // 상태 기본값 설정
            if (crVO.getStatus() == null) {
                crVO.setStatus("신청");
            }
            
            int result = crRepository.insert(crVO);
            if (result > 0) {
                log.info("취소/반품/교환 신청 완료: crNo={}", crVO.getCr_no());
                return true;
            }
            return false;
        } catch (Exception e) {
            log.error("취소/반품/교환 신청 실패", e);
            throw new RuntimeException("신청 처리 중 오류가 발생했습니다.", e);
        }
    }
    
    @Override
    @Transactional
    public boolean updateCrStatus(Integer crNo, String status) {
        log.info("취소/반품/교환 상태 변경: crNo={}, status={}", crNo, status);
        
        try {
            int result = crRepository.updateStatus(crNo, status);
            if (result > 0) {
                log.info("상태 변경 완료");
                return true;
            }
            return false;
        } catch (Exception e) {
            log.error("상태 변경 실패", e);
            throw new RuntimeException("상태 변경 중 오류가 발생했습니다.", e);
        }
    }
    
    @Override
    public List<crVO> getCrByOrderNo(Integer orderNo) {
        log.info("주문번호 {}의 취소/반품/교환 내역 조회", orderNo);
        try {
            return crRepository.findByOrderNo(orderNo);
        } catch (Exception e) {
            log.error("주문번호로 조회 실패", e);
            throw new RuntimeException("조회 중 오류가 발생했습니다.", e);
        }
    }
    
    @Override
    public boolean isDuplicateRequest(Integer detailNo) {
        try {
            int count = crRepository.countByDetailNo(detailNo);
            return count > 0;
        } catch (Exception e) {
            log.error("중복 체크 실패", e);
            return false;
        }
    }

}
