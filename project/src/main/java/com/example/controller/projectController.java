package com.example.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.productVO;
import com.example.service.ProductService;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Cookie;
import java.net.URLEncoder;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class projectController {
    @Autowired
    private ProductService productService;
    @Autowired
    private com.example.service.CartService cartService;
    @Autowired
    private com.example.model.CartRepository cartRepository;
	
	
    @GetMapping("cart")
    public String cart(Model m, HttpSession session) {
        try {
            // 사용자가 방금 로그인했거나 세션에 장바구니 항목이 있으면, 먼저 세션 장바구니를 DB의 장바구니와 병합
            try {
                cartService.mergeSessionCartToDb(session);
            } catch (Exception e) {
                log.warn("장바구니: 세션 장바구니를 DB와 병합하지 못했습니다", e);
            }
           
            try {
                Object u = session.getAttribute("user");
                log.info("cart() 호출 - sessionId={}, user={}", session.getId(), u);
            } catch (Exception ex) {
                log.warn("cart() 디버그 로그 기록에 실패했습니다", ex);
            }
            java.util.List<com.example.domain.CartItemVO> items = cartService.getCartItems(session);
            int totalPrice = cartService.getCartTotal(session);
            int cartCount = 0;
            for (com.example.domain.CartItemVO ci : items) cartCount += ci.getQty();
            m.addAttribute("cartItems", items);
            m.addAttribute("cartTotal", totalPrice);
            m.addAttribute("cart_cnt", cartCount);
        } catch (Exception e) {
            m.addAttribute("cartItems", new ArrayList<>());
            m.addAttribute("cartTotal", 0);
            m.addAttribute("cart_cnt", 0);
        }
        return "cart";
    }

    @PostMapping("/cart/add")
    @ResponseBody
    public Map<String, Object> addToCart(@RequestParam("item_no") Integer item_no,
                                         @RequestParam(value = "qty", required = false) Integer qty,
                                         HttpSession session) {
        log.info("/cart/add called: item_no={}, qty={}", item_no, qty);
        Map<String, Object> resp = new HashMap<>();
        if (item_no == null) {
            resp.put("success", false);
            resp.put("message", "item_no required");
            return resp;
        }
        int addQty = (qty == null || qty <= 0) ? 1 : qty;
        try {
            cartService.addToCart(item_no, addQty, session);
            int totalCount = cartService.getCartItems(session).stream().mapToInt(com.example.domain.CartItemVO::getQty).sum();
            resp.put("success", true);
            resp.put("cartCount", totalCount);
            log.info("Session ID after add: {}", session.getId());
        } catch (Exception ex) {
            log.warn("Failed to add to cart", ex);
            resp.put("success", false);
            resp.put("message", "추가 실패");
        }
        return resp;
    }

    @PostMapping("/cart/remove")
    public String removeFromCart(Integer item_no, HttpSession session) {
        try {
            if (item_no != null) {
                cartService.removeFromCart(item_no, session);
            }
        } catch (Exception e) {
            log.warn("Failed to remove from cart", e);
        }
        return "redirect:/cart";
    }

    @PostMapping("/cart/addForm")
    public String addToCartForm(@RequestParam("item_no") Integer item_no,
                                @RequestParam(value = "qty", required = false) Integer qty,
                                HttpSession session) {
        if (item_no == null) return "redirect:/selectall";
        int addQty = (qty == null || qty <= 0) ? 1 : qty;
        try {
            cartService.addToCart(item_no, addQty, session);
        } catch (Exception e) {
            log.warn("Failed to add to cart (form)", e);
        }
        return "redirect:/cart";
    }

    @GetMapping("/cart/count")
    @ResponseBody
    public Map<String, Object> cartCount(HttpSession session) {
        Map<String, Object> resp = new HashMap<>();
        int totalCount = 0;
        try {
            totalCount = cartService.getCartItems(session).stream().mapToInt(com.example.domain.CartItemVO::getQty).sum();
        } catch (Exception e) {
            log.warn("Failed to compute cart count", e);
        }
        resp.put("cartCount", totalCount);
        return resp;
    }

// ----------------- ****** 추후 삭제 ******  개발용 디버그 엔드포인트 시작 -----------------------
// TODO[DEV-CLEANUP]: 이 블록은 개발용 디버그 엔드포인트--
// - `/cart/db`, `/cart/items-json`, `/whoami` 등은 진단용
// - 실제 배포 전에는 삭제하거나 `@Profile("dev")`로 감싸서 비활성화
// ----------------- ****** 추후 삭제 ******  개발용 디버그 엔드포인트 시작 -----------------------

    // 개발용: 현재 로그인한 사용자의 DB 장바구니 원본(row list)을 반환
    @GetMapping("/cart/db")
    @ResponseBody
    public Map<String,Object> cartDb(HttpSession session) {
        Map<String,Object> resp = new HashMap<>();
        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            resp.put("success", false);
            resp.put("message", "not logged in");
            resp.put("rows", new ArrayList<>());
            return resp;
        }
        String customerId = String.valueOf(userObj);
        try {
            java.util.List<java.util.Map<String,Object>> rows = cartRepository.findByCustomer(customerId);
            resp.put("success", true);
            resp.put("rows", rows);
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("message", "db error");
            resp.put("error", e.getMessage());
        }
        return resp;
    }

