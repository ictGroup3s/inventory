<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>주문내역</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<!-- Favicon -->
<link href="img/favicon.ico" rel="icon">

<!-- Google Web Fonts -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">

<!-- Font Awesome -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css"
	rel="stylesheet">
	<!-- ⭐ Bootstrap CSS -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">

<!-- Customized Bootstrap Stylesheet -->
<link href="css/style.css" rel="stylesheet">
</head>

<body>
	<div class="row align-items-center py-3 px-xl-5">
		<div class="col-lg-3 d-none d-lg-block">
			<a href="/" class="text-decoration-none"> <img
				src="\img\logo.png" class='logo' />
			</a>
		</div>
		<div class="col-lg-6 col-6 text-left">
			<form action="">
				<div class="input-group">
					<input type="text" class="form-control"
						placeholder="Search for products">
					<div class="input-group-append">
						<span class="input-group-text bg-transparent text-primary">
							<i class="fa fa-search"></i>
						</span>
					</div>
				</div>
			</form>
		</div>
		<div class="col-lg-3 col-6 text-right">
			<a href="" class="btn border"> <i
				class="fas fa-heart text-primary"></i> <span class="badge">0</span>
			</a> <a href="cart" class="btn border"> <i
				class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span>
			</a>
		</div>
	</div>
	<!-- Main Layout -->
	<div class="container-fluid">
		<div class="row px-xl-5">
			<div class="col-lg-2">
				<!-- Sidebar -->
				<nav class="category-sidebar">
					<h6>마이페이지</h6>
					<ul class="nav flex-column">
					<li class="nav-item"><a href="/mypage" class="nav-link">모든내역</a></li>
						<li class="nav-item"><a href="/orderhistory" class="nav-link active">주문내역</a></li>
						<li class="nav-item"><a href="/mydelivery" class="nav-link">배송내역</a></li>
						<li class="nav-item"><a href="/mycs" class="nav-link ">취소·반품·교환내역</a></li>
						<li class="nav-item"><a href="/update" class="nav-link">내정보수정</a></li>
						<li class="nav-item"><a href="/delete" class="nav-link">회원탈퇴</a></li>
					</ul>
				</nav>
			</div>


			<!-- Main Content -->
			<div class="col-lg-10" style="margin-top: -30px; margin-bottom: 50px;">
				<div class="text-center mb-4">
					<h4 style="margin-top:50px;">주문내역</h4>
					<span class="ml-2 text-muted"style="margin-right:970px;"> 총 <strong id="totalCount">0</strong>건
					</span>
				</div>
				<!-- ⭐ 기간 필터 섹션 ⭐ -->
				<div class="filter-bar d-flex align-items-center mb-3">
					<!-- 날짜 직접 선택 -->
					<input type="date" id="startDate" class="form-control mr-2"
						style="width: 160px;"> <span class="mr-2">~</span> <input
						type="date" id="endDate" class="form-control mr-3"
						style="width: 160px;">
						
					<button type="button"
					class="btn btn-outline-primary btn-sm" 
					onclick="filterByDateRange()">조회</button>
				</div>
				<table class="table table-striped">
						<thead>
							<tr>
								<th>주문번호</th>
								<th>상품명</th>
								<th>결제금액</th>
								<th>주문상태</th>
								<th>주문일시</th>
							</tr>
						</thead>
					<tbody id="orderTableBody">
						<c:choose>
							<c:when test="${empty deliveryList}">
								<tr>
									<td colspan="5" class="text-center">주문 내역이 없습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="detail" items="${deliveryList}">
									<tr class="order-row" data-order-date="${detail.order_date}"
										data-status="${detail.order_status}">

										<td>${detail.order_no}</td>
										<td>${detail.item_name}</td>
										<td><fmt:formatNumber value="${detail.item_price}"
												pattern="#,###" />원</td>
										<td>
										<span class="badge 
						                        ${detail.order_status == '결제완료' ? 'badge-success' : 
						                          detail.order_status == '배송준비중' ? 'badge-warning' : 
						                          detail.order_status == '배송중' ? 'badge-info' : 
						                          detail.order_status == '배송완료' ? 'badge-secondary' : 'badge-light'}">
												${detail.order_status} 
										</span>
										</td>
										<td>${detail.order_date}</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>

				<!-- 검색 결과 없음 메시지 -->
				<div id="noResultMessage" class="text-center py-4" style="display: none;">
					<i class="fas fa-search fa-3x text-muted mb-3"></i>
					<p class="text-muted">조회 결과가 없습니다.</p>
				</div>
			</div>
		</div>
	</div>
	<!-- Footer -->
	<div class="container-fluid bg-secondary text-dark mt-5 pt-5" style="margin-top: 550px !important;">
		<div class="row px-xl-5 pt-5">
			<div class="col-lg-4 col-md-12 mb-3 pr-3 pr-xl-3 pl-3 pl-xl-5 pt-3">
				<p class="mb-2"><i class="fa fa-map-marker-alt text-primary mr-3"></i>123 Street, Seoul, KOREA</p>
				<p class="mb-2"><i class="fa fa-envelope text-primary mr-3"></i>stockbob@stockbob.com</p>
				<p><i class="fa fa-phone-alt text-primary mr-3"></i>평일 [월~금] 오전 9시30분~5시30분</p>
				<h2 class="mb-0">
					<i class="fa fa-phone-alt text-primary mr-3"></i>+02 070 0000
				</h2>
			</div>
			<div class="col-lg-8 col-md-12">
				<div class="row">
					<div class="col-md-4 mb-3">
						<h5 class="font-weight-bold text-dark mt-4 mb-4">Quick Links</h5>
						<div class="d-flex flex-column justify-content-start">
							<a class="text-dark mb-2" href="/"><i class="fa fa-angle-right mr-2"></i>메인 홈</a>
							<a class="text-dark mb-2" href="selectall"><i class="fa fa-angle-right mr-2"></i>상품페이지로 이동</a>
							<a class="text-dark mb-2" href="mlist"><i class="fa fa-angle-right mr-2"></i>마이페이지</a>
							<a class="text-dark mb-2" href="cart"><i class="fa fa-angle-right mr-2"></i>장바구니</a>
							<a class="text-dark mb-2" href="checkout"><i class="fa fa-angle-right mr-2"></i>결제</a>
						</div>
					</div>
					<div class="col-lg-8 col-md-12">
						<div class="row">
							<div class="col-md-12 mt-4 mb-5">
								<p class="text-dark mb-2">
									<span>stockbob 소개</span> &nbsp;&nbsp; | &nbsp;&nbsp;
									<span>이용약관</span> &nbsp; | &nbsp;
									<span>개인정보처리방침</span> &nbsp; | &nbsp;
									<span>이용안내</span>
								</p><br>
								<p style="color: #999;">
									법인명 (상호) : 주식회사 STOCKBOB<br>
									사업자등록번호 : 000-11-00000<br>
									통신판매업 : 제 2025-서울-11111 호<br>
									주소 : 서울특별시 서대문구 신촌동 00<br>
									채용문의 : ict.atosoft.com<br>
									팩스 : 070-0000-0000
								</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row border-top border-light mx-xl-5 py-4">
			<div class="col-md-6 px-xl-0">
				<p class="mb-md-0 text-center text-md-left text-dark">
					&copy; <a class="text-dark font-weight-semi-bold" href="#">Your Site Name</a>. All Rights Reserved.
				</p>
			</div>
			<div class="col-md-6 px-xl-0 text-center text-md-right">
				<img class="img-fluid" src="img/payments.png" alt="">
			</div>
		</div>
	</div>
	<!-- ⭐⭐⭐ JavaScript Libraries ⭐⭐⭐ -->
	<script>
    window.hasOrderList = ${not empty deliveryList};
</script>
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="js/checkout.js"></script>

			
</body>
</html>