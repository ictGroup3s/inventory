package com.example.model.vo;

import lombok.Data;

@Data
public class BoardVO {

    private int board_no;
    private String title;
    private String b_content;
    private String b_date;
    private String customer_id;

    
    // FAQ/공지 구분 + FAQ 카테고리  
    
    private String board_type;     // NOTICE / FAQ
    private String faq_category;   // 배송문의, 취소/반품, 결제/영수증, 회원/계정, 상품/재고  
}
