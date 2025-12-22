package com.example.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BsNumVerServiceImpl implements BsNumVerService {

	@Value("${business.verify.remote.enabled:false}")
	private boolean remoteEnabled;

	@Value("${business.verify.remote.url:}")
	private String remoteUrl;

	@Value("${business.verify.remote.key:}")
	private String remoteKey;

	@Override
	public BsNumVerResult verify(String businessNumber) {
		String normalized = normalizeDigits(businessNumber);
		if (normalized == null || normalized.isBlank()) {
			return BsNumVerResult.fail("사업자번호를 입력해주세요.");
		}
		if (normalized.length() != 10) {
			return BsNumVerResult.fail("사업자번호는 숫자 10자리여야 합니다.");
		}
		if (!normalized.chars().allMatch(Character::isDigit)) {
			return BsNumVerResult.fail("사업자번호는 숫자만 입력 가능합니다.");
		}

		// 1) 로컬 체크섬 검증(형식 검증)
		if (!isValidChecksum(normalized)) {
			return BsNumVerResult.fail("사업자번호 형식이 올바르지 않습니다.");
		}

		// 2) (선택) 외부(ODcloud) 인증 API 연동
		// - POST only
		// - serviceKey, returnType are query params
		// - b_no is JSON body
		if (remoteEnabled) {
			if (remoteUrl == null || remoteUrl.isBlank()) {
				return BsNumVerResult.fail("사업자번호 인증 URL 설정이 필요합니다.");
			}
			if (remoteKey == null || remoteKey.isBlank()) {
				return BsNumVerResult.fail("사업자번호 인증키 설정이 필요합니다.");
			}
			try {
				RestTemplate rest = new RestTemplate();
				HttpHeaders headers = new HttpHeaders();
				headers.setContentType(MediaType.APPLICATION_JSON);
				headers.setAccept(List.of(MediaType.APPLICATION_JSON));

				String url = UriComponentsBuilder.fromHttpUrl(remoteUrl)
						.queryParam("serviceKey", remoteKey)
						.queryParam("returnType", "JSON")
						.build(true)
						.toUriString();

				Map<String, Object> payload = Map.of("b_no", List.of(normalized));
				HttpEntity<Map<String, Object>> req = new HttpEntity<>(payload, headers);
				ResponseEntity<String> res = rest.postForEntity(url, req, String.class);
				if (res.getStatusCode().is2xxSuccessful()) {
					String body = res.getBody();
					if (body == null || body.isBlank()) {
						return BsNumVerResult.fail("사업자번호 인증 응답이 비어있습니다.");
					}

					ObjectMapper om = new ObjectMapper();
					JsonNode root = om.readTree(body);
					String statusCode = textOrNull(root.get("status_code"));
					if (!"OK".equalsIgnoreCase(statusCode)) {
						return BsNumVerResult.fail("사업자번호 인증에 실패했습니다.");
					}

					JsonNode data = root.get("data");
					if (data == null || !data.isArray() || data.isEmpty()) {
						return BsNumVerResult.fail("사업자번호 조회 결과가 없습니다.");
					}
					JsonNode item = data.get(0);
					String taxType = textOrNull(item.get("tax_type"));
					String bSttCd = textOrNull(item.get("b_stt_cd"));
					if (taxType != null && taxType.contains("국세청에 등록되지")) {
						return BsNumVerResult.fail("국세청에 등록되지 않은 사업자등록번호입니다.");
					}
					if (bSttCd == null || bSttCd.isBlank()) {
						return BsNumVerResult.fail("사업자등록 상태를 확인할 수 없습니다.");
					}
					return BsNumVerResult.ok("사업자번호 상태조회 완료");
				}
				log.warn("Remote business verify non-2xx. status={}", res.getStatusCode());
				return BsNumVerResult.fail("사업자번호 인증에 실패했습니다.");
			} catch (RestClientException e) {
				log.warn("Remote business verify failed: {}", e.getMessage());
				return BsNumVerResult.fail("사업자번호 인증 API 호출에 실패했습니다.");
			} catch (Exception e) {
				log.warn("Remote business verify parse failed: {}", e.getMessage());
				return BsNumVerResult.fail("사업자번호 인증 응답 처리에 실패했습니다.");
			}
		}

		return BsNumVerResult.ok("사업자번호 형식 확인 완료");
	}

	private static String normalizeDigits(String value) {
		if (value == null) return null;
		return value.replaceAll("[^0-9]", "");
	}

	// 대한민국 사업자등록번호 체크섬 검증(10자리)
	private static boolean isValidChecksum(String bnum10) {
		try {
			int[] w = { 1, 3, 7, 1, 3, 7, 1, 3, 5 };
			int sum = 0;
			int[] d = new int[10];
			for (int i = 0; i < 10; i++) d[i] = bnum10.charAt(i) - '0';
			for (int i = 0; i < 9; i++) sum += d[i] * w[i];
			sum += (d[8] * 5) / 10;
			int check = (10 - (sum % 10)) % 10;
			return check == d[9];
		} catch (Exception e) {
			return false;
		}
	}

	private static String textOrNull(JsonNode node) {
		if (node == null || node.isNull()) return null;
		String s = node.asText();
		return (s == null) ? null : s;
	}
}
