<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
</head>
<meta charset="utf-8">
<title>결제정보</title>
<body>

	<div class="container mt-5">
		<h3>결제 정보</h3>
		<hr>

		<div class="payment-info">
			<p>
				<strong>선택한 카드사:</strong> <span id="cardType"></span>
			</p>
			<p>
				<strong>결제 금액:</strong> <span id="amount"></span>원
			</p>
		</div>

		<button class="btn btn-primary" onclick="processPayment()">결제하기</button>
		<button class="btn btn-secondary" onclick="goBack()">취소</button>
	</div>

	<script>
        // 페이지 로드시 세션스토리지에서 데이터 가져오기
        window.onload = function() {
            const selectedCard = sessionStorage.getItem('selectedCard');
            const amount = sessionStorage.getItem('amount');
            
            // 데이터가 있으면 표시
            if (selectedCard && amount) {
                document.getElementById('cardType').innerText = selectedCard;
                document.getElementById('amount').innerText = amount;
            } else {
                alert('카드를 선택해주세요.');
                window.location.href = '/checkout'; // 카드 선택 페이지로 이동
            }
        }
        
        function processPayment() {
            const selectedCard = sessionStorage.getItem('selectedCard');
            const amount = sessionStorage.getItem('amount');
            
            // 결제 처리 로직
            alert(selectedCard + ' 카드로 ' + amount + '원 결제가 완료되었습니다!');
            
            // 결제 완료 후 세션스토리지 삭제
            sessionStorage.removeItem('selectedCard');
            sessionStorage.removeItem('amount');
            
            // 주문 완료 페이지로 이동
            window.location.href = '/orderComplete';
        }
        
        function goBack() {
            // 취소시 세션스토리지 삭제
            sessionStorage.removeItem('selectedCard');
            sessionStorage.removeItem('amount');
            
            window.location.href = '/checkout';
        }
    </script>

</body>
</html>