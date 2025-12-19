package com.example.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.model.UserRepository;
import com.example.model.vo.CustomerVO;

@Service
public class UserService {
	//컨트롤러 내부에서만 접근 한번 생성자 주입되면 변경불가
	private final UserRepository repo;
	
	public UserService(UserRepository repo) {
		this.repo = repo;
	}

	@Transactional
	public boolean checkEmailExists(String email) {
		return repo.checkEmail(email)>0; // 이메일이 이미 있으면 true, 없으면 false
	}
	
	
	@Transactional //매서드 내에서 db 작업이 모두 성공해야 커밋됨. DB 상태가 깨끗하게 유지
	public boolean registerUser(CustomerVO vo) {

		 //아이디 중복체크
		 if(repo.checkId(vo.getCustomer_id()) > 0) return false;

	     //이메일 중복 체크
		 if (checkEmailExists(vo.getEmail())) {
			 return false; //이베일이 이미 존재하면 false로 반환
		 }
		 
		 //회원가입  
		 repo.registerUser(vo);   // Mapper XML의 registerUser 호출
	     return true;
	}
	//회원 삭제
	public void deleteById(String customer_id) {
		repo.softDeleteById(customer_id); //db삭제 실행
	}
	
	//회원 수정
	@Transactional
	public void updateUser(CustomerVO customer) {
		repo.updateUser(customer);
	}
	//회원 조회
	public CustomerVO getUserById(String customer_id) {
		return repo.selectAllById(customer_id);
	}
	
	
}
