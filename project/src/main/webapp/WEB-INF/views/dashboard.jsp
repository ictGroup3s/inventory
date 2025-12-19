<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>대쉬보드</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<!-- Favicon -->
<link href="img/favicon.ico" rel="icon">

<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">

<!-- Font Awesome -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css"
	rel="stylesheet">

<!-- Bootstrap & Libraries -->
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
	rel="stylesheet">
<link href="lib/owlcarousel/assets/owl.carousel.min.css"
	rel="stylesheet">

<!-- Custom Styles -->
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/stats.css">

</head>
<body
	class="${empty sessionScope.loginUser || sessionScope.loginRole != '1' ? 'hide-content' : ''}">
	<%-- 관리자 아니면 모달 띄우고 페이지 내용 숨김 --%>
	<c:if
		test="${empty sessionScope.loginUser || sessionScope.loginRole != '1'}">
		<div class="admin-overlay"></div>
		<div class="login-modal">
			<div class="lock-icon">🔒</div>
			<h3>로그인이 필요합니다</h3>
			<p>
				관리자 페이지에 접근하려면<br>먼저 로그인해주세요.
			</p>
			<%-- 현재 페이지 이름만 전달 --%>
			<a href="login?redirectURL=dashboard" class="btn-login" style="display: block; text-decoration: none;">로그인</a> 
			<a href="/" class="btn-home" style="display: block; text-decoration: none;">홈으로</a>
		</div>
	</c:if>

	<%-- 관리자일 때만 보이는 실제 내용 --%>
	<div class="admin-content">

		<!-- 로고(왼쪽) -->
		<div class="row align-items-center py-3 px-xl-5"
			style="margin-left: 60px;">
			<div class="col-lg-3 d-none d-lg-block">
				<a href="/" class="text-decoration-none"> <img
					src="img/logo.png" class="logo" />
				</a>
			</div>
	
		
		</div>

		<!-- Main Layout -->
		<div class="container-fluid">
			<div class="row px-xl-5">
				<!-- LEFT SIDEBAR (PC ONLY) -->
				<div class="col-lg-2 d-none d-lg-block">
					<nav class="category-sidebar" id="mainSidebar">
						<h6>관리자 페이지</h6>
						<ul class="nav flex-column">
							<li class="nav-item"><a href="dashboard"
								class="nav-link active">대쉬보드</a></li>
							<li class="nav-item"><a href="item" class="nav-link">상품관리</a></li>
							<li class="nav-item"><a href="stock" class="nav-link">입고/재고관리</a></li>
							<li class="nav-item"><a href="order" class="nav-link">주문관리</a></li>
							<li class="nav-item"><a href="stats" class="nav-link">통계</a></li>
							<li class="nav-item"><a href="mlist" class="nav-link">채팅관리</a></li>
							<li class="nav-item"><a href="board" class="nav-link">고객센터</a></li>
						</ul>
					</nav>
				</div>
				<!-- Dashboard Content -->
				<div class="col-lg-10">
					<!-- Mobile toggler for sidebar -->
					<nav class="navbar navbar-light bg-light d-lg-none">
						<button class="navbar-toggler" type="button"
							data-toggle="collapse" data-target="#sidebarMenu">
							<span class="navbar-toggler-icon"></span>
						</button>
					</nav>
					<div class="collapse bg-white p-3" id="sidebarMenu"></div>

					<!-- dashboard content -->
					<div class="dashboard-content">
						<!-- 상단 영역 -->
						<div class="row mb-4">
							<div class="col-lg-6 col-md-12 mb-3">
								<div class="card h-100">
									<div class="dashboard1">
										<div
											class="d-flex justify-content-between align-items-center mb-2">
											<h5 class="card-title mb-0">주문현황</h5>
											<input type="date" id="orderDatePicker"
												class="form-control form-control-sm" style="width: 150px;">
										</div>
										<p>
											총 주문 건수: <span id="totalOrders">0</span> / 총 매출: ₩<span
												id="totalSales">0</span>
										</p>
										<h6 class="mt-3">고객 주문 목록</h6>
										<table class="table table-sm table-striped">
											<thead>
												<tr>
													<th>고객명</th>
													<th>상품명</th>
													<th>수량</th>
													<th>금액</th>
												</tr>
											</thead>
											<tbody id="recentOrdersBody">
												<!-- JS로 채움 -->
											</tbody>
										</table>
									</div>
								</div>
							</div>

							<div class="col-lg-6 col-md-12">
								<div class="row">
									<div class="col-6 mb-3">
										<a href="/order" class="text-decoration-none text-dark">
											<div class="card h-100">
												<div class="card-body text-center">
													<h6>취소/반품 건수</h6>
													<p id="cancelReturnCount">0</p>

												</div>
											</div>
										</a>
									</div>
									<div class="col-6 mb-3">
										<a href="/stats" class="text-decoration-none text-dark">
											<div class="card h-100">
												<div class="card-body text-center">
													<h6>주문건수</h6>
													<p id="todayOrders">0</p>
												</div>
											</div>
										</a>
									</div>
									<div class="col-6 mb-3">
										<a href="/stats" class="text-decoration-none text-dark">
											<div class="card h-100">
												<div class="card-body text-center">
													<h6>일 매출</h6>
													<p>
														₩<span id="todaySales">0</span>
													</p>
												</div>
											</div>
										</a>
									</div>

									<div class="col-6 mb-3">
										<a href="/stats" class="text-decoration-none text-dark">
											<div class="card h-100">
												<div class="card-body text-center">
													<h6>월 매출</h6>
													<p>
														₩<span id="monthSales">0</span>
													</p>
												</div>
											</div>
										</a>
									</div>

								</div>
							</div>
						</div>

						<!-- 하단 영역 -->
						<div class="row">
							<div class="col-lg-6 col-md-12 mb-3">
								<div class="card h-100">
									<div class="card-body">
										<h5 class="card-title">매출 흐름표</h5>
										<div id="chartWrapSales" style="width: 100%; height: 260px;">
											<canvas id="salesChart"></canvas>
										</div>
									</div>
								</div>
							</div>
							<div class="col-lg-6 col-md-12 mb-3">
								<div class="card h-100">
									<div class="card-body">
										<h5 class="card-title">수입/지출</h5>
										<div id="stockChartWrap" style="width: 100%; height: 260px;">
											<canvas id="stockChart"></canvas>
										</div>
									</div>
								</div>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>


		<!-- JS -->
		<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
		<script
			src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
		<script src="lib/owlcarousel/owl.carousel.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
		<script src="js/main.js"></script>
		<script src="js/dashboard.js"></script>
</body>
</html>