package com.example.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;

import jakarta.servlet.http.HttpSession;

import com.example.domain.CartItemVO;
import com.example.domain.productVO;
import com.example.service.CartService;
import com.example.service.ProductService;
import com.example.model.CartRepository;
import java.math.BigDecimal;

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
        Object userObj = session.getAttribute("user");
        if (userObj != null) {
            String customerId = String.valueOf(userObj);
            try {
                // 행 존재 여부를 확인 후, 있으면 수량 증가, 없으면 삽입
                java.util.Map<String,Object> existing = cartRepository.findByCustomerAndItem(customerId, itemNo);
                if (existing != null) {
                    // MyBatis/드라이버가 컬럼 키(맵의 키)를 대문자나 소문자로 반환. 둘 다 확인
                    Object cartNoObj = existing.get("CART_NO");
                    if (cartNoObj == null) cartNoObj = existing.get("cart_no");
                    if (cartNoObj != null) {
                        Integer cartNo = (cartNoObj instanceof Number) ? ((Number)cartNoObj).intValue() : Integer.valueOf(cartNoObj.toString());
                        cartRepository.increaseCartCntByCartNo(java.util.Map.of("cartNo", cartNo, "qty", qty));
                        log.info("CartService.addToCart - db에 장바구니 저장 성공 cartNo={} itemNo={} by {}", cartNo, itemNo, qty);
                    } else {
                        cartRepository.insertCartItem(java.util.Map.of("itemNo", itemNo, "cartCnt", qty, "customerId", customerId));
                        log.info("CartService.addToCart - db에 행 삽입 성공 user={} itemNo={} qty={}", customerId, itemNo, qty);
                    }
                } else {
                    cartRepository.insertCartItem(java.util.Map.of("itemNo", itemNo, "cartCnt", qty, "customerId", customerId));
                    log.info("CartService.addToCart - db에 행 삽입 성공 user={} itemNo={} qty={}", customerId, itemNo, qty);
                }
                log.info("CartService.addToCart - 저장완료 user={} itemNo={} qty={}", customerId, itemNo, qty);
            } catch (Exception e) {
                log.error("CartService.addToCart - DB 저장실패", e);
            }
    // 로그인된(인증된) 사용자에 대해 세션의 장바구니를 업데이트하지 말고 DB 상태만 사용(db값만 단일 수행)
    // 로그인전 사용자는 세션의 장바구니 업데이트 (*로그인 전후 중복 업데이트 방지)

            return;
        }
