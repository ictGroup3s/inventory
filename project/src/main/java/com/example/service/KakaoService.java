package com.example.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.example.model.vo.KakaoVO;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
@Service
public class KakaoService {
	
	   @Value("${kakao.client.id}")
	    private String clientId;

	    @Value("${kakao.redirect.uri}")
	    private String redirectUri;

	    private final RestTemplate restTemplate = new RestTemplate();
	    private final ObjectMapper objectMapper = new ObjectMapper();

	    /**
	     * 인가 코드로 액세스 토큰 발급
	     */
	    public String getAccessToken(String code) {
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

	        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
	        params.add("grant_type", "authorization_code");
	        params.add("client_id", clientId);
	        params.add("redirect_uri", redirectUri);
	        params.add("code", code);

	        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
	        ResponseEntity<String> response = restTemplate.postForEntity(
	                "https://kauth.kakao.com/oauth/token", request, String.class);

	        try {
	            JsonNode jsonNode = objectMapper.readTree(response.getBody());
	            return jsonNode.get("access_token").asText(); // access_token만 추출
	        } catch (Exception e) {
	            throw new RuntimeException("액세스 토큰 파싱 실패", e);
	        }
	    }

	    /**
	     * 액세스 토큰으로 사용자 정보 조회
	     */
	    public KakaoVO getUserInfo(String accessToken) {
	        HttpHeaders headers = new HttpHeaders();
	        headers.set("Authorization", "Bearer " + accessToken);

	        HttpEntity<String> request = new HttpEntity<>(headers);
	        ResponseEntity<String> response = restTemplate.exchange(
	                "https://kapi.kakao.com/v2/user/me", HttpMethod.GET, request, String.class);

	        try {
	            return objectMapper.readValue(response.getBody(), KakaoVO.class);
	        } catch (Exception e) {
	            throw new RuntimeException("사용자 정보 파싱 실패", e);
	        }
	    }
	}
