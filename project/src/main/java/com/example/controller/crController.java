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

import com.example.model.orderRepository;
import com.example.model.vo.CustomerVO;
import com.example.model.vo.crVO;
import com.example.model.vo.order_detailVO;
import com.example.service.orderService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/mycs")
@Slf4j
public class crController {

	@Autowired
	private com.example.model.crRepository crRepository;

	@Autowired
	private orderRepository orderRepository;
	
	@Autowired
	private orderService orderService;

	/**
	 * 취소/반품/교환 목록 조회
	 */
	
	  @GetMapping("") public String mycs(HttpSession session, Model model) {
	  
	  log.info("===== [mycs] 컨트롤러 진입 =====");
	  
	  Object sessionObj = session.getAttribute("loginUser");
	  log.info("세션 loginUser = {}", sessionObj);
	  
	  if (sessionObj == null) { log.warn("⚠️ loginUser 세션 없음 → 로그인 페이지로 이동");
	  return "redirect:/login"; }
	  
	  CustomerVO loginUser = (CustomerVO) sessionObj; log.info("로그인 사용자 ID = {}",
	  loginUser.getCustomer_id());
	  
	  try { List<crVO> crList =
	  crRepository.getCRListByCustomerId(loginUser.getCustomer_id());
	  
	  log.info("조회된 취소/반품/교환 건수 = {}", crList.size()); model.addAttribute("crList",
	  crList);
	  
	  List<Integer> orderList =
	  crRepository.getMyOrderNos(loginUser.getCustomer_id());
	  model.addAttribute("orderList", orderList);
	  
	  log.info("내 주문번호 수 = {}", orderList.size());
	  
	  } catch (SQLException e) { log.error("취소/반품/교환 목록 조회 실패", e); }
	  
	  return "mycs"; }
	 

	  @PostMapping("/apply")
	  public String applyCR(
	          @RequestParam(value = "orderNo", required = false) Integer orderNo, 
	          @RequestParam(value = "type", required = false) String type,
	          @RequestParam(value = "return_cnt", required = false) Integer returnNo,
	          @RequestParam(value = "reason", required = false) String reason,
	          @RequestParam(value = "selectedItems", required = false) String selectedItems,
	          @RequestParam(value = "isFullOrder", required = false) Boolean isFullOrder,
	          HttpSession session, 
	          RedirectAttributes ra) {
	      
	      System.out.println("🔥🔥🔥 applyCR 진입");
	      System.out.println("📥 받은 파라미터:");
	      System.out.println("  - orderNo: " + orderNo);
	      System.out.println("  - type: [" + type + "]");
	      System.out.println("  - reason: " + reason);
	      System.out.println("  - selectedItems: " + selectedItems);
	      System.out.println("  - isFullOrder: " + isFullOrder);
	      
	      // null 체크
	      if (orderNo == null || type == null || type.trim().isEmpty()) {
	          log.error("❌ 필수 파라미터 누락 - orderNo: {}, type: {}", orderNo, type);
	          ra.addFlashAttribute("message", "필수 정보가 누락되었습니다.");
	          ra.addFlashAttribute("messageType", "error");
	          return "redirect:/mydelivery";
	      }
	      
	      if (reason == null || reason.trim().isEmpty()) {
	          log.error("❌ 사유 누락");
	          ra.addFlashAttribute("message", "사유를 입력해주세요.");
	          ra.addFlashAttribute("messageType", "error");
	          return "redirect:/mydelivery";
	      }

	      CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
	      if (loginUser == null) {
	          return "redirect:/login";
	      }

	      try {
	          // 보안 체크
	          boolean isMyOrder = crRepository.isMyOrder(orderNo, loginUser.getCustomer_id());
	          if (!isMyOrder) {
	              log.warn("⚠️ 본인 주문 아님");
	              ra.addFlashAttribute("message", "본인의 주문만 신청할 수 있습니다.");
	              ra.addFlashAttribute("messageType", "error");
	              return "redirect:/mydelivery";
	          }

	          // ⭐⭐⭐ 상품 개수 체크 로직 수정 ⭐⭐⭐
	          int itemCount = crRepository.getOrderItemCount(orderNo);
	          log.info("주문 상품 개수: {}", itemCount);
	          log.info("전체 주문 여부: {}", isFullOrder);

	          // 상품이 2개 이상인데 전체 선택이 아니면 부분 취소로 간주
	          if (itemCount > 1 && (isFullOrder == null || !isFullOrder)) {
	              log.warn("⚠️ 부분 취소 시도 감지 - 상품 개수: {}, isFullOrder: {}", itemCount, isFullOrder);
	              ra.addFlashAttribute("message", 
	                  "여러 상품이 포함된 주문은 부분 " + type + "이 불가능합니다.<br>관리자 채팅으로 문의해주세요.");
	              ra.addFlashAttribute("messageType", "chat"); 
	              return "redirect:/mydelivery"; 
	          }

	          log.info("✅ 검증 통과 - 신청 진행");

	          // CR 신청
	          crVO crVO = new crVO();
	          crVO.setOrder_no(orderNo);
	          crVO.setType(type);
	          crVO.setReturn_cnt(returnNo);
	          crVO.setReason(reason);
	          crVO.setStatus("접수");

	          log.info("생성할 CR: {}", crVO);

	          int result = crRepository.insertCR(crVO);

	          if (result > 0) {
	              log.info("✅ 신청 성공 - 관리자 승인 대기");
	              
	              // 주문 상태 업데이트
	              String newStatus = "";
	              if ("취소".equals(type)) {
	                  newStatus = "취소신청";
	              } else if ("반품".equals(type)) {
	                  newStatus = "반품신청";
	              } else if ("교환".equals(type)) {
	                  newStatus = "교환신청";
	              }
	              
	              if (!newStatus.isEmpty()) {
	                  try {
	                      orderService.updateOrderStatus(orderNo, newStatus);
	                      log.info("✅ 주문 상태 업데이트 완료: {} → {}", orderNo, newStatus);
	                  } catch (Exception e) {
	                      log.error("❌ 주문 상태 업데이트 실패 (신청은 성공)", e);
	                  }
	              }
	              
	              ra.addFlashAttribute("message", type + " 신청이 완료되었습니다.<br>관리자 승인 후 처리됩니다.");
	              ra.addFlashAttribute("messageType", "success");
	          } else {
	              log.warn("❌ 신청 실패");
	              ra.addFlashAttribute("message", "신청에 실패했습니다.");
	              ra.addFlashAttribute("messageType", "error");
	          }

	      } catch (Exception e) {
	          log.error("❌ applyCR 오류", e);
	          ra.addFlashAttribute("message", "처리 중 오류가 발생했습니다: " + e.getMessage());
	          ra.addFlashAttribute("messageType", "error");
	      }

	      return "redirect:/mydelivery";
	  }
	/**
	 * 주문 상세 조회 (AJAX)
	 */
	@GetMapping("/mycs/order/details")
	@ResponseBody
	public List<order_detailVO> getOrderDetails(@RequestParam("order_no") int orderNo, HttpSession session) {

		log.info("🔥 주문 상세 조회 요청 order_no={}", orderNo);

		try {
			return crRepository.getOrderDetails(orderNo);
		} catch (SQLException e) {
			log.error("❌ 주문 상세 조회 실패 order_no={}", orderNo, e);
			return List.of();
		}
	}

