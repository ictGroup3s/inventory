package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.model.vo.CustomerVO;
import com.example.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
	
	private final UserService service; //서비스단 (서비스실행>레포정보불러옴>매퍼)
	
	public UserController(UserService service) { //생성자 서비스 주입받음
		this.service = service; //변경불가
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
		@RequestParam(required = false) Integer admin_bnum
				,	Model m) {
	
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
		    
		    //이메일 중복 체크
		    if(service.checkEmailExists(vo.getEmail())) {
		    	m.addAttribute("emailError", "이미 사용중인 이메일 입니다.");
		    	m.addAttribute("customerVO", vo);
		    	m.addAttribute("user_type", user_type);
		    	return "register"; //이메일 중복시 다시 회원가입 화면으로
		    			
		    }
		    
		    //회원가입
			boolean success = service.registerUser(vo);
			
			if(!success) {
		        // 아이디 중복 에러 메시지 설정
		        m.addAttribute("idError", "이미 존재하는 아이디입니다.");
		        m.addAttribute("customerVO", vo);
		        m.addAttribute("user_type", user_type);
		        return "register";  // 아이디 중복시다시 회원가입 화면으로
		    }
			 // 성공
				m.addAttribute("message", "회원가입 성공! 로그인하세요.");
				return "login"; // 로그인 페이지
			}//register end

		@PostMapping("/delete")
		public String deleteById(@RequestParam String customer_id, HttpSession session) {
				service.deleteById(customer_id); //위에 선언된 서비스 호출
				session.invalidate(); // 세션 무효화 -> 로그아웃 처리
				return "redirect:/goodbye";
		}	
		
		//회원 수정 폼(get)
		@GetMapping("/updateUser")
		public String updateForm(HttpSession session, Model m) {
			//세션에서 로그인된 아이디 가져오기
			CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
			  System.out.println("세션 loginUser: " + loginUser);
			//로그인 안되어 있으면 로그인 페이지로 이동
			if(loginUser == null) {
				return "redirect:login";
			}
			
			//조회한 회원정보 모델에 담아서 jsp 전달
			m.addAttribute("customer", loginUser); //jsp에서 사용할이름=${customer.name}
			return "update"; //update.jsp로 리턴
		}
		
		// 회원 수정 처리(post)
				@PostMapping("/updateUser")
				public String updateSubmit(CustomerVO customer,HttpSession session) {
					  CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
					
					//로그인 안되어 있으면 로그인 페이지로 이동
					if(loginUser == null) {
						return "redirect:/login";
					}
					
					//아이디는 세션 기준으로 강제실행
					customer.setCustomer_id(loginUser.getCustomer_id());
					//DB 업데이트 실행
					service.updateUser(customer);
					
					
					//수정 완료 후 마이페이지로 
					return "redirect:/mypage";
				}
	}