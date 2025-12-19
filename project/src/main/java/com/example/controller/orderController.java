package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.model.orderRepository;
import com.example.model.vo.CartItemVO;
import com.example.model.vo.CustomerVO;
import com.example.model.vo.order_detailVO;
import com.example.model.vo.ordersVO;
import com.example.service.CartService;
import com.example.service.orderService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
/* @RequestMapping("/order") */
public class orderController {

	@Autowired
	private orderRepository repo;
	@Autowired
	private CartService cartService; // 장바구니 서비스
	@Autowired
	private orderService orderService;

	public orderController(orderRepository repo, CartService cartService) {
		this.repo = repo;
		this.cartService = cartService;
	}

	// 결제 버튼 클릭 → 주문 저장 → 결제 완료 페이지 이동
	@PostMapping("/checkout")
	public String processCheckout(HttpSession session) throws Exception {
		String loginUser = (String) session.getAttribute("loginUser");

		// 1. 주문 저장
		int orderNo = repo.insertOrder(loginUser);

		// 2. 장바구니 기반 주문 상세 저장
		List<CartItemVO> cartItems = cartService.getCartItems(session);
		repo.insertOrderDetail(orderNo, cartItems);

		// 3. 방금 주문한 번호를 세션에 저장
		session.setAttribute("lastOrderNo", orderNo);

		// 4. 결제 완료 페이지로 이동
		return "redirect:/ordercomplete";
	}

