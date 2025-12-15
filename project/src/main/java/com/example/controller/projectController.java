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
}