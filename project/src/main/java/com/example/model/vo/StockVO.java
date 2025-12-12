package com.example.model.vo;

import lombok.Data;

@Data
public class StockVO {

	private Integer stock_no;	//입출고번호
	private Integer stock;		//재고
	private Integer stock_in; 	//입고
	private Integer stock_out;	//출고
	private String in_date;		//등록일자
	private Integer item_no;	//상품번호
	private Integer order_no;	//주문번호
	
}
