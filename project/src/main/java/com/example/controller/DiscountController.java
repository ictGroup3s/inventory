package com.example.controller;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.model.vo.ProductVO;

@Controller
public class DiscountController {
	
		@Autowired
		private SqlSessionTemplate sqlSession;
		
		@GetMapping("/event1")
		public String event1(Model m) {
			List<ProductVO> list = sqlSession.selectList("projectMapper.selectDiscount");
			
			m.addAttribute("dis",list);
			return "event1";
		}
}