//  -----------------------------------------------------------------------------
    // 개발용: 현재 세션에 보여질 cartItems 리스트를 JSON으로 반환합니다 (debug)
    @GetMapping("/cart/items-json")
    @ResponseBody
    public Map<String,Object> cartItemsJson(HttpSession session) {
        Map<String,Object> resp = new HashMap<>();
        try {
            java.util.List<com.example.domain.CartItemVO> items = cartService.getCartItems(session);
            java.util.List<Map<String,Object>> out = new ArrayList<>();
            for (com.example.domain.CartItemVO ci : items) {
                Map<String,Object> m = new HashMap<>();
                if (ci.getProduct() != null) {
                    m.put("item_no", ci.getProduct().getItem_no());
                    m.put("item_name", ci.getProduct().getItem_name());
                    m.put("item_img", ci.getProduct().getItem_img());
                    m.put("sales_p", ci.getProduct().getSales_p());
                }
                m.put("qty", ci.getQty());
                m.put("subtotal", ci.getSubtotal());
                out.add(m);
            }
            // 디버깅을 위해 원본 DB 행(raw DB rows)과 각 행별로 연관된 상품 조회(per-row product lookup)도 포함
            Object userObj = session.getAttribute("user");
            java.util.List<Map<String,Object>> rows = new ArrayList<>();
            if (userObj != null) {
                try {
                    String customerId = String.valueOf(userObj);
                    rows = cartRepository.findByCustomer(customerId);
                } catch (Exception ex) {
                    // 무시
                }
            }
            java.util.List<Map<String,Object>> lookup = new ArrayList<>();
            for (Map<String,Object> r : rows) {
                Map<String,Object> li = new HashMap<>();
                li.put("row", r);
                Object ino = r.get("ITEM_NO"); if (ino == null) ino = r.get("item_no");
                Integer itemNo = null;
                try { if (ino != null) itemNo = (ino instanceof Number) ? ((Number)ino).intValue() : Integer.valueOf(ino.toString()); } catch (Exception e) {}
                if (itemNo != null) {
                    com.example.domain.productVO p = productService.getProductById(itemNo);
                    li.put("productLookup", p == null ? null : Map.of(
                        "item_no", p.getItem_no(),
                        "item_name", p.getItem_name(),
                        "item_img", p.getItem_img(),
                        "sales_p", p.getSales_p()
                    ));
                } else {
                    li.put("productLookup", null);
                }
                lookup.add(li);
            }
            resp.put("success", true);
            resp.put("items", out);
            resp.put("dbRows", rows);
            resp.put("rowLookups", lookup);
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("error", e.getMessage());
        }
        return resp;
    }

    // 디버그 엔드포인트: 세션 ID와 사용자 속성(user attribute)을 반환함(세션 손실 진단용)
    @GetMapping("/whoami")
    @ResponseBody
    public Map<String,Object> whoami(HttpSession session) {
        Map<String,Object> resp = new HashMap<>();
        resp.put("sessionId", session == null ? null : session.getId());
        Object u = null;
        try {
            if (session != null) u = session.getAttribute("user");
        } catch (Exception e) { }
        resp.put("user", u);
        return resp;
    }
