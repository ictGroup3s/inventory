package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.model.vo.CustomerVO;
import com.example.model.vo.crVO;
import com.example.service.crService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class crController {
	
	@Autowired
	private crService crService;
    
    /**
     * 취소/반품/교환 내역 페이지
     */
	@GetMapping("/mycs")
	public String mycsPage(HttpSession session, Model model) {
	    log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
	    log.info("┃  🔍 취소/반품/교환 내역 조회 시작                  ┃");
	    log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
	    
	    try {
	        // 세션에서 CustomerVO 객체 가져오기
	        CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
	        
	        if (loginUser == null) {
	            log.error("❌ 로그인 정보 없음!");
	            return "redirect:/login";
	        }
	        
	        String customerId = loginUser.getCustomer_id();
	        log.info("   ✅ 사용자 ID: {}", customerId);
	        
	        // DB 조회
	        List<crVO> crList = crService.getCrList(customerId);
	        model.addAttribute("crList", crList);
	        
	        log.info("   ✅ 조회 완료: {} 건", crList.size());
	        
	        return "mycs";
	        
	    } catch (Exception e) {
	        log.error("❌ 에러 발생!", e);
	        model.addAttribute("errorMessage", "데이터를 불러오는 중 오류가 발생했습니다.");
	        return "mycs";
	    }
	}
    
    /**
     * 취소/반품/교환 신청 처리
     */
    @PostMapping("/mycs/apply")
    public String applyCr(
            @ModelAttribute crVO crVO,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        // 세션에서 사용자 ID 가져오기
        String loginUser = (String) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "redirect:/login";
        }
        
        try {
            boolean success = crService.applyCr(crVO);
            
            if (success) {
                redirectAttributes.addFlashAttribute("message", "신청이 완료되었습니다.");
                redirectAttributes.addFlashAttribute("messageType", "success");
                log.info("취소/반품/교환 신청 성공: {}", crVO.getCr_no());
            } else {
                redirectAttributes.addFlashAttribute("message", "신청에 실패했습니다.");
                redirectAttributes.addFlashAttribute("messageType", "error");
            }
        } catch (RuntimeException e) {
            log.error("취소/반품/교환 신청 오류", e);
            redirectAttributes.addFlashAttribute("message", e.getMessage());
            redirectAttributes.addFlashAttribute("messageType", "error");
        } catch (Exception e) {
            log.error("예상치 못한 오류 발생", e);
            redirectAttributes.addFlashAttribute("message", "시스템 오류가 발생했습니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
        }
        
        return "redirect:/mycs";
    }
    
    /**
     * 취소/반품/교환 상세 조회 (Ajax)
     */
    @GetMapping("/mycs/detail/{crNo}")
    @ResponseBody
    public crVO getCrDetail(@PathVariable Integer crNo) {
        try {
            return crService.getCrDetail(crNo);
        } catch (Exception e) {
            log.error("상세 조회 실패: crNo={}", crNo, e);
            return null;
        }
    }
    
    /**
     * 취소/반품/교환 상태 변경 (관리자용)
     */
    @PostMapping("/mycs/status")
    @ResponseBody
    public String updateStatus(
            @RequestParam Integer crNo,
            @RequestParam String status,
            HttpSession session) {
        
        // 관리자 권한 체크 (실제 구현에 맞게 수정)
        String loginRole = (String) session.getAttribute("loginRole");
        if (!"ADMIN".equals(loginRole)) {
            return "unauthorized";
        }
        
        try {
            boolean success = crService.updateCrStatus(crNo, status);
            return success ? "success" : "fail";
        } catch (Exception e) {
            log.error("상태 변경 오류", e);
            return "error";
        }
    }
    
    /**
     * 주문번호로 취소/반품/교환 내역 조회 (Ajax)
     */
    @GetMapping("/mycs/order/{orderNo}")
    @ResponseBody
    public List<crVO> getCrByOrderNo(@PathVariable Integer orderNo) {
        try {
            return crService.getCrByOrderNo(orderNo);
        } catch (Exception e) {
            log.error("주문번호로 조회 실패: orderNo={}", orderNo, e);
            return null;
        }
    }

}
