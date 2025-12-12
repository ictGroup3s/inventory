package com.example.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.model.vo.ProductVO;

@Controller
public class NewArrivalController {

	@Autowired
	private SqlSession sqlSession;
	
	@GetMapping("/event2")
	public String event2(Model m,
			@RequestParam(value ="page",required = false, defaultValue = "1") int page,
			@RequestParam(value ="size",required = false, defaultValue = "9") int size) {
		
		int offset = (page - 1) * size;
		
		 // HashMap을 사용하여 offset과 size를 저장
        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("size", size);
        
	    // 신상품 목록을 가져오는 쿼리 실행
        List<ProductVO> list = sqlSession.selectList("projectMapper.newarrivals", params);
		
        // 전체 상품 수를 가져오는 쿼리 실행 (페이지네이션을 위해)
        int totalCount = sqlSession.selectOne("projectMapper.selectNewArrivalsCount");

        m.addAttribute("newArrivals", list);
        m.addAttribute("totalCount", totalCount);
        m.addAttribute("page", page);
        m.addAttribute("size", size);

        return "event2";
    }
}