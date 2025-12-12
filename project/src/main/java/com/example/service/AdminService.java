package com.example.service;

import java.util.List;

import com.example.model.vo.ProductVO;

public interface AdminService {
	public void saveItem(ProductVO vo);
	List<ProductVO> getItemList(); 
	public void updateItem(ProductVO vo);
	public void deleteItem(Integer itemNo) throws Exception;
	public void updateStock(ProductVO vo);
	public List<ProductVO> getStockList();
	
}