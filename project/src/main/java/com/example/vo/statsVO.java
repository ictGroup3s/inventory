package com.example.vo;

import lombok.Data;

@Data
public class statsVO {

	private Integer stats_id;
	private String stats_date;
	private Integer total_order;
	private Integer total_sales;
	private Integer cancel_cnt;
	private Integer return_cnt;
	private Integer total_price;
	private Integer margin;
	private Integer total_discount;
	private Integer store_no;
}
