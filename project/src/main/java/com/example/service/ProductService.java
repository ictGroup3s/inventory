package com.example.service;

import java.util.List;
import java.util.Map;
import com.example.domain.productVO;

public interface ProductService {
    productVO getProductById(Integer item_no);
    List<productVO> getAllProducts();
    List<productVO> getProducts(Map<String, Object> params);
    int getProductsTotal(Map<String, Object> params);
}
