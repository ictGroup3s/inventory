package com.example.controller;

import java.awt.PageAttributes.MediaType;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.example.model.vo.KakaoVO;
import com.example.service.KakaoService;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.netty.handler.codec.http.HttpHeaders;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/oauth")
@RequiredArgsConstructor
public class KakaoController {
	
	 private final KakaoService kakaoService; // Service 주입
	 
	 // application.properties에 있는 변수값얻어오기 
	 	@Value("${kakao.client.id}")
	    private String clientId;

	    @Value("${kakao.redirect.uri}")
	    private String redirectUri;

	    /**
	     * 인가 코드로 액세스 토큰 발급
	     */
	    @GetMapping("/kakao")
	    public String kakaoLogin() {
	        String url = "https://kauth.kakao.com/oauth/authorize?client_id=" 
	                     + clientId 
	                     + "&redirect_uri=" + redirectUri 
	                     + "&response_type=code";
	        return "redirect:" + url;
	    }

	    /**
	     * 카카오 로그인 콜백
	     * - 인가 코드(code)를 받아 Service 호출
	     */
	    @GetMapping("/kakao/callback")
	    public String kakaoCallback(@RequestParam String code, Model model) {
	    	System.out.println("1>"+code);
	        try {
	            String accessToken = kakaoService.getAccessToken(code);
	            KakaoVO kakaoVO = kakaoService.getUserInfo(accessToken);
	            model.addAttribute("user", kakaoVO);
	            System.out.println("2>" + kakaoVO);
	            
	            return "redirect:/kakaolog";
	        } catch (HttpClientErrorException e) {
	            // 카카오 서버에서 401, 400 등 에러 응답 시 처리
	            model.addAttribute("error", "카카오 로그인 실패: " + e.getStatusCode());
	            e.printStackTrace();
	            return "error"; // error.html 페이지로 이동
	        } catch (Exception e) {
	            model.addAttribute("error", "알 수 없는 오류가 발생했습니다.");
	            return "error";
	        }
	    }

	    
	  

	}