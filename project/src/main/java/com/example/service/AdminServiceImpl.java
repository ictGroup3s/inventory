package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.AdminRepository;
import com.example.model.vo.ProductVO;
import com.example.model.vo.StockVO;

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

	@Override
	public void updateStock(ProductVO vo) {
	    // 기존 재고 조회
	    ProductVO oldProduct = adminRepository.getProductByNo(vo.getItem_no());
	    int beforeQty = oldProduct.getStock_cnt();
	    int afterQty = vo.getStock_cnt();
	    int changeQty = afterQty - beforeQty;
	    
	    // 1. product 테이블 업데이트
	    adminRepository.updateStock(vo);
	    
	    // 2. stock 이력 저장
	    if (changeQty != 0) {
	        StockVO stockVO = new StockVO();
	        stockVO.setItem_no(vo.getItem_no());
	        stockVO.setStock(afterQty);
	        
	        if (changeQty > 0) {
	            stockVO.setStock_in(changeQty);
	            stockVO.setStock_out(0);
	        } else {
	            stockVO.setStock_in(0);
	            stockVO.setStock_out(Math.abs(changeQty));
	        }
	        
	        adminRepository.insertStockHistory(stockVO);
	    }
	}

}
