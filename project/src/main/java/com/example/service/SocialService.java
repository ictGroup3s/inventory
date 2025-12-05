package com.example.service;

import org.springframework.stereotype.Service;

import com.example.model.SocialMapper;
import com.example.model.vo.CustomerVO;

	@Service
	public interface SocialService {
		CustomerVO findBySocialId(String socialId, String provider);
		void insertCustomer(CustomerVO c);
	}
	
	@Service
	class SocialServiceImpl implements SocialService {
		
		 private final SocialMapper mapper;
		 
		 public SocialServiceImpl(SocialMapper mapper) { 
		    	
		    	this.mapper = mapper; 
		  }
		    
		  @Override
		 public CustomerVO findBySocialId(String s, String p) { 
			  return mapper.selectBySocialId(s, p); }
		  @Override
		 public void insertCustomer(CustomerVO c) { mapper.insertCustomer(c); }
		}