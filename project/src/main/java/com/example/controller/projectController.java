package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.ui.Model;

import lombok.extern.slf4j.Slf4j;

import java.util.*;
import com.fasterxml.jackson.databind.ObjectMapper;

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
	
	@GetMapping("shop")
	public String shop() {
		return "shop";
		
	}
	
	@GetMapping("checkout")
	public String checkout() {
		return "checkout";
	}
	
	@GetMapping("selectall")
	public String selectall() {
		return "selectall";
	}
	
	@GetMapping("detail")
	public String detail() {
		return "detail";
	}
	
	@GetMapping("register")
	public String register() {
		return "register";
	}


	@GetMapping("login")
	public String login() {
		return "login";
	}
	
	@GetMapping("mlist")
	public String mlist() {
		return "mlist";
	}
	
	@GetMapping("selectBanchan")
	public String selectBanchan() {
		return "selectBanchan";
	}
	
	@GetMapping("selectBunsik")
	public String selectBunsik() {
		return "selectBunsik";
	}
	
	@GetMapping("selectDiet")
	public String selectDiet() {
		return "selectDiet";
	}
	
	@GetMapping("selectGui")
	public String selectGui() {
		return "selectGui";
	}
	
	@GetMapping("selectdrink")
	public String selectdrink() {
		return "selectdrink";
	}
	
	@GetMapping("selectSoup")
	public String selectSoup() {
		return "selectSoup";
	}

	@GetMapping("selectRecipe")
	public String selectRecipe() {
		return "selectRecipe";
	}

	@GetMapping("board")
	public String board() {
		return "board";
	}
	
	@GetMapping("dashboard")
	public String dashboard() {
		return "dashboard";
	}
	
	//@GetMapping("stock")
	//public String stock() {
	//	return "stock";
	//}

	//@GetMapping("item")
	//public String item() { 
	//	return "item"; 
	//}
	 
	@GetMapping("order")
	public String order() {
		return "order";
	}
	
	@GetMapping("/mypage")
	public String mypage() {
		return "mypage";
	}
	
	@GetMapping("/mycs")
	public String mycs() {
		return "mycs";
	}
	
	@GetMapping("/myqna")
	public String myqna() {
		return "myqna";
	}
	
	@GetMapping("/mydelivery")
	public String mydelivery() {
		return "mydelivery";
	}
	
	
	
	

	@GetMapping("event1")
	public String event1() {
		return "event1";
	}
	
	@GetMapping("event2")
	public String event2() {
		return "event2";
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

