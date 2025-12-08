package com.example.model;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.model.vo.CustomerVO;

@Mapper
public interface SocialMapper {
	CustomerVO selectBySocialId(@Param("social_id") String socialId, @Param("provider") String provider);
	void insertCustomer(CustomerVO c);

}
