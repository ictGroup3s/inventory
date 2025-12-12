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

import com.example.model.vo.ProductVO;
import com.example.model.vo.CartItemVO;
import com.example.model.CartRepository;
import com.example.service.CartService;
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

	@GetMapping("/")
	public String home() {
		return "header"; // header.jsp로 이동
	}
	
	@GetMapping("shop")
	public String shop() {
		return "shop";
	}
	
	@GetMapping("kakaolog")
	public String kakaolog() {
		return "kakaolog";
	}
	
//	@GetMapping("checkout")
//	public String checkout() {
//		return "checkout";
//	}
	
	@GetMapping("header")
	public String header() {
		return "header";
	}
	
	@GetMapping("delete")
	public String delete() {
		return "delete";
	}
	
	@GetMapping("update")
	public String updateUser() {
		return "update";
	}
	
	@GetMapping("goodbye")
	public String goodbye() {
		return "goodbye";
	}
	
	@GetMapping("login")
	public String login() {
		return "login";
	}
	
	 @GetMapping("register")
	public String register() {
		return "register";
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

            List<ProductVO> products = productService.getProducts(params);
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
    
    @GetMapping("detail")
    public String detail(@RequestParam(value = "item_no", required = false) Integer item_no, Model m) throws Exception {
        if (item_no != null) {
            ProductVO p = productService.getProductById(item_no);
            m.addAttribute("product", p);
            
            // 랜덤 상품 4개 추천 (bx slider용)
            List<ProductVO> randomProducts = productService.getRandomProducts(4);
            m.addAttribute("randomProducts", randomProducts);
        }
        return "detail";
    }
	
    @GetMapping("detail2")
	public String detail2() {
		return "detail2";
	}
	

	  @GetMapping("mlist") 
	  public String mlist() { return "mlist"; }

	
	@GetMapping("selectGui")	
    public String selectGui(Model m,
                    @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                    @RequestParam(value = "size", required = false, defaultValue = "9") int size,
                    @RequestParam(value = "q", required = false) String q,
                    @RequestParam(value = "sort", required = false) String sort,
                    @RequestParam(value = "cate", required = false) Integer cate) {
        Integer cateNo = (cate != null) ? cate : 1;	// 기본 카테고리 매핑: 구이 -> 1
        loadCategoryProducts(m, page, size, q, sort, cateNo);
        return "selectGui";
    }
	
	@GetMapping("selectSoup")	
    public String selectSoup(Model m,
	                 @RequestParam(value = "page", required = false, defaultValue = "1") int page,
	                 @RequestParam(value = "size", required = false, defaultValue = "9") int size,	//9개 상품 목록
	                 @RequestParam(value = "q", required = false) String q,
	                 @RequestParam(value = "sort", required = false) String sort,
	                 @RequestParam(value = "cate", required = false) Integer cate) {
        Integer cateNo = (cate != null) ? cate : 2;	// 기본 카테고리 매핑: 국/찌개 -> 2
        loadCategoryProducts(m, page, size, q, sort, cateNo);
        return "selectSoup";
    }

	@GetMapping("selectDiet")
    public String selectDiet(Model m,
                     @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                     @RequestParam(value = "size", required = false, defaultValue = "9") int size,
                     @RequestParam(value = "q", required = false) String q,
                     @RequestParam(value = "sort", required = false) String sort,
                     @RequestParam(value = "cate", required = false) Integer cate) {
        Integer cateNo = (cate != null) ? cate : 3; // 기본 카테고리 매핑: 식단관리 -> 3
        loadCategoryProducts(m, page, size, q, sort, cateNo);
        return "selectDiet";
    }
    
	@GetMapping("selectBunsik")
    public String selectBunsik(Model m,
                   @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                   @RequestParam(value = "size", required = false, defaultValue = "9") int size,
                   @RequestParam(value = "q", required = false) String q,
                   @RequestParam(value = "sort", required = false) String sort,
                   @RequestParam(value = "cate", required = false) Integer cate) {
        Integer cateNo = (cate != null) ? cate : 4; // 기본 카테고리 매핑: 분식 -> 4
        loadCategoryProducts(m, page, size, q, sort, cateNo);
        return "selectBunsik";
    }		

	@GetMapping("selectBanchan")
    public String selectBanchan(Model m,
                    @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                    @RequestParam(value = "size", required = false, defaultValue = "9") int size,	//9개 상품 목록(페이지당)
                    @RequestParam(value = "q", required = false) String q,
                    @RequestParam(value = "sort", required = false) String sort,
                    @RequestParam(value = "cate", required = false) Integer cate) {        
        Integer cateNo = (cate != null) ? cate : 5;		// 기본 카테고리 매핑: 반찬 -> 5
        loadCategoryProducts(m, page, size, q, sort, cateNo);
        return "selectBanchan";
    }
	
	@GetMapping("selectdrink")
	public String selectdrink(Model m,
				      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
				      @RequestParam(value = "size", required = false, defaultValue = "9") int size,	//9개 상품 목록(페이지당)
				      @RequestParam(value = "q", required = false) String q,
				      @RequestParam(value = "sort", required = false) String sort,
				      @RequestParam(value = "cate", required = false) Integer cate) {
		Integer cateNo = (cate != null) ? cate : 6; // 기본 카테고리 매핑: 음료 -> 6
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

            List<ProductVO> products = productService.getProducts(params);
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
            m.addAttribute("size", 9);	//9개 상품 목록(페이지당)
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