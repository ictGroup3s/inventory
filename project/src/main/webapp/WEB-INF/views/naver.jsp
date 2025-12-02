<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>네이버페이 결제</title>
<link rel="stylesheet" href="/css/payment.css">
</head>
<body class="naver-page">
    <div class="container">
        <h2>네이버페이 결제</h2>
        <p>결제 정보를 확인하세요.</p>

        <!-- 실제 네이버페이 SDK 연동 버튼 위치 -->
        <button class="btn" onclick="completePayment()">
            결제 완료
        </button>
    </div>

    <script>
        function completePayment() {
            // 결제 완료 알림
            alert('결제가 완료되었습니다!');
            // 결제 완료 후 마이페이지로 이동
            window.location.href = '/mypage';
        }
    </script>
</body>
</html>
