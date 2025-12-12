package com.example.model.vo;

import lombok.Data;

@Data
public class order_detailVO {
	private Integer detail_no;
	private Integer order_no;
	private Integer item_no;
	private Integer item_cnt;
	private Integer item_price;
	
	private String item_name;
	private String order_date;
	private String order_status;
	
	private Integer amount;	
	
}