	/*
	 * =============================== ⭐ 관리자 전용 메서드 ===============================
	 */

	/**
	 * 관리자 - CR 승인 처리 (재고 복구 포함)
	 */
	@PostMapping("/admin/cr/approve")
	public String approveCR(@RequestParam("crNo") int crNo, HttpSession session, RedirectAttributes ra) {

		log.info("===== [관리자] CR 승인 처리 시작 =====");
		log.info("CR 번호: {}", crNo);

		// 관리자 권한 체크 (필요시)
		CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		try {
			// 1. CR 정보 조회
			crVO cr = crRepository.getCRById(crNo);

			if (cr == null) {
				log.warn("⚠️ CR 정보 없음 - crNo: {}", crNo);
				ra.addFlashAttribute("message", "존재하지 않는 신청입니다.");
				ra.addFlashAttribute("messageType", "error");
				return "redirect:/admin/cr";
			}

			log.info("CR 정보: {}", cr);

			// 2. 상태를 "완료"로 변경
			int updateResult = crRepository.updateCRStatus(crNo, "완료");
			log.info("CR 상태 업데이트 결과: {}", updateResult);

			// 3. 취소/반품인 경우 재고 복구
			if ("취소".equals(cr.getType()) || "반품".equals(cr.getType())) {
				int restoreResult = crRepository.restoreStock(cr.getOrder_no());
				int totalQty = crRepository.getTotalQtyByOrderNo(cr.getOrder_no());

				log.info("✅ 재고 복구 완료 - 주문번호: {}, 상품 수: {}, 총 수량: {}", cr.getOrder_no(), restoreResult, totalQty);

				// 4. 주문 상태도 변경 (취소/반품 완료)
				String orderStatus = "취소".equals(cr.getType()) ? "취소완료" : "반품완료";
				crRepository.updateOrderStatus(cr.getOrder_no(), orderStatus);

				ra.addFlashAttribute("message", "승인 완료되었습니다.<br>재고 " + totalQty + "개가 복구되었습니다.");
			} else if ("교환".equals(cr.getType())) {
				// 교환인 경우 주문 상태 변경
				crRepository.updateOrderStatus(cr.getOrder_no(), "교환완료");
				ra.addFlashAttribute("message", "교환 승인이 완료되었습니다.");
			} else {
				ra.addFlashAttribute("message", "승인 완료되었습니다.");
			}

			ra.addFlashAttribute("messageType", "success");
			log.info("✅ CR 승인 처리 완료");

		} catch (Exception e) {
			log.error("❌ CR 승인 실패", e);
			ra.addFlashAttribute("message", "승인 처리 중 오류가 발생했습니다.");
			ra.addFlashAttribute("messageType", "error");
		}

		return "redirect:/admin/cr";
	}