//  -----------------------------------------------------------------------------
// ----------------- 추후 삭제  개발용 디버그 엔드포인트 끝 -----------------------
// ----------------- 추후 삭제  개발용 디버그 엔드포인트 끝 -----------------------

    @PostMapping("/cart/update")
    @ResponseBody
    public Map<String, Object> updateCartQuantity(@RequestParam("item_no") Integer item_no,
                                                  @RequestParam("qty") Integer qty,
                                                  HttpSession session) {
        Map<String, Object> resp = new HashMap<>();
        if (item_no == null || qty == null || qty < 0) {
            resp.put("success", false);
            resp.put("message", "invalid parameters");
            return resp;
        }
        try {
            if (qty == 0) {
                cartService.removeFromCart(item_no, session);
            } else {
                // 절대 수량 설정: 기존 항목을 삭제한 뒤 원하는 수량을 추가
                // 현재 CartService는 addToCart(증가)와 removeFromCart를 제공
                // 절대 수량을 설정하려면 기존 항목을 제거한 후 요청한 수량을 추가
                cartService.removeFromCart(item_no, session);
                if (qty > 0) cartService.addToCart(item_no, qty, session);
            }
            java.util.List<com.example.domain.CartItemVO> items = cartService.getCartItems(session);
            int totalCount = items.stream().mapToInt(com.example.domain.CartItemVO::getQty).sum();
            int cartTotal = items.stream().mapToInt(ci -> ci.getSubtotal()).sum();
            // 변경된 항목의 소계를 계산
            int itemSubtotal = 0;
            try {
                productVO p = productService.getProductById(item_no);
                if (p != null && p.getSales_p() != null) {
                    itemSubtotal = p.getSales_p() * qty;
                }
            } catch (Exception ex) { }
            resp.put("success", true);
            resp.put("cartCount", totalCount);
            resp.put("cartTotal", cartTotal);
            resp.put("itemSubtotal", itemSubtotal);
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("message", "failed to update");
        }
        return resp;
    }

    // 디버그 엔드포인트 삭제됨.
	
	@GetMapping("shop")
	public String shop() {
		return "shop";
		
	}
	
	@GetMapping("checkout")
	public String checkout() {
		return "checkout";
	}
	
    // 전체 상품 조회 페이지, 검색, 정렬
    @GetMapping("selectall")
    public String selectall(Model m,
                            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                            @RequestParam(value = "size", required = false, defaultValue = "9") int size,
                            @RequestParam(value = "q", required = false) String q,
                            @RequestParam(value = "sort", required = false) String sort) {
        try {
            int safePage = Math.max(page, 1);  //
            int safeSize = Math.max(size, 1);
            int offset = (safePage - 1) * safeSize;

            Map<String, Object> params = new HashMap<>();
            params.put("offset", offset);
            params.put("size", safeSize);
            params.put("q", q);
            params.put("sort", sort);

            List<productVO> products = productService.getProducts(params);
            int total = productService.getProductsTotal(params);
            int totalPages = (int) Math.ceil(total / (double) safeSize);

            m.addAttribute("products", products);
            m.addAttribute("page", safePage);
            m.addAttribute("size", safeSize);
            m.addAttribute("total", total);
            m.addAttribute("totalPages", totalPages);
            m.addAttribute("q", q);
            m.addAttribute("sort", sort);
        } catch (Exception e) {
            log.warn("Failed to load products with pagination", e);
            m.addAttribute("products", new ArrayList<>());
            m.addAttribute("page", 1);
            m.addAttribute("size", 9);
            m.addAttribute("total", 0);
            m.addAttribute("totalPages", 0);
        }
        return "selectall";
    }
	
	@GetMapping("fish2Detail")
	public String fish2Detail() {
		return "fish2Detail";
	}
	
    @GetMapping("detail")
    public String detail(@RequestParam(value = "item_no", required = false) Integer item_no, Model m) throws Exception {
        if (item_no != null) {
            productVO p = productService.getProductById(item_no);
            m.addAttribute("product", p);
        }
        return "detail";
    }
	
	@GetMapping("register")
	public String register() {
		return "register";
	}

