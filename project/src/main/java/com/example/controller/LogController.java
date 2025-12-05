package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.model.vo.CustomerVO;
import com.example.service.LogService;
import com.example.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class LogController {

	private final LogService logservice;

	 
	public LogController(LogService logservice) {
		 this.logservice = logservice;
		
	 }

		// 로그인 처리
	    @PostMapping("/login")
	    public String login(@RequestParam String login_id,
	                        @RequestParam String login_pass,
	                        HttpSession session,
	                        RedirectAttributes ra,
	                        Model m) {

	        CustomerVO user = logservice.loginUser(login_id, login_pass);

	        if (user !=null) { 
	        	session.setAttribute("loginUser", user); 	       //세션저장
	        	session.setAttribute("loginRole", user.getRole());
	           return "redirect:/header"; // 로그인 성공 시 메인으로
	           
	       } else {
	    	   m.addAttribute("loginError", "아이디 또는 비밀번호가 틀렸습니다.");
	           m.addAttribute("loginId", login_id);
	           return "login"; // 페이지 그대로
	        }
	    }

	  //로그아웃 처리
	    @GetMapping("/logout")
	    public String logout(HttpSession session) {
	    	session.invalidate(); //모든세션 삭제
	    	return "redirect:/";
	    }
	    
	    // 아이디/비밀번호 찾기 폼
		@GetMapping("/find")
		public String findForm() {
		  return "find"; // find.jsp
		 }
		
		//아이디/비밀번호 찾기 처리
		@PostMapping("/find")
		public String find(
		            @RequestParam String action,
		            @RequestParam(required = false) String name,
		            @RequestParam(required = false) String id,
		            @RequestParam(required = false) String phone,
		            Model m) {
		    	
		if("findId".equals(action)) {
			//아이디 찾기
			 String foundId = logservice.findId(name, phone);
			
			if (foundId != null) {
				m.addAttribute("findId", "찾으신 아이디: " + foundId);
			}else {
				m.addAttribute("error", "등록된 아이디가 없습니다.");
			}
			 	m.addAttribute("name", name);
		        m.addAttribute("phone", phone);
		        
		}else if("findPw".equals(action)) {
			boolean resetSuccess = logservice.resetPwd(id, phone);
	       if (resetSuccess) {
	            m.addAttribute("tempPwd", "임시 비밀번호가 발급되었습니다.");
	       } else {
	            m.addAttribute("error", "등록된 계정이 없습니다.");
	            }
	        m.addAttribute("id", id);
	        m.addAttribute("phone", phone);
	        }
		return "find"; //jsp 로 돌아감
		
	}
	
}
