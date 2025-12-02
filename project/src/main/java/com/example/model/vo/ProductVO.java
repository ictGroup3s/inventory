package com.example.model.vo;

import lombok.Data;

@Data
public class ProductVO {
	private Integer item_no;
	private String item_img;
	private String item_name;
	private String item_content;
	private Integer origin_p;
	private Integer sales_p;
	private Integer stock_cnt;
	private Integer cate_no;
	private Integer dis_no;
}
