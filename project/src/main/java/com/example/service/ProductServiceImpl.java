package com.example.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.vo.ProductVO;
import com.example.model.ProductRepository;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Override
    public ProductVO getProductById(Integer item_no) {
        return productRepository.selectProductById(item_no);
    }

    @Override
    public List<ProductVO> getAllProducts() {
        return productRepository.selectAllProducts();
    }

    @Override
    public List<ProductVO> getProducts(Map<String, Object> params) {
        return productRepository.selectProducts(params);
    }

    @Override
    public int getProductsTotal(Map<String, Object> params) {
        return productRepository.selectProductsCount(params);
    }

    @Override
    public List<ProductVO> getRandomProducts(int limit) {
        return productRepository.selectRandomProducts(limit);
    }
}