/*
	@GetMapping("login")
	public String login() {
		return "login";
	}
*/

//  --------------------------------------------------------------------	
// ------------임시 로그인 활성 **추후 삭제*** ----------------------------------------
// TODO[DEV-CLEANUP]: 임시(개발용) 로그인 엔드포인트입니다.
// - `doLogin`, `doLogout`은 개발 편의상 세션을 직접 설정합니다.
// - 실제 인증이 구현되면 이 핸들러들을 제거하거나 `@Profile("dev")`로 제한하세요.
//  --------------------------------------------------------------------

    @GetMapping("/login")
    public String loginPage() {
        // 명시적으로 로그인 JSP를 반환하여 Spring Security의 기본 로그인 페이지 대신 사용
        return "login";
    }

    @GetMapping("/doLogin")
    public String doLoginGet() {
        // POST 전용 엔드포인트에 직접 GET으로 접근하는 경우를 방지하기 위해
        // 로그인 페이지로 리다이렉트합니다.
        return "redirect:/login";
    }

    @PostMapping("/doLogin")
public String doLogin(@RequestParam String customer_id,
                      @RequestParam String pwd,
                      @RequestParam(required=false) String remember,
                      HttpServletRequest req,
                      HttpServletResponse resp) {
    // 개발용: 인증 로직을 우회합니다. 운영 전 반드시 원상복구하세요.
    log.warn("doLogin - DEV MODE: skipping authentication for customer_id={}", customer_id);
    boolean ok = true; // 임시: 항상 성공 처리
    HttpSession session = req.getSession(true);
    session.setAttribute("user", customer_id);
    // Merge any anonymous session cart into DB now that user is set
    try {
        cartService.mergeSessionCartToDb(session);
    } catch (Exception e) {
        log.warn("doLogin: failed to merge session cart into DB", e);
    }

    // 2) 임시: remember 선택 시 쿠키 설정
    if ("1".equals(remember)) {
        Cookie c = new Cookie("REMEMBER", URLEncoder.encode(customer_id, StandardCharsets.UTF_8));
        c.setPath("/");
        c.setHttpOnly(true); // 서버에서만 읽음
        c.setMaxAge(30 * 24 * 3600); // 30일
        // c.setSecure(true); // HTTPS 사용 시 활성화
        resp.addCookie(c);
    }
    return "redirect:/";
}
// 간단한 로그아웃 핸들러: 세션 무효화 및 REMEMBER 쿠키 삭제
    @GetMapping("/doLogout")
    public String doLogout(HttpServletRequest req, HttpServletResponse resp) {
        try {
            HttpSession s = req.getSession(false);
            if (s != null) s.invalidate();
            Cookie c = new Cookie("REMEMBER", "");
            c.setPath("/");
            c.setMaxAge(0);
            resp.addCookie(c);
        } catch (Exception e) {
            log.warn("doLogout failed", e);
        }
        return "redirect:/";
    }

    // ----------------------------------------------------
