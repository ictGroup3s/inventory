package com.example.model;

import java.util.List;
import java.util.Map;
import com.example.model.vo.ProductVO;

public interface ProductRepository {
	ProductVO selectProductById(Integer item_no);
    List<ProductVO> selectAllProducts();
    List<ProductVO> selectProducts(Map<String, Object> params);
    int selectProductsCount(Map<String, Object> params);
}
