package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.model.vo.CustomerVO;
import com.example.service.UserService;

@Controller
public class UserController {
	
	private final UserService service;
	
	public UserController(UserService service) {
		this.service = service;
	}
	
	@PostMapping("/registerAction")
	public String register(
			@RequestParam String user_type, // "member" or "admin"
			@RequestParam String customer_id,
			@RequestParam String pwd,
			@RequestParam String pwd2,
			@RequestParam String name,
			@RequestParam String phone, 
			@RequestParam(required = false) String email,
			@RequestParam(required = false) String addr,
			@RequestParam(required = false) Integer admin_bnum,
			Model m) {
	
    
	    CustomerVO vo = new CustomerVO();
			vo.setCustomer_id(customer_id);
			vo.setPwd(pwd);
			vo.setName(name);
			vo.setEmail(email);
			vo.setPhone(phone);
			vo.setAddr(addr);
			vo.setRole("admin".equals(user_type) ? 1 : 0); //admin이면 1세팅 아니면 0
			vo.setAdmin_bnum("admin".equals(user_type) ? admin_bnum : 0); // 일반 회원은 0, admin은 입력값
			
			 // 비밀번호 확인
		    if(!pwd.equals(pwd2)) {
		        m.addAttribute("pwError", "비밀번호가 서로 일치하지 않습니다.");
		        m.addAttribute("customerVO", vo); // JSP에서 값 유지
		        m.addAttribute("user_type", user_type);
		        return "register"; // JSP 파일 이름
		    }
		    
			    
		    
		    //회원가입
			boolean success = service.registerUser(vo);
			
			if(!success) {
		        // 아이디 중복 에러 메시지 설정
		        m.addAttribute("idError", "이미 존재하는 아이디입니다.");
		        m.addAttribute("customerVO", vo);
		        m.addAttribute("user_type", user_type);

		        return "register";  // 다시 회원가입 화면으로
		    }
			 // 성공
				m.addAttribute("message", "회원가입 성공! 로그인하세요.");
				return "login"; // 로그인 페이지
			}
	}