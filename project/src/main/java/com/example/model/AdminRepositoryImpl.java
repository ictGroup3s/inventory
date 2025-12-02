package com.example.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.ProductVO;

@Repository
public class AdminRepositoryImpl implements AdminRepository{

	@Autowired
	private SqlSessionTemplate sess;
	
	@Override
	public void saveItem(ProductVO vo) {
		sess.insert("adminmapper.saveItem",vo);
	}

	@Override
	public List<ProductVO> getItemList() {
		
		return sess.selectList("adminmapper.getItemList");
	}

	@Override
	public void updateItem(ProductVO vo) {
		sess.update("adminmapper.updateItem",vo);
		
	}

}
