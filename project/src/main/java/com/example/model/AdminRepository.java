package com.example.model;

import java.util.List;

import com.example.model.vo.ProductVO;

public interface AdminRepository {

	public void saveItem(ProductVO vo);
	public List<ProductVO> getItemList();
	public void updateItem(ProductVO vo);
	public void deleteItem(Integer itemNo) throws Exception;
	public void updateStock(ProductVO vo);
}