// -------임시 로그인/로그아웃  활성 **추후 삭제 끝 ***--------------------------------------------

    
	@GetMapping("mlist")
	public String mlist() {
		return "mlist";
	}
	
	@GetMapping("selectBanchan")
    public String selectBanchan(Model m,
                                @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                                @RequestParam(value = "size", required = false, defaultValue = "9") int size,
                                @RequestParam(value = "q", required = false) String q,
                                @RequestParam(value = "sort", required = false) String sort,
                                @RequestParam(value = "cate", required = false) Integer cate) {
        // 기본 카테고리 매핑: 반찬 -> 1
        Integer cateNo = (cate != null) ? cate : 1;
        loadCategoryProducts(m, page, size, q, sort, cateNo);
        return "selectBanchan";
    }
	
	@GetMapping("selectSoup")
    public String selectSoup(Model m,
                             @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                             @RequestParam(value = "size", required = false, defaultValue = "9") int size,
                             @RequestParam(value = "q", required = false) String q,
                             @RequestParam(value = "sort", required = false) String sort,
                             @RequestParam(value = "cate", required = false) Integer cate) {
        Integer cateNo = (cate != null) ? cate : 2; // 국/찌개 기본 2
        loadCategoryProducts(m, page, size, q, sort, cateNo);
        return "selectSoup";
    }
    
	@GetMapping("selectGui")
    public String selectGui(Model m,
                            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                            @RequestParam(value = "size", required = false, defaultValue = "9") int size,
                            @RequestParam(value = "q", required = false) String q,
                            @RequestParam(value = "sort", required = false) String sort,
                            @RequestParam(value = "cate", required = false) Integer cate) {
        Integer cateNo = (cate != null) ? cate : 3; // 구이 기본 3
        loadCategoryProducts(m, page, size, q, sort, cateNo);
        return "selectGui";
    }

	@GetMapping("selectBunsik")
    public String selectBunsik(Model m,
                               @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                               @RequestParam(value = "size", required = false, defaultValue = "9") int size,
                               @RequestParam(value = "q", required = false) String q,
                               @RequestParam(value = "sort", required = false) String sort,
                               @RequestParam(value = "cate", required = false) Integer cate) {
        Integer cateNo = (cate != null) ? cate : 4; // 분식 기본 4
        loadCategoryProducts(m, page, size, q, sort, cateNo);
        return "selectBunsik";
    }
	
	@GetMapping("selectDiet")
    public String selectDiet(Model m,
                             @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                             @RequestParam(value = "size", required = false, defaultValue = "9") int size,
                             @RequestParam(value = "q", required = false) String q,
                             @RequestParam(value = "sort", required = false) String sort,
                             @RequestParam(value = "cate", required = false) Integer cate) {
        Integer cateNo = (cate != null) ? cate : 5; // 식단관리 기본 5
        loadCategoryProducts(m, page, size, q, sort, cateNo);
        return "selectDiet";
    }	
	
	@GetMapping("selectdrink")
	public String selectdrink(Model m,
						      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
						      @RequestParam(value = "size", required = false, defaultValue = "9") int size,
						      @RequestParam(value = "q", required = false) String q,
						      @RequestParam(value = "sort", required = false) String sort,
						      @RequestParam(value = "sort", required = false) Integer cate) {
		Integer cateNo = (cate != null) ? cate : 6; // 음료 6
		loadCategoryProducts(m, page, size, q, sort, cateNo);
		return "selectdrink";
	}	

    // 공통 로직: 카테고리별 상품 로드
    private void loadCategoryProducts(Model m, int page, int size, String q, String sort, Integer cateNo) {
        try {
            int safePage = Math.max(page, 1);
            int safeSize = Math.max(size, 1);
            int offset = (safePage - 1) * safeSize;

            Map<String, Object> params = new HashMap<>();
            params.put("offset", offset);
            params.put("size", safeSize);
            params.put("q", q);
            params.put("sort", sort);
            params.put("cate_no", cateNo);

            List<productVO> products = productService.getProducts(params);
            int total = productService.getProductsTotal(params);
            int totalPages = (int) Math.ceil(total / (double) safeSize);

            m.addAttribute("products", products);
            m.addAttribute("page", safePage);
            m.addAttribute("size", safeSize);
            m.addAttribute("total", total);
            m.addAttribute("totalPages", totalPages);
            m.addAttribute("q", q);
            m.addAttribute("sort", sort);
            m.addAttribute("cate", cateNo);
        } catch (Exception e) {
            log.warn("Failed to load category products", e);
            m.addAttribute("products", new ArrayList<>());
            m.addAttribute("page", 1);
            m.addAttribute("size", 9);
            m.addAttribute("total", 0);
            m.addAttribute("totalPages", 0);
            m.addAttribute("cate", cateNo);
        }
    }


	@GetMapping("board")
	public String board() {
		return "board";
	}
	
	@GetMapping("dashboard")
	public String dashboard() {
		return "dashboard";
	}
	
	@GetMapping("stock")
	public String stock() {
		return "stock";
	}
	
	@GetMapping("item")
	public String item() {
		return "item";
	}
	
	@GetMapping("order")
	public String order() {
		return "order";
	}

