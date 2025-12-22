package com.example.service;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class BsNumVerResult {
	private boolean valid;
	private String message;

	public static BsNumVerResult ok(String message) {
		return new BsNumVerResult(true, message);
	}

	public static BsNumVerResult fail(String message) {
		return new BsNumVerResult(false, message);
	}
}
