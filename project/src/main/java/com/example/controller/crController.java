package com.example.controller;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.model.vo.CustomerVO;
import com.example.model.vo.crVO;
import com.example.model.vo.order_detailVO;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/mycs")
@Slf4j
public class crController {

    @Autowired
    private com.example.model.crRepository crRepository;

    /**
     * 취소/반품/교환 목록 조회
     */
    @GetMapping
    public String mycs(HttpSession session, Model model) {

        log.info("===== [mycs] 컨트롤러 진입 =====");

        Object sessionObj = session.getAttribute("loginUser");
        log.info("세션 loginUser = {}", sessionObj);

        if (sessionObj == null) {
            log.warn("⚠️ loginUser 세션 없음 → 로그인 페이지로 이동");
            return "redirect:/login";
        }

        CustomerVO loginUser = (CustomerVO) sessionObj;
        log.info("로그인 사용자 ID = {}", loginUser.getCustomer_id());

        try {
        	// 🔹 기존 CR 목록
            List<crVO> crList =
                crRepository.getCRListByCustomerId(loginUser.getCustomer_id());

            log.info("조회된 취소/반품/교환 건수 = {}", crList.size());
            model.addAttribute("crList", crList);
            
            // ✅ 주문번호 목록
            List<Integer> orderList = crRepository.getMyOrderNos(loginUser.getCustomer_id());
            model.addAttribute("orderList", orderList);

            log.info("내 주문번호 수 = {}", orderList.size());

        } catch (SQLException e) {
            log.error("취소/반품/교환 목록 조회 실패", e);
        }

        return "mycs";
    }
    /**
     * 취소/반품/교환 신청 처리
     */
        // ✅ 안전한 로그
    @PostMapping("/apply")
    public String applyCR(
            @RequestParam("order_no") int orderNo,
            @RequestParam("type") String type,
            @RequestParam(value = "return_cnt", required = false) Integer returnNo,
            @RequestParam("reason") String reason,
            HttpSession session,
            RedirectAttributes ra) {

        CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        try {
            int itemCount = crRepository.getOrderItemCount(orderNo);

            if (itemCount > 1) {
                ra.addFlashAttribute("message",
                    "여러 상품이 포함된 주문은 부분 취소가 불가능합니다.<br>관리자 채팅으로 문의해주세요.");
                ra.addFlashAttribute("messageType", "chat");
                return "redirect:/mycs";
            }

            // 🔥🔥🔥 여기 !!!
            if ("교환".equals(type) && returnNo == null) {
                ra.addFlashAttribute("message", "교환 시 교환할 상품을 선택해주세요.");
                ra.addFlashAttribute("messageType", "error");
                return "redirect:/mycs";
            }

            // ===== 정상 흐름 =====
            crVO crVO = new crVO();
            crVO.setOrder_no(orderNo);
            crVO.setType(type);
            crVO.setReturn_cnt(returnNo); // 교환 아닐 땐 null
            crVO.setReason(reason);
            crVO.setStatus("접수");

            int result = crRepository.insertCR(crVO);

            if (result > 0) {
                ra.addFlashAttribute("message", "신청이 완료되었습니다.");
                ra.addFlashAttribute("messageType", "success");
            } else {
                ra.addFlashAttribute("message", "신청에 실패했습니다.");
                ra.addFlashAttribute("messageType", "error");
            }

        } catch (Exception e) {
            log.error("❌ applyCR 오류", e);
            ra.addFlashAttribute("message", "처리 중 오류가 발생했습니다.");
            ra.addFlashAttribute("messageType", "error");
        }

        return "redirect:/mycs";
    }
        
        @GetMapping("/order/details")
        @ResponseBody
        public List<order_detailVO> getOrderDetails(
                @RequestParam("order_no") int orderNo,
                HttpSession session) {

            log.info("🔥 주문 상세 조회 요청 order_no={}", orderNo);

            try {
                return crRepository.getOrderDetails(orderNo);
            } catch (SQLException e) {
                log.error("❌ 주문 상세 조회 실패 order_no={}", orderNo, e);
                return List.of(); // 빈 리스트 반환 (JS 에러 방지)
            }
        }
}
