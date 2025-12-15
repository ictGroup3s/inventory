package com.example.service;

import java.util.List;
import java.util.Map;
import com.example.model.vo.ProductVO;

public interface ProductService {
    ProductVO getProductById(Integer item_no);
    List<ProductVO> getAllProducts();
    List<ProductVO> getProducts(Map<String, Object> params);
    int getProductsTotal(Map<String, Object> params);
    List<ProductVO> getRandomProducts(int limit);
}
