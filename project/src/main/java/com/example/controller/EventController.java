package com.example.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.model.vo.ProductVO;
import com.example.service.EventService;
import com.example.service.ProductService;

@Controller
public class EventController {
	
	  @Autowired
	   private EventService eventService;

	    
	  @GetMapping("event1")
	  	public String event1 (Model m,
						      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
						      @RequestParam(value = "size", required = false, defaultValue = "9") int size) {

			  int offset = (page - 1) * size;
			
					
			  //할인상품
			  List<ProductVO> discount = eventService.getDiscount(size, offset);
			  int total = eventService.getDiscountCount();
			  int totalPages = (int) Math.ceil((double) total / size);
			  
			  // JSP로 전달
			  m.addAttribute("dis", discount);
			  m.addAttribute("size", size);
			  m.addAttribute("totalPages", totalPages);	
			  m.addAttribute("currentPage", page);
			  
			  return "event1";  // event1.jsp
}

	  
	  
	  @GetMapping("event2")
	    public String event2(
	            Model m,
	            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
	            @RequestParam(value = "size", required = false, defaultValue = "9") int size) {

	        int offset = (page - 1) * size;

	        // 최신상품 
	        List<ProductVO> products = eventService.getNewArrivals(size,offset);
	        int total = eventService.getNewArrivalsCount();
	        int totalPages = (int) Math.ceil((double) total / size);
 
	                
	        // JSP로 전달
	        m.addAttribute("newArrivals", products);//jsp파일에 띄울 이름값 <c:forEach var="item" items="${newArrivals}">
	        m.addAttribute("size", size);
	        m.addAttribute("totalPages", totalPages);
	        m.addAttribute("currentPage", page);
	        
	        return "event2";  // event2.jsp
	    }
	}