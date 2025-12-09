package com.example.model;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.model.vo.CustomerVO;


@Mapper
public interface UserRepository{
	
		// 아이디 중복 체크
		int checkId(String customer_id); // Mapper XML에 id="checkId"와 매핑
		 // 회원가입
		void registerUser(CustomerVO customer); // Mapper XML에 id="registerUser"와 매핑
		
	}

