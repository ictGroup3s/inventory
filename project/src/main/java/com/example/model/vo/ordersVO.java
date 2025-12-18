package com.example.model.vo;

import java.util.List;

import lombok.Data;

@Data
public class ordersVO {

	private Integer order_no;
	private String order_name;
	private String order_addr;
	private Integer tracking;
	private long order_phone;
	private String order_status;
	private String payment;
	private String api_pay;
	private String order_date;
	private String customer_id;

	// 주문 상세 리스트 추가!
	private List<order_detailVO> detailList;
	private Integer total_amount; 
	private String request;
	
	 // 수령지 정보
    private String shipName;
    private String shipPhone;
    private String shipAddress;
    private String memo;

	public List<order_detailVO> getDetailList() {
	    return detailList;
	}

	public void setDetailList(List<order_detailVO> detailList) {
	    this.detailList = detailList;
	}
	
}
