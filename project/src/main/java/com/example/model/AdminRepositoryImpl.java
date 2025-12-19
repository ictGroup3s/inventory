package com.example.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.ProductVO;
import com.example.model.vo.StockVO;

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
		System.out.println("[AdminRepositoryImpl] getItemList()");
		return sess.selectList("adminmapper.getItemList");		
	}

	@Override
	public void updateItem(ProductVO vo) {
		sess.update("adminmapper.updateItem",vo);
		
	}

	@Override
	public void deleteItem(Integer itemNo) throws Exception {
		sess.delete("adminmapper.deleteItem",itemNo);
		
	}

	@Override
	public void updateStock(ProductVO vo) {
		sess.update("adminmapper.updateStock",vo);
		
	}

	@Override
	public void insertStockHistory(StockVO vo) {
		sess.insert("adminmapper.insertStockHistory",vo);
		
	}

	@Override
	public ProductVO getProductByNo(Integer itemNo) {
	    return sess.selectOne("adminmapper.getProductByNo", itemNo);
	}
	
	@Override
	public void updateStockOnly(ProductVO vo) {
	    sess.update("adminmapper.updateStockOnly", vo);
	}
	
	@Override
	public List<ProductVO> getStockList() {
	    return sess.selectList("adminmapper.getStockList");
	}

	@Override
	public void updateItemStatusToSoldOut(int itemNo) {
	    sess.update("adminmapper.updateItemStatusToSoldOut", itemNo);
	}

	
}