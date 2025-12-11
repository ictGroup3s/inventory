package com.example.model.vo;

import java.util.List;

import lombok.Data;

@Data
public class ordersVO {

	private Integer order_no;
	private String order_name;
	private String order_addr;
	private Integer tracking;
	private Integer order_phone;
	private String order_status;
	private String payment;
	private String api_pay;
	private String order_date;
	private String customer_id;

	// 주문 상세 리스트 추가!
	private List<order_detailVO> detailList;
}
