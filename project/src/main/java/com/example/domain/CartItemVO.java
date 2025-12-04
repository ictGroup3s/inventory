package com.example.domain;

import lombok.Data;

@Data
public class CartItemVO {

    private productVO product;
    private int qty;

    public CartItemVO() {}

    public CartItemVO(productVO product, int qty) {
        this.product = product;
        this.qty = qty;
    }

    public int getSubtotal() {
        if (product == null || product.getSales_p() == null) return 0;
        return product.getSales_p() * qty;
    }
}
