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
    public List<crVO> getCrList(String loginUser) {
        log.info("사용자 {}의 취소/반품/교환 내역 조회", loginUser);
        try {
            // ⭐ findByUserId → getCRListByCustomerId로 변경
            return crRepository.getCRListByCustomerId(loginUser);
        } catch (Exception e) {
            log.error("취소/반품/교환 내역 조회 실패", e);
            throw new RuntimeException("내역 조회 중 오류가 발생했습니다.", e);
        }
    }
    
    @Override
    public crVO getCrDetail(Integer crNo) {
        log.info("취소/반품/교환 상세 조회: {}", crNo);
        try {
            // ⭐ Repository에 getCrDetail 메서드 추가 필요
            // 임시로 리스트에서 찾기 (나중에 Repository에 메서드 추가 권장)
            throw new UnsupportedOperationException("getCrDetail 메서드가 Repository에 구현되지 않았습니다.");
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
            // 중복 신청 체크는 일단 생략 (필요시 Repository에 추가)
            
            // 상태 기본값 설정
            if (crVO.getStatus() == null) {
                crVO.setStatus("신청");
            }
            
            // ⭐ insert → insertCR로 변경
            int result = crRepository.insertCR(crVO);
            if (result > 0) {
                log.info("취소/반품/교환 신청 완료");
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
            // ⭐ Repository에 updateCrStatus 메서드 추가 필요
            throw new UnsupportedOperationException("updateCrStatus 메서드가 Repository에 구현되지 않았습니다.");
        } catch (Exception e) {
            log.error("상태 변경 실패", e);
            throw new RuntimeException("상태 변경 중 오류가 발생했습니다.", e);
        }
    }
    
    @Override
    public List<crVO> getCrByOrderNo(Integer orderNo) {
        log.info("주문번호 {}의 취소/반품/교환 내역 조회", orderNo);
        try {
            // ⭐ Repository에 getCrByOrderNo 메서드 추가 필요
            throw new UnsupportedOperationException("getCrByOrderNo 메서드가 Repository에 구현되지 않았습니다.");
        } catch (Exception e) {
            log.error("주문번호로 조회 실패", e);
            throw new RuntimeException("조회 중 오류가 발생했습니다.", e);
        }
    }
    
    @Override
    public boolean isDuplicateRequest(Integer detailNo) {
        try {
            // ⭐ Repository에 countByDetailNo 메서드 추가 필요
            // 일단 false 반환 (중복 체크 비활성화)
            return false;
        } catch (Exception e) {
            log.error("중복 체크 실패", e);
            return false;
        }
    }
}