	/**
	 * 관리자 - CR 거부 처리
	 */
	@PostMapping("/admin/cr/reject")
	public String rejectCR(@RequestParam("crNo") int crNo,
			@RequestParam(value = "rejectReason", required = false) String rejectReason, HttpSession session,
			RedirectAttributes ra) {

		log.info("===== [관리자] CR 거부 처리 시작 =====");
		log.info("CR 번호: {}, 거부 사유: {}", crNo, rejectReason);

		CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		try {
			// 상태를 "거부"로 변경
			int result = crRepository.updateCRStatus(crNo, "거부");

			if (result > 0) {
				log.info("✅ CR 거부 처리 완료");
				ra.addFlashAttribute("message", "신청이 거부되었습니다.");
				ra.addFlashAttribute("messageType", "success");
			} else {
				ra.addFlashAttribute("message", "거부 처리에 실패했습니다.");
				ra.addFlashAttribute("messageType", "error");
			}

		} catch (Exception e) {
			log.error("❌ CR 거부 실패", e);
			ra.addFlashAttribute("message", "거부 처리 중 오류가 발생했습니다.");
			ra.addFlashAttribute("messageType", "error");
		}

		return "redirect:/admin/cr";
	}

	/**
	 * 관리자 - CR 목록 조회
	 */
	@GetMapping("/admin/cr")
	public String adminCRList(HttpSession session, Model model) {

		CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		// TODO: 관리자 권한 체크

		try {
			// 모든 CR 목록 조회 (관리자용 메서드 필요)
			// List<crVO> allCRList = crRepository.getAllCRList();
			// model.addAttribute("crList", allCRList);

			log.info("관리자 CR 목록 페이지");

		} catch (Exception e) {
			log.error("CR 목록 조회 실패", e);
		}

		return "admin/cr-list"; // 관리자 CR 관리 페이지
	}

	// 주문내역 페이지
	@GetMapping("/order/mypage")
	public String orderList(HttpSession session, Model model) {
		try {
			// 로그인 체크
			CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
			if (loginUser == null) {
				return "redirect:/login";
			}

			// 전체 주문내역 조회
			List<order_detailVO> deliveryList = orderRepository.getDeliveryList(loginUser.getCustomer_id());

			// 로그로 확인
			log.info("주문내역 개수: {}", deliveryList.size());
			for (order_detailVO d : deliveryList) {
				log.info("주문번호: {}, 상품명: {}, 금액: {}", d.getOrder_no(), d.getItem_name(), d.getAmount());
			}

			model.addAttribute("deliveryList", deliveryList);
			return "/mypage"; // JSP 파일명

		} catch (SQLException e) {
			log.error("주문내역 조회 실패", e);
			model.addAttribute("error", "주문내역을 불러오는데 실패했습니다.");
			return "error";
		}
	}
	// crController.java에 추가
	@PostMapping("/admin/cr/cleanup")
	public String cleanupDuplicateCR(RedirectAttributes ra) {
	    log.info("===== 중복 CR 정리 시작 =====");
	    
	    try {
	        int deletedCount = crRepository.deleteDuplicateCR();
	        log.info("✅ 중복 CR {} 건 삭제 완료", deletedCount);
	        
	        ra.addFlashAttribute("message", "중복 데이터 " + deletedCount + "건이 삭제되었습니다.");
	        ra.addFlashAttribute("messageType", "success");
	    } catch (Exception e) {
	        log.error("❌ 중복 CR 삭제 실패", e);
	        ra.addFlashAttribute("message", "삭제 중 오류가 발생했습니다.");
	        ra.addFlashAttribute("messageType", "error");
	    }
	    
	    return "redirect:/admin/cr";
	}
}
