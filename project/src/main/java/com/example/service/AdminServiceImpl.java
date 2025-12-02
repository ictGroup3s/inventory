package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.AdminRepository;
import com.example.model.vo.ProductVO;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	private AdminRepository adminRepository;
	
	@Override
	public void saveItem(ProductVO vo) {
		adminRepository.saveItem(vo);
		
	}

	@Override
	public List<ProductVO> getItemList() {
		return adminRepository.getItemList();
	}

	@Override
	public void updateItem(ProductVO vo) {
		adminRepository.updateItem(vo);
		
	}

	@Override
	public void deleteItem(Integer itemNo) throws Exception {
		adminRepository.deleteItem(itemNo);
		
	}

}
