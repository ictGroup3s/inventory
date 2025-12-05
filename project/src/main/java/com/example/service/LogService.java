<<<<<<< HEAD
package com.example.service;

import java.util.UUID;

import org.springframework.stereotype.Service;

import com.example.model.LogRepository;
import com.example.model.vo.CustomerVO;

@Service
public class LogService {

	private LogRepository repository;
	
	public LogService(LogRepository repository) {
		this.repository = repository;
	}
	
	//로그인
	public CustomerVO loginUser(String id, String pwd) {
		CustomerVO vo = new CustomerVO();
		vo.setCustomer_id(id);
		vo.setPwd(pwd);
		return repository.loginUser(vo);
	}

	//아이디 찾기
	public String findId(String name, String phone) {
		CustomerVO user = repository.findByNameAndPhone(name, phone);
		return (user != null) ? user.getCustomer_id() : null;
		
		}
		
	//임시 비밀번호 발급 후 업데이트
	public boolean resetPwd(String id, String phone) {
		CustomerVO user = repository.findByIdAndPhone(id, phone);
        if (user == null) return false;
		
		
		// 임시 비밀번호 생성 (영문+숫자 8자리)
        String tempPwd = UUID.randomUUID().toString().replace("-","").substring(0, 8);
        user.setPwd(tempPwd);
		
		repository.updatePwd(user);
		
		System.out.println("임시 비밀번호: " + tempPwd); //콘솔출력
        
        return true;
		
	}
}
=======
package com.example.service;

import java.util.UUID;

import org.springframework.stereotype.Service;

import com.example.model.LogRepository;
import com.example.model.vo.CustomerVO;

@Service
public class LogService {

	private LogRepository repository;
	
	public LogService(LogRepository repository) {
		this.repository = repository;
	}
	
	//로그인
	public CustomerVO loginUser(String id, String pwd) {
		CustomerVO vo = new CustomerVO();
		vo.setCustomer_id(id);
		vo.setPwd(pwd);
		return repository.loginUser(vo);
	}

	//아이디 찾기
	public String findId(String name, String phone) {
		CustomerVO user = repository.findByNameAndPhone(name, phone);
		return (user != null) ? user.getCustomer_id() : null;
		
		}
		
	//임시 비밀번호 발급 후 업데이트
	public boolean resetPwd(String id, String phone) {
		CustomerVO user = repository.findByIdAndPhone(id, phone);
        if (user == null) return false;
		
		
		// 임시 비밀번호 생성 (영문+숫자 8자리)
        String tempPwd = UUID.randomUUID().toString().replace("-","").substring(0, 8);
        user.setPwd(tempPwd);
		
		repository.updatePwd(user);
		
		System.out.println("임시 비밀번호: " + tempPwd); //콘솔출력
        
        return true;
		
	}
}
>>>>>>> b91594d1901f5462bbf72445278a27381562ec15
