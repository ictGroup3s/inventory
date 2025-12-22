package com.example.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.service.BsNumVerResult;
import com.example.service.BsNumVerService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/business")
public class BsNumVerController {

	private final BsNumVerService bsNumVerService;

	@GetMapping("/verify")
	public Map<String, Object> verify(@RequestParam("bnum") String bnum) {
		BsNumVerResult result = bsNumVerService.verify(bnum);
		return Map.of(
				"valid", result.isValid(),
				"message", result.getMessage()
		);
	}
}
