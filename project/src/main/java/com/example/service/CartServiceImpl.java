package com.example.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;

import jakarta.servlet.http.HttpSession;

import com.example.model.vo.CartItemVO;
import com.example.model.vo.CustomerVO;
import com.example.model.vo.ProductVO;


import com.example.model.CartRepository;

@Service
@Slf4j
public class CartServiceImpl implements CartService {

    private static final String SESSION_CART = "cart"; // Map<Integer, Integer> 형태 (상품번호 -> 수량)

    @Autowired
    private ProductService productService;

    @Autowired
    private CartRepository cartRepository;

    @Override
    public void addToCart(Integer itemNo, int qty, HttpSession session) throws Exception {
        if (itemNo == null || qty <= 0) return;

        // 로그인된 사용자(세션 속성명: loginUser 또는 user)가 있으면 DB에 반영
        Object userObj = session.getAttribute("loginUser");
        if (userObj == null) userObj = session.getAttribute("user");
        if (userObj != null) {
            String customerId = null;
            try {
                if (userObj instanceof CustomerVO) {
                    customerId = ((CustomerVO) userObj).getCustomer_id();
                } else {
                    customerId = String.valueOf(userObj);
                }
            } catch (Exception ex) {
                customerId = String.valueOf(userObj);
            }
            try {
                java.util.Map<String,Object> existing = cartRepository.findByCustomerAndItem(customerId, itemNo);
                if (existing != null) {
                    Object cartNoObj = existing.get("CART_NO"); if (cartNoObj == null) cartNoObj = existing.get("cart_no");
                    if (cartNoObj != null) {
                        Integer cartNo = (cartNoObj instanceof Number) ? ((Number)cartNoObj).intValue() : Integer.valueOf(cartNoObj.toString());
                        cartRepository.increaseCartCntByCartNo(java.util.Map.of("cartNo", cartNo, "qty", qty));
                        log.info("장바구니 DB 수량 증가 성공 cartNo={} itemNo={} qty={}", cartNo, itemNo, qty);
                    } else {
                        cartRepository.insertCartItem(java.util.Map.of("itemNo", itemNo, "cartCnt", qty, "customerId", customerId));
                        log.info("장바구니 DB 행 삽입 성공 user={} itemNo={} qty={}", customerId, itemNo, qty);
                    }
                } else {
                    cartRepository.insertCartItem(java.util.Map.of("itemNo", itemNo, "cartCnt", qty, "customerId", customerId));
                    log.info("장바구니 DB 행 삽입 성공 user={} itemNo={} qty={}", customerId, itemNo, qty);
                }
                log.info("장바구니 저장 완료 user={} itemNo={} qty={}", customerId, itemNo, qty);
            } catch (Exception e) {
                log.error("장바구니 DB 저장 실패", e);
            }
            // 로그인된 사용자는 세션을 업데이트하지 않고 DB를 신뢰
            return;
        }

        // 익명 사용자: 세션에 장바구니 보관
        Map<Integer, Integer> cart = getCartMap(session);
        cart.put(itemNo, cart.getOrDefault(itemNo, 0) + qty);
        session.setAttribute(SESSION_CART, cart);
        try {
            log.info("장바구니 세션 추가 session={} itemNo={} qty={} cart={}", session.getId(), itemNo, qty, cart);
        } catch (Exception e) {
            // 로그인 실패 시 무시
        }
    }

