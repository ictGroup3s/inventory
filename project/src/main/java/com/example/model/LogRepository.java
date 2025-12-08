package com.example.model;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.model.vo.CustomerVO;

@Mapper
public interface LogRepository {

	CustomerVO loginUser(CustomerVO vo);
	
	CustomerVO findByNameAndPhone(@Param("name") String name, @Param("phone")String phone);
	
	CustomerVO findByIdAndPhone(@Param("customer_id") String id, @Param("phone")String phone);
	
	void updatePwd(CustomerVO vo);
}
