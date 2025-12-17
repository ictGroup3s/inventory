<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>주문 완료</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<!-- Favicon -->
<link href="img/favicon.ico" rel="icon">

<!-- Google Web Fonts -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

<!-- Customized Bootstrap Stylesheet -->
<link href="css/style.css" rel="stylesheet">
<link href="css/payment.css" rel="stylesheet">

</head>

<body>

	<!-- Main Content -->
	<div class="container complete-container">
		<div class="complete-box">
			<div class="check-icon">
				<i class="fas fa-check-circle"></i>
			</div>
			<h2>결제가 완료되었습니다!</h2>
			<p>주문해 주셔서 감사합니다.<br>주문 내역은 마이페이지에서 확인하실 수 있습니다.</p>
			
			<div class="btn-group">
				<a href="/" class="btn btn-custom btn-home">
					<i class="fas fa-home mr-2"></i>홈으로
				</a>
				<a href="/mypage" class="btn btn-custom btn-order">
					<i class="fas fa-list mr-2"></i>주문내역 보기
				</a>
			</div>
		</div>
	</div>
	<!-- Back to Top -->
	<a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>

	<!-- JavaScript Libraries -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
</body>
</html>