package com.example.model.vo;

import lombok.Data;

@Data
public class CustomerVO {
	private String customer_id;
	private String name;
	private Integer role; // 0 = 일반회원, 1 = 관리자
	private String pwd;
	private String reg_date;
	private String social_id;     // 소셜 로그인 고유 ID (api -> social_id)
	private String provider;      // google / kakao / naver / local
	private Integer admin_bnum;
	private String phone;
	private String addr;
	private String email;
	

}
