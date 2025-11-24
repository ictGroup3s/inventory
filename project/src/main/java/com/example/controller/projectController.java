package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class projectController {
	
	
	@GetMapping("cart")
	public String cart() {
		return "cart";
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
}
