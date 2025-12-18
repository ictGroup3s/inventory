package com.example.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.client.RestTemplate;

import com.example.model.vo.CustomerVO;
import com.example.service.SocialService;

import jakarta.servlet.http.HttpSession;
import lombok.Data;

@Controller
public class GoogleLoginController {

	private final SocialService socialService;
	
	public GoogleLoginController(SocialService socialService) {
		this.socialService = socialService;
	}
	
	@Value("${google.client.id}")
	private String clientId;
	
	@Value("${google.client.secret}")
	private String clientSecretString;
	
	@Value("${google.redirect.uri}")
	private String redirectUri;
	
	@GetMapping("/googleLogin")
	public String googleLogin() {
		String googleAuthUrl = "https://accounts.google.com/o/oauth2/auth?"
				+ "client_id=" + clientId
				+ "&redirect_uri=" + redirectUri
				+ "&response_type=code"
				+ "&scope=email%20profile";
		
		return "redirect:" + googleAuthUrl;
	}
	
	// 구글 callback 
	@GetMapping("/googleCallback")
	public String googleCallback(String code, HttpSession session) throws Exception {
		
		//토큰요청
		RestTemplate rest = new RestTemplate();
		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
		params.add("code", code);
		params.add("client_id", clientId);
	    params.add("client_secret", clientSecretString);
	    params.add("redirect_uri", redirectUri);
	    params.add("grant_type", "authorization_code");
		
	    GoogleToken token = rest.postForObject(
               "https://oauth2.googleapis.com/token",
                params,
                GoogleToken.class
        );

	    // 사용자 정보 요청
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token.getAccess_token());
        HttpEntity<String> entity = new HttpEntity<>(headers);

        ResponseEntity<GoogleUser> response = rest.exchange(
                "https://www.googleapis.com/oauth2/v2/userinfo",
                HttpMethod.GET,
                entity,
                GoogleUser.class
        );

        GoogleUser googleUser = response.getBody();
        
        // DB 조회 (social_id + provider)
        CustomerVO c = socialService.findBySocialId(googleUser.getId(), "google");
        
        if(c == null) {
        	// 신규가입
        	c = new CustomerVO();
        	c.setCustomer_id(googleUser.getId()); //customer_id 에 소셜아이디입력
        	c.setSocial_id(googleUser.getId());
        	c.setProvider("google");
        	c.setName(googleUser.getName());
        	c.setEmail(googleUser.getEmail());
        	c.setPwd("GOOGLE");
        	socialService.insertCustomer(c);
        }
        //로그인 세션저장
        session.setAttribute("loginUser", c);
        session.setAttribute("loginRole", c.getRole());
        	
        return "redirect:header";  //로그인후 헤더로 이동
        }
	
	     @Data
	     private static class GoogleToken {
	    	 private String access_token;
	    	 private String token_type;
	    	 private String expires_in;
     }
        
	     @Data
	     private static class GoogleUser{
	    	 private String id;
	    	 private String email;
	    	 private String name;
	    	 private String picture;
	     }
	     
	}