// 	통계 페이지(연도별*월별 매출 / 지출)	
	@GetMapping("stats")
	public String stats(Model model) throws Exception {
        // Sample monthly data (year, month, sales, expenses, profit)
        List<Map<String, Object>> monthly = new ArrayList<>();
        // Example: recent 12 months (mocked)
        int[][] sample = {
            {2025, 11, 2630, 1870},
            {2025, 10, 2350, 1530},
            {2025, 9, 2080, 1350},
            {2025, 8, 1660, 1060},
            {2025, 7, 1630, 1240},
            {2025, 6, 1750, 1270},
            {2025, 5, 1820, 1210}
        };
        for (int[] r : sample) {
            Map<String, Object> m = new HashMap<>();
            int year = r[0];
            int month = r[1];
            int sales = r[2];
            int expenses = r[3];
            int profit = sales - expenses;
            double profitRate = sales != 0 ? Math.round((double)profit * 1000.0 / sales) / 10.0 : 0.0;
            m.put("year", year);
            m.put("month", month);
            m.put("sales", sales);
            m.put("expenses", expenses);
            m.put("profit", profit);
            m.put("profitRate", profitRate);
            m.put("note", "샘플 데이터");
            monthly.add(m);
        }

        // Sample daily metrics (recent 7 days)
        List<Map<String, Object>> dailyMetrics = new ArrayList<>();
        String[] days = {"2024-11-11","2024-11-10","2024-11-09","2024-11-08","2024-11-07","2024-11-06","2024-11-05"};
        int[] dayVisitors = {1200, 1150, 980, 1020, 1300, 1250, 1400};
        int[] dayOrders =   {120,  110,  95,  100,  135,  128,  150};
        for (int i = 0; i < days.length; i++) {
            Map<String, Object> d = new HashMap<>();
            d.put("date", days[i]);
            d.put("visitors", dayVisitors[i]);
            d.put("orders", dayOrders[i]);
            d.put("note", "샘플");
            dailyMetrics.add(d);
        }

        // Sample monthly visitors/orders (recent 7 months)
        List<Map<String, Object>> monthlyVisitors = new ArrayList<>();
        int[][] mv = {
            {2024,11,  37200, 2100},
            {2024,10,  36000, 1980},
            {2024,9,   34500, 1850},
            {2024,8,   31000, 1720},
            {2024,7,   29800, 1680},
            {2024,6,   30500, 1740},
            {2024,5,   32000, 1820}
        };
        for (int[] r : mv) {
            Map<String,Object> mm = new HashMap<>();
            int year = r[0];
            int month = r[1];
            int visitors = r[2];
            int orders = r[3];
            double avgPerDay = Math.round((double)orders / 30.0 * 10.0) / 10.0; // rough avg
            mm.put("year", year);
            mm.put("month", month);
            mm.put("visitors", visitors);
            mm.put("orders", orders);
            mm.put("avgPerDay", avgPerDay);
            mm.put("note", "샘플");
            monthlyVisitors.add(mm);
        }

        // Sort lists newest-first so view shows latest at top by default
        monthly.sort((a,b) -> {
            int ay = (int)a.get("year"); int am = (int)a.get("month");
            int by = (int)b.get("year"); int bm = (int)b.get("month");
            if (ay != by) return Integer.compare(by, ay); // year desc
            return Integer.compare(bm, am); // month desc
        });

        monthlyVisitors.sort((a,b) -> {
            int ay = (int)a.get("year"); int am = (int)a.get("month");
            int by = (int)b.get("year"); int bm = (int)b.get("month");
            if (ay != by) return Integer.compare(by, ay);
            return Integer.compare(bm, am);
        });

        dailyMetrics.sort((a,b) -> {
            // date strings in format yyyy-MM-dd -> lexicographic desc works
            String da = (String)a.get("date");
            String db = (String)b.get("date");
            return db.compareTo(da); // newest first
        });

        ObjectMapper mapper = new ObjectMapper();
        model.addAttribute("monthlyData", monthly);
        model.addAttribute("monthlyDataJson", mapper.writeValueAsString(monthly));
        model.addAttribute("dailyMetrics", dailyMetrics);
        model.addAttribute("monthlyVisitors", monthlyVisitors);

        return "stats";
    }
}
