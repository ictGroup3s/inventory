package com.example.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.ProductVO;

@Repository
public class ProductRepositoryImpl implements ProductRepository {

    private static final String NAMESPACE = "projectMapper.";

    @Autowired
    private SqlSessionTemplate sess;

    @Override
    public ProductVO selectProductById(Integer item_no) {
        return sess.selectOne(NAMESPACE + "selectProductById", item_no);
    }

    @Override
    public List<ProductVO> selectAllProducts() {
        return sess.selectList(NAMESPACE + "selectAllProducts");
    }

    @Override
    public List<ProductVO> selectProducts(Map<String, Object> params) {
        return sess.selectList(NAMESPACE + "selectProducts", params);
    }

    @Override
    public int selectProductsCount(Map<String, Object> params) {
        Integer cnt = sess.selectOne(NAMESPACE + "selectProductsCount", params);
        return cnt == null ? 0 : cnt.intValue();
    }
}