    // 장바구니에 저장된 모든 항목을 로그인한 사용자의 DB 장바구니로 병합
    // 병합 후 세션 장바구니를 초기화
    public void mergeSessionCartToDb(HttpSession session) throws Exception {
        Object userObj = session.getAttribute("loginUser");
        if (userObj == null) userObj = session.getAttribute("user");
        if (userObj == null) return;

        String customerId = null;
        try {
            if (userObj instanceof CustomerVO) {
                customerId = ((CustomerVO) userObj).getCustomer_id();
            } else {
                customerId = String.valueOf(userObj);
            }
        } catch (Exception ex) {
            customerId = String.valueOf(userObj);
        }

        Map<Integer, Integer> cart = getCartMap(session);
        if (cart == null || cart.isEmpty()) return;
        try {
            for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
                Integer itemNo = e.getKey();
                Integer qty = e.getValue();
                if (itemNo == null || qty == null || qty <= 0) continue;
                java.util.Map<String,Object> existing = cartRepository.findByCustomerAndItem(customerId, itemNo);
                if (existing != null) {
                    Object cartNoObj = existing.get("CART_NO"); if (cartNoObj == null) cartNoObj = existing.get("cart_no");
                    if (cartNoObj != null) {
                        Integer cartNo = (cartNoObj instanceof Number) ? ((Number)cartNoObj).intValue() : Integer.valueOf(cartNoObj.toString());
                        cartRepository.increaseCartCntByCartNo(java.util.Map.of("cartNo", cartNo, "qty", qty));
                        log.info("세션 병합: DB 장바구니 수량 증가 cartNo={} itemNo={} qty={}", cartNo, itemNo, qty);
                    } else {
                        cartRepository.insertCartItem(java.util.Map.of("itemNo", itemNo, "cartCnt", qty, "customerId", customerId));
                        log.info("세션 병합: DB 장바구니 행 삽입 user={} itemNo={} qty={}", customerId, itemNo, qty);
                    }
                } else {
                    cartRepository.insertCartItem(java.util.Map.of("itemNo", itemNo, "cartCnt", qty, "customerId", customerId));
                    log.info("세션 병합: DB 장바구니 행 삽입 user={} itemNo={} qty={}", customerId, itemNo, qty);
                }
            }
            // 세션 장바구니 초기화
            session.setAttribute(SESSION_CART, new HashMap<Integer, Integer>());
            log.info("세션 장바구니를 DB로 병합 완료 user={}", customerId);
        } catch (Exception ex) {
            log.error("세션 장바구니 DB 병합 실패", ex);
            throw ex;
        }
    }

    @Override
    public void removeFromCart(Integer itemNo, HttpSession session) throws Exception {
        if (itemNo == null) return;
        Object userObj = session.getAttribute("loginUser");
        if (userObj == null) userObj = session.getAttribute("user");
        if (userObj != null) {
            String customerId = null;
            try {
                if (userObj instanceof CustomerVO) {
                    customerId = ((CustomerVO) userObj).getCustomer_id();
                } else {
                    customerId = String.valueOf(userObj);
                }
            } catch (Exception ex) {
                customerId = String.valueOf(userObj);
            }
            try {
                int deleted = cartRepository.deleteCartByCustomerAndItem(java.util.Map.of("customerId", customerId, "itemNo", itemNo));
                log.info("장바구니 DB 삭제 시도 user={} itemNo={} 삭제건수={}", customerId, itemNo, deleted);
            } catch (Exception e) {
                log.error("장바구니 DB 삭제 실패 user=" + customerId + " itemNo=" + itemNo, e);
            }
        }
        Map<Integer, Integer> cart = getCartMap(session);
        log.info("세션 장바구니 삭제 전 상태: {}", cart);
        cart.remove(itemNo);
        log.info("세션 장바구니 삭제 후 상태: {}", cart);
        session.setAttribute(SESSION_CART, cart);
        try {
            log.info("세션 장바구니 변경 session={} itemNo={} cart={}", session.getId(), itemNo, cart);
        } catch (Exception e) {
            // 무시
        }
    }

    @Override
    public List<CartItemVO> getCartItems(HttpSession session) throws Exception {
        Object userObj = session.getAttribute("loginUser");
        if (userObj == null) userObj = session.getAttribute("user");
        List<CartItemVO> items = new ArrayList<>();
        if (userObj != null) {
            String customerId = null;
            try {
                if (userObj instanceof CustomerVO) {
                    customerId = ((CustomerVO) userObj).getCustomer_id();
                } else {
                    customerId = String.valueOf(userObj);
                }
            } catch (Exception ex) {
                customerId = String.valueOf(userObj);
            }
            try {
                List<java.util.Map<String,Object>> rows = cartRepository.findByCustomer(customerId);
                log.info("getCartItems - 고객 {}의 DB 행 수: {}", customerId, rows == null ? 0 : rows.size());
                for (java.util.Map<String,Object> r : rows) {
                    log.debug("getCartItems - DB 행: {}", r);
                    Object itemNoObj = r.get("ITEM_NO"); if (itemNoObj == null) itemNoObj = r.get("item_no");
                    Object cntObj = r.get("CART_CNT"); if (cntObj == null) cntObj = r.get("cart_cnt");
                    Integer itemNo = null;
                    Integer qty = null;
                    if (itemNoObj != null) {
                        itemNo = (itemNoObj instanceof Number) ? ((Number)itemNoObj).intValue() : Integer.valueOf(itemNoObj.toString());
                    }
                    if (cntObj != null) {
                        qty = (cntObj instanceof Number) ? ((Number)cntObj).intValue() : Integer.valueOf(cntObj.toString());
                    }
                    if (itemNo == null) {
                        log.warn("getCartItems - 행에 item_no 누락 {}, 건너뜀", r);
                        continue;
                    }
                    if (qty == null) {
                        qty = 0;
                    }
                    ProductVO p = productService.getProductById(itemNo);
                    log.debug("getCartItems - 상품 조회 id={} -> {}", itemNo, p == null ? "null" : "found");
                    if (p == null) {
                        try {
                            ProductVO pf = new ProductVO();
                            Object img = r.get("ITEM_IMG"); if (img == null) img = r.get("item_img");
                            Object name = r.get("ITEM_NAME"); if (name == null) name = r.get("item_name");
                            Object sales = r.get("SALES_P"); if (sales == null) sales = r.get("sales_p");
                            Object ino = r.get("ITEM_NO"); if (ino == null) ino = r.get("item_no");
                            if (ino != null) pf.setItem_no((ino instanceof Number) ? ((Number)ino).intValue() : Integer.valueOf(ino.toString()));
                            if (img != null) pf.setItem_img(img.toString());
                            if (name != null) pf.setItem_name(name.toString());
                            if (sales != null) pf.setSales_p((sales instanceof Number) ? ((Number)sales).intValue() : Integer.valueOf(sales.toString()));
                            p = pf;
                            log.debug("getCartItems - 대체 상품 객체 생성 itemNo {} -> {}", itemNo, pf);
                        } catch (Exception exx) {
                            // ignore fallback failure
                        }
                    }
                    if (p != null) items.add(new CartItemVO(p, qty));
                }
            } catch (Exception e) {
                log.error("장바구니 목록 DB 조회 실패", e);
            }
            return items;
        }
        Map<Integer, Integer> cart = getCartMap(session);
        for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
            Integer itemNo = e.getKey();
            Integer qty = e.getValue();
            ProductVO p = productService.getProductById(itemNo);
            if (p != null) {
                items.add(new CartItemVO(p, qty));
            }
        }
        return items;
    }

    @Override
    public int getCartTotal(HttpSession session) throws Exception {
        int total = 0;
        for (CartItemVO ci : getCartItems(session)) {
            total += ci.getSubtotal();
        }
        return total;
    }

    @SuppressWarnings("unchecked")
    private Map<Integer, Integer> getCartMap(HttpSession session) {
        Object o = session.getAttribute(SESSION_CART);
        if (o instanceof Map) {
            return (Map<Integer, Integer>) o;
        }
        Map<Integer, Integer> m = new HashMap<>();
        session.setAttribute(SESSION_CART, m);
        try {
            log.info("CartService.getCartMap - 세션에 새 장바구니 생성 session={}", session.getId());
        } catch (Exception e) {}
        return m;
    }
}