// 로그인되지 않은(익명) 사용자는 장바구니 데이터를 DB에 저장하지 않고 
// 세션(서버/클라이언트 세션 스토리지)에 임시 보관
        Map<Integer, Integer> cart = getCartMap(session);
        cart.put(itemNo, cart.getOrDefault(itemNo, 0) + qty);
        session.setAttribute(SESSION_CART, cart);
        try {
            log.info("CartService.addToCart - session={} itemNo={} qty={} cart={}", session.getId(), itemNo, qty, cart);
        } catch (Exception e) {
            // 로그인 실패 시 무시
        }
    }

    // 장바구니에 저장된 모든 항목을 로그인한 사용자의 DB 장바구니로 병합
    // 병합 후 남아있는 장바구니 데이터를 삭제(또는 초기화)해서 이후에는 DB의 내용만을 참조·갱신
    public void mergeSessionCartToDb(HttpSession session) throws Exception {
        Object userObj = session.getAttribute("user");
        if (userObj == null) return;
        String customerId = String.valueOf(userObj);
        Map<Integer, Integer> cart = getCartMap(session);
        if (cart == null || cart.isEmpty()) return;
        try {
            for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
                Integer itemNo = e.getKey();
                Integer qty = e.getValue();
                if (itemNo == null || qty == null || qty <= 0) continue;
                java.util.Map<String,Object> existing = cartRepository.findByCustomerAndItem(customerId, itemNo);
                if (existing != null) {
                    Object cartNoObj = existing.get("CART_NO");
                    if (cartNoObj == null) cartNoObj = existing.get("cart_no");
                    if (cartNoObj != null) {
                        Integer cartNo = (cartNoObj instanceof Number) ? ((Number)cartNoObj).intValue() : Integer.valueOf(cartNoObj.toString());
                        cartRepository.increaseCartCntByCartNo(java.util.Map.of("cartNo", cartNo, "qty", qty));
                        log.info("mergeSessionCartToDb - increased DB cart_cnt for cartNo={} itemNo={} by {}", cartNo, itemNo, qty);
                    } else {
                        cartRepository.insertCartItem(java.util.Map.of("itemNo", itemNo, "cartCnt", qty, "customerId", customerId));
                        log.info("mergeSessionCartToDb - inserted DB cart row for user={} itemNo={} qty={}", customerId, itemNo, qty);
                    }
                } else {
                    cartRepository.insertCartItem(java.util.Map.of("itemNo", itemNo, "cartCnt", qty, "customerId", customerId));
                    log.info("mergeSessionCartToDb - inserted DB cart row for user={} itemNo={} qty={}", customerId, itemNo, qty);
                }
            }
            // 세션 장바구니 초기화
            session.setAttribute(SESSION_CART, new HashMap<Integer, Integer>());
            log.info("mergeSessionCartToDb - merged session cart into DB for user={}", customerId);
        } catch (Exception ex) {
            log.error("mergeSessionCartToDb - failed to merge session cart", ex);
            throw ex;
        }
    }
    @Override
    public void removeFromCart(Integer itemNo, HttpSession session) throws Exception {
        if (itemNo == null) return;
        Object userObj = session.getAttribute("user");
        if (userObj != null) {
            String customerId = String.valueOf(userObj);
            try {
                cartRepository.deleteCartByCustomerAndItem(java.util.Map.of("customerId", customerId, "itemNo", itemNo));
                log.info("CartService.removeFromCart - deleted DB row for user={} itemNo={}", customerId, itemNo);
            } catch (Exception e) {
                log.error("CartService.removeFromCart - DB delete failed", e);
            }
        }
        Map<Integer, Integer> cart = getCartMap(session);
        cart.remove(itemNo);
        session.setAttribute(SESSION_CART, cart);
        try {
            log.info("CartService.removeFromCart - session={} itemNo={} cart={}", session.getId(), itemNo, cart);
        } catch (Exception e) {
            // 무시
        }
    }

    @Override
    public List<CartItemVO> getCartItems(HttpSession session) throws Exception {
        Object userObj = session.getAttribute("user");
        List<CartItemVO> items = new ArrayList<>();
        if (userObj != null) {
            String customerId = String.valueOf(userObj);
            try {
                List<java.util.Map<String,Object>> rows = cartRepository.findByCustomer(customerId);
                log.info("getCartItems - DB rows for customer {}: count={}", customerId, rows == null ? 0 : rows.size());
                for (java.util.Map<String,Object> r : rows) {
                    log.debug("getCartItems - row: {}", r);
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
                        log.warn("getCartItems - missing item_no in row {}, skipping", r);
                        continue;
                    }
                    if (qty == null) {
                        qty = 0;
                    }
                    productVO p = productService.getProductById(itemNo);
                    log.debug("getCartItems - lookup product id={} -> {}", itemNo, p == null ? "null" : "found");
                    if (p == null) {
                        // Fallback: mapper joined product fields; try to construct productVO from row data
                        try {
                            productVO pf = new productVO();
                            Object img = r.get("ITEM_IMG"); if (img == null) img = r.get("item_img");
                            Object name = r.get("ITEM_NAME"); if (name == null) name = r.get("item_name");
                            Object sales = r.get("SALES_P"); if (sales == null) sales = r.get("sales_p");
                            Object ino = r.get("ITEM_NO"); if (ino == null) ino = r.get("item_no");
                            if (ino != null) pf.setItem_no((ino instanceof Number) ? ((Number)ino).intValue() : Integer.valueOf(ino.toString()));
                            if (img != null) pf.setItem_img(img.toString());
                            if (name != null) pf.setItem_name(name.toString());
                            if (sales != null) pf.setSales_p((sales instanceof Number) ? ((Number)sales).intValue() : Integer.valueOf(sales.toString()));
                            p = pf;
                            log.debug("getCartItems - built fallback product for itemNo {} -> {}", itemNo, pf);
                        } catch (Exception exx) {
                            // ignore fallback failure
                        }
                    }
                    if (p != null) items.add(new CartItemVO(p, qty));
                }
            } catch (Exception e) {
                log.error("CartService.getCartItems - DB read failed", e);
            }
            return items;
        }
        Map<Integer, Integer> cart = getCartMap(session);
        for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
            Integer itemNo = e.getKey();
            Integer qty = e.getValue();
            productVO p = productService.getProductById(itemNo);
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
            log.info("CartService.getCartMap - created new cart for session={}", session.getId());
        } catch (Exception e) {}
        return m;
    }
}
