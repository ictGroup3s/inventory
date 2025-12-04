package com.example.model;

import java.util.List;
import java.util.Map;
import com.example.domain.productVO;

public interface ProductRepository {
    productVO selectProductById(Integer item_no);
    List<productVO> selectAllProducts();
    List<productVO> selectProducts(Map<String, Object> params);
    int selectProductsCount(Map<String, Object> params);
}
