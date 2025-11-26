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
	
	@GetMapping("fish2Detail")
	public String fish2Detail() {
		return "fish2Detail";
	}
	
	@GetMapping("register")
	public String register() {
		return "register";
	}
	
	@GetMapping("register2")
	public String register2() {
		return "register2";
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
	
	@GetMapping("selectRecipe")
	public String selectRecipe() {
		return "selectRecipe";
	}
	
	@GetMapping("selectSoup")
	public String selectSoup() {
		return "selectSoup";
	}


	@GetMapping("board")
	public String board() {
		return "board";
	}
	
	@GetMapping("dashboard")
	public String dashboard() {
		return "dashboard";
	}
	
	@GetMapping("stock")
	public String stock() {
		return "stock";
	}
	
	@GetMapping("item")
	public String item() {
		return "item";
	}
	
	@GetMapping("order")
	public String order() {
		return "order";
	}
	
}
