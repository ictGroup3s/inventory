package com.example.model;

import java.util.List;
import java.util.Map;

public interface CartRepository {
    Map<String,Object> findByCustomerAndItem(String customerId, Integer itemNo);
    int insertCartItem(Map<String,Object> params);
    int increaseCartCntByCartNo(Map<String,Object> params);
    int updateCartCntByCartNo(Map<String,Object> params);
    int deleteCartByCartNo(Integer cartNo);
    int deleteCartByCustomerAndItem(Map<String,Object> params);
    List<Map<String,Object>> findByCustomer(String customerId);
    int countByCustomer(String customerId);
    
    void deleteCartByCustomer(String customerId);
}
