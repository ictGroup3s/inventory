package com.example.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.model.vo.crVO;

@Service
public interface crService {
	
	 // 사용자별 취소/반품/교환 내역 조회
    List<crVO> getCrList(String userId);
    
    // 취소/반품/교환 상세 조회
    crVO getCrDetail(Integer crNo);
    
    // 취소/반품/교환 신청
    boolean applyCr(crVO crVO);
    
    // 취소/반품/교환 상태 변경
    boolean updateCrStatus(Integer crNo, String status);
    
    // 주문번호로 취소/반품/교환 내역 조회
    List<crVO> getCrByOrderNo(Integer orderNo);
    
    // 중복 신청 체크
    boolean isDuplicateRequest(Integer detailNo);
}
