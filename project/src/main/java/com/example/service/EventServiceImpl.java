package com.example.service;



import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.EventRepository;
import com.example.model.vo.ProductVO;

@Service
public class EventServiceImpl implements EventService{
	@Autowired
	private EventRepository eventRepository;

	//매서드 구현
	@Override
	public List<ProductVO> getNewArrivals(int size, int offset) {
		Map<String, Object> params = new HashMap<>();
		params.put("size", size);
		params.put("offset", offset);
		return eventRepository.selectNewArrivals(params);
	}

	@Override
	public int getNewArrivalsCount() {
		return eventRepository.selectNewArrivalsCount();
	}

	@Override
	public List<ProductVO> getDiscount(int size, int offset) {
		Map<String, Object> params = new HashMap<>();
		params.put("size", size);
		params.put("offset", offset);
		return eventRepository.selectDiscount(params);
	}
	
	@Override
	public int getDiscountCount() {
		return eventRepository.selectDiscountCount();
	}

}
