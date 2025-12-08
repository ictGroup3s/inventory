package com.example.service;

import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.model.UserRepository;
import com.example.model.vo.CustomerVO;

@Service
public class UserService {
	
	private final UserRepository repo;
	
	public UserService(UserRepository repo) {
		this.repo = repo;
	}

	@Transactional
	public boolean registerUser(CustomerVO vo) {

		//아이디 중복체크
		 if(repo.checkId(vo.getCustomer_id()) > 0) return false;

	        repo.registerUser(vo);   // Mapper XML의 registerUser 호출
	        return true;
		
	}
		
}