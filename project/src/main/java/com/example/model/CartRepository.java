package com.example.model;

import java.util.List;
import java.util.Map;

public interface CartRepository {
    Map<String,Object> findByCustomerAndItem(String customerId, Integer itemNo) throws Exception;
    int insertCartItem(Map<String,Object> params) throws Exception;
    int increaseCartCntByCartNo(Map<String,Object> params) throws Exception;
    int updateCartCntByCartNo(Map<String,Object> params) throws Exception;
    int deleteCartByCartNo(Integer cartNo) throws Exception;
    int deleteCartByCustomerAndItem(Map<String,Object> params) throws Exception;
    List<Map<String,Object>> findByCustomer(String customerId) throws Exception;
    int countByCustomer(String customerId) throws Exception;
}