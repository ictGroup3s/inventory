package com.example.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CartRepositoryImpl implements CartRepository {

    private static final String NAMESPACE = "cartMapper.";

    @Autowired
    private SqlSessionTemplate sess;

    @Override
    public Map<String,Object> findByCustomerAndItem(String customerId, Integer itemNo) throws Exception {
        return sess.selectOne(NAMESPACE + "selectCartByCustomerAndItem", Map.of("customerId", customerId, "itemNo", itemNo));
    }

    @Override
    public int insertCartItem(Map<String,Object> params) throws Exception {
        return sess.insert(NAMESPACE + "insertCartItem", params);
    }

    @Override
    public int increaseCartCntByCartNo(Map<String,Object> params) throws Exception {
        return sess.update(NAMESPACE + "increaseCartCntByCartNo", params);
    }

    @Override
    public int updateCartCntByCartNo(Map<String,Object> params) throws Exception {
        return sess.update(NAMESPACE + "updateCartCntByCartNo", params);
    }

    @Override
    public int deleteCartByCartNo(Integer cartNo) throws Exception {
        return sess.delete(NAMESPACE + "deleteCartByCartNo", cartNo);
    }

    @Override
    public int deleteCartByCustomerAndItem(Map<String,Object> params) throws Exception {
        return sess.delete(NAMESPACE + "deleteCartByCustomerAndItem", params);
    }

    @Override
    public List<Map<String,Object>> findByCustomer(String customerId) throws Exception {
        return sess.selectList(NAMESPACE + "selectCartByCustomer", customerId);
    }

    @Override
    public int countByCustomer(String customerId) throws Exception {
        Integer cnt = sess.selectOne(NAMESPACE + "countByCustomer", customerId);
        return cnt == null ? 0 : cnt;
    }
}