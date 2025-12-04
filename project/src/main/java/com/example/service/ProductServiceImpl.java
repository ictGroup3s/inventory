package com.example.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.productVO;
import com.example.model.ProductRepository;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Override
    public productVO getProductById(Integer item_no) {
        return productRepository.selectProductById(item_no);
    }

    @Override
    public List<productVO> getAllProducts() {
        return productRepository.selectAllProducts();
    }

    @Override
    public List<productVO> getProducts(Map<String, Object> params) {
        return productRepository.selectProducts(params);
    }

    @Override
    public int getProductsTotal(Map<String, Object> params) {
        return productRepository.selectProductsCount(params);
    }
}