	// ⭐⭐⭐ 주문내역 페이지 - 결제완료된 주문만 조회
	@GetMapping("/orderhistory")
	public String orderHistory(HttpSession session, Model model) {
		log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
		log.info("┃  🔍 주문내역 조회 시작                              ┃");
		log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");

		try {
			// 1. 세션 확인
			log.info("📌 STEP 1: 세션 확인");
			log.info("   - 세션 ID: {}", session.getId());
			log.info("   - 세션 속성 목록:");
			session.getAttributeNames().asIterator().forEachRemaining(name -> {
				log.info("     * {}: {}", name, session.getAttribute(name));
			});

			// 2. 로그인 체크
			log.info("📌 STEP 2: 로그인 사용자 확인");
			CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");

			if (loginUser == null) {
				log.error("❌ 로그인 정보 없음! 로그인 페이지로 리다이렉트");
				return "redirect:/login";
			}

			String customerId = loginUser.getCustomer_id();
			log.info("   ✅ 로그인 사용자 정보:");
			log.info("      - ID: {}", customerId);
			log.info("      - 이름: {}", loginUser.getName());
			log.info("      - 이메일: {}", loginUser.getEmail());

			// 3. DB 조회 - ⭐ ordersVO 타입으로 변경
			log.info("📌 STEP 3: DB 조회 시작");
			log.info("   - 조회 대상 customer_id: {}", customerId);
			log.info("   - orderService 객체: {}", orderService != null ? "정상" : "NULL!");

			List<ordersVO> deliveryList = null;

			try {
				// ⭐ 주문번호별로 그룹핑된 데이터 조회
				deliveryList = orderService.getDeliveryGroupedList(customerId);
				log.info("   ✅ DB 조회 성공!");
			} catch (Exception e) {
				log.error("   ❌ DB 조회 중 에러 발생!", e);
				log.error("   에러 메시지: {}", e.getMessage());
				throw e;
			}

			// 4. 조회 결과 확인
			log.info("📌 STEP 4: 조회 결과 확인");
			log.info("   - deliveryList 객체: {}", deliveryList != null ? "정상" : "NULL!");
			log.info("   - 조회된 주문 개수: {}", deliveryList != null ? deliveryList.size() : 0);

			if (deliveryList != null && !deliveryList.isEmpty()) {
				log.info("   ✅ 주문 내역 상세:");
				for (int i = 0; i < deliveryList.size(); i++) {
					ordersVO order = deliveryList.get(i);
					log.info("   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
					log.info("   [주문 #{}]", (i + 1));
					log.info("      - 주문번호: {}", order.getOrder_no());
					log.info("      - 총 금액: {}원", order.getTotal_amount());
					log.info("      - 주문상태: {}", order.getOrder_status());
					log.info("      - 주문일시: {}", order.getOrder_date());
					log.info("      - 상품 개수: {}", order.getDetailList() != null ? order.getDetailList().size() : 0);

					// 상품 상세 정보
					if (order.getDetailList() != null && !order.getDetailList().isEmpty()) {
						for (int j = 0; j < order.getDetailList().size(); j++) {
							order_detailVO detail = order.getDetailList().get(j);
							log.info("         [상품 {}] {}, 수량: {}개, 금액: {}원", (j + 1), detail.getItem_name(),
									detail.getItem_cnt(), detail.getAmount());
						}
					}
				}
			} else {
				log.warn("   ⚠️ 조회된 주문내역이 없습니다!");
				log.warn("   💡 확인사항:");
				log.warn("      1. DB에 customer_id = '{}' 인 주문이 있나요?", customerId);
				log.warn("      2. 주문 상태가 '결제완료' 인가요?");
				log.warn("      3. orders 테이블과 order_detail 테이블에 데이터가 있나요?");
			}

			// 5. Model에 데이터 추가
			log.info("📌 STEP 5: JSP로 데이터 전달");
			model.addAttribute("deliveryList", deliveryList);
			log.info("   - Model에 deliveryList 추가 완료");
			log.info("   - 반환할 JSP: orderhistory.jsp");

			log.info("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
			log.info("┃  ✅ 주문내역 조회 완료                              ┃");
			log.info("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");

			return "orderhistory";

		} catch (Exception e) {
			log.error("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
			log.error("┃  ❌ 에러 발생!                                      ┃");
			log.error("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
			log.error("에러 타입: {}", e.getClass().getName());
			log.error("에러 메시지: {}", e.getMessage());
			e.printStackTrace();
			model.addAttribute("error", "주문내역을 불러오는데 실패했습니다: " + e.getMessage());
			
			return "orderhistory";
		}
	}
	
	@GetMapping("/mydelivery")
	public String myDelivery(HttpSession session, Model model) {
		try {
			log.info("========== 배송내역 조회 시작 ==========");

			CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
			if (loginUser == null) {
				return "redirect:/login";
			}

			String customerId = loginUser.getCustomer_id();

			// ⭐ 그룹핑된 주문 목록 조회
			List<ordersVO> orderList = repo.getDeliveryGroupedList(customerId);

			log.info("조회된 주문 개수: {}", orderList.size());

			model.addAttribute("deliveryList", orderList);

			return "mydelivery";

		} catch (Exception e) {
			log.error("❌ 배송내역 조회 중 오류 발생", e);
			e.printStackTrace();
			return "mydelivery";
		}
	}

	@PostMapping("/order/submit")
	public String submitOrder(@RequestParam("name") String name, @RequestParam("email") String email,
			@RequestParam("phone") String phone, @RequestParam("address") String address,
			@RequestParam("region") String region, @RequestParam("payment") String payment,
			@RequestParam(value = "shipName", required = false) String shipName,
			@RequestParam(value = "shipPhone", required = false) String shipPhone,
			@RequestParam(value = "shipAddress", required = false) String shipAddress,
			@RequestParam(value = "memo", required = false) String memo,
			@RequestParam(value = "memoInput", required = false) String memoInput, HttpSession session,
			RedirectAttributes redirectAttributes) {

		log.info("=== 주문 제출 시작 ===");

		try {
			CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
			if (loginUser == null) {
				return "redirect:/login";
			}

			String customerId = loginUser.getCustomer_id();
			log.info("고객 ID: {}", customerId);

			// 장바구니 조회
			List<CartItemVO> cartItems = cartService.getCartItems(session);
			if (cartItems.isEmpty()) {
				redirectAttributes.addFlashAttribute("error", "장바구니가 비어있습니다.");
				return "redirect:/cart";
			}

			// 총 금액 계산
			int totalAmount = cartItems.stream().mapToInt(CartItemVO::getSubtotal).sum();

			// ⭐⭐⭐ 수령지 정보 검증 (필수)
			if (shipName == null || shipName.trim().isEmpty() || shipPhone == null || shipPhone.trim().isEmpty()
					|| shipAddress == null || shipAddress.trim().isEmpty()) {

				log.error("수령지 정보가 입력되지 않았습니다!");
				redirectAttributes.addFlashAttribute("error", "수령지 주소를 입력해주세요.");
				return "redirect:/checkout";
			}

			// ⭐ 메모 처리
			String finalMemo = "";
			if ("direct".equals(memo) && memoInput != null && !memoInput.trim().isEmpty()) {
				finalMemo = memoInput;
			} else if (memo != null && !"요청사항".equals(memo)) {
				finalMemo = memo;
			}

			log.info("=== DB에 저장될 정보 (수령지 정보만) ===");
			log.info("이름: {}", shipName);
			log.info("전화번호: {}", shipPhone);
			log.info("주소: {}", shipAddress);
			log.info("메모: {}", finalMemo);

			// 주문 VO 생성
			ordersVO order = new ordersVO();
			order.setCustomer_id(customerId);

			// ⭐⭐⭐ DB에는 수령지 정보만 저장
			order.setOrder_name(shipName);
			order.setOrder_phone(Long.parseLong(shipPhone.replaceAll("[^0-9]", "")));
			order.setOrder_addr(shipAddress);

			order.setPayment(payment);
			order.setTotal_amount(totalAmount);
			order.setOrder_status("결제완료");
			order.setMemo(finalMemo);

			// 별도 필드에도 저장 (있는 경우)
			order.setShipName(shipName);
			order.setShipPhone(shipPhone);
			order.setShipAddress(shipAddress);

			log.info("주문 정보: {}", order);

			// 주문 생성
			orderService.createOrder(order, cartItems);
			log.info("생성된 주문번호: {}", order.getOrder_no());

			// 장바구니 비우기
			for (CartItemVO item : cartItems) {
				cartService.removeFromCart(item.getItem_no(), session);
			}
			log.info("장바구니 비우기 완료");

			redirectAttributes.addFlashAttribute("message", "주문이 완료되었습니다.");
			redirectAttributes.addFlashAttribute("orderNo", order.getOrder_no());

			return "redirect:/ordercomplete";

		} catch (Exception e) {
			log.error("주문 처리 중 오류 발생", e);
			redirectAttributes.addFlashAttribute("error", "주문 처리 중 오류가 발생했습니다: " + e.getMessage());
			return "redirect:/checkout";
		}
	}

	@GetMapping("/ordercomplete")
	public String orderComplete(HttpSession session, Model model, @ModelAttribute("orderNo") Integer orderNo, // ⭐ Flash
																												// Attribute
																												// 받기
			@ModelAttribute("message") String message) {

		log.info("주문 완료 페이지");
		log.info("주문번호: {}", orderNo);
		log.info("메시지: {}", message);

		CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		// orderNo가 있으면 주문 상세 조회
		if (orderNo != null) {
			ordersVO order = orderService.getOrderByNo(orderNo);
			model.addAttribute("order", order);
		}

		return "ordercomplete";
	}
}