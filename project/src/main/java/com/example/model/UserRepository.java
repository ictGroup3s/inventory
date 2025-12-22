package com.example.model;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.example.model.vo.CustomerVO;


@Mapper
@Repository
public interface UserRepository{
	
		// 아이디 중복 체크
		int checkId(@Param("customer_id") String customer_id); // Mapper XML에 id="checkId"와 매핑
		
		// 이메일 중복체크
		int checkEmail(@Param("email") String email); //이메일 중복체크
		
		// 회원가입
		void registerUser(CustomerVO customer); // Mapper XML에 id="registerUser"와 매핑
		
		// 회원탈퇴 
		void softDeleteById(@Param("customer_id") String customer_id);
		
		//회원수정 매퍼 update id값과 매서드명 일치
		void updateUser(CustomerVO customer);
		
		//회원 id로 조회
		CustomerVO selectAllById(@Param("customer_id") String customer_id);
		
		}

