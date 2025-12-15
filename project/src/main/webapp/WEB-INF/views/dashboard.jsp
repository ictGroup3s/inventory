<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<body>

	<!-- Topbar -->
	<div class="row align-items-center py-3 px-xl-5 bg-light">
		<div class="col-lg-3 d-none d-lg-block">
			<a href="/" class="text-decoration-none"> <img src="img/logo.png"
				class="logo" />
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
			<a href="#" class="btn border"> <i
				class="fas fa-heart text-primary"></i> <span class="badge">0</span>
			</a> <a href="cart" class="btn border"> <i
				class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span>
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
						<li class="nav-item"><a href="mlist" class="nav-link">고객관리</a></li>
						<li class="nav-item"><a href="board" class="nav-link">고객센터</a></li>
					</ul>
				</nav>
			</div>
			<!-- Dashboard Content -->
			<div class="col-lg-10">
				<!-- Mobile toggler for sidebar -->
				<nav class="navbar navbar-light bg-light d-lg-none">
					<button class="navbar-toggler" type="button" data-toggle="collapse"
						data-target="#sidebarMenu">
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
									<div class="card h-100">
										<div class="card-body text-center">
											<h6>신규 회원</h6>
											<p id="newMembers">0</p>
										</div>
									</div>
								</div>
								<div class="col-6 mb-3">
									<div class="card h-100">
										<div class="card-body text-center">
											<h6>주문건수</h6>
											<p id="todayOrders">0</p>
										</div>
									</div>
								</div>
								<div class="col-6 mb-3">
									<div class="card h-100">
										<div class="card-body text-center">
											<h6>일 매출</h6>
											<p>
												₩<span id="todaySales">0</span>
											</p>
										</div>
									</div>
								</div>
								<div class="col-6 mb-3">
									<div class="card h-100">
										<div class="card-body text-center">
											<h6>월 매출</h6>
											<p>
												₩<span id="monthSales">0</span>
											</p>
										</div>
									</div>
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

	<!-- Footer -->
	<div class="container-fluid bg-secondary text-dark mt-5 pt-5">
		<div class="row px-xl-5 pt-5">
			<div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
				<a href="#" class="text-decoration-none">
					<h1 class="mb-4 display-5 font-weight-semi-bold">
						<span
							class="text-primary font-weight-bold border border-white px-3 mr-1">E</span>Shopper
					</h1>
				</a>
				<p>Dolore erat dolor sit lorem vero amet. Sed sit lorem magna,
					ipsum no sit erat lorem et magna ipsum dolore amet erat.</p>
			</div>
			<div class="col-lg-8 col-md-12">
				<div class="row">
					<div class="col-md-4 mb-5">
						<h5 class="font-weight-bold text-dark mb-4">Quick Links</h5>
						<div class="d-flex flex-column justify-content-start">
							<a class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Home</a> <a
								class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Our Shop</a>
						</div>
					</div>
					<div class="col-md-4 mb-5">
						<h5 class="font-weight-bold text-dark mb-4">Quick Links</h5>
						<div class="d-flex flex-column justify-content-start">
							<a class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Shop Detail</a> <a
								class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Shopping Cart</a>
						</div>
					</div>
					<div class="col-md-4 mb-5">
						<h5 class="font-weight-bold text-dark mb-4">Newsletter</h5>
						<form action="">
							<input type="text" class="form-control mb-2"
								placeholder="Your Name" required> <input type="email"
								class="form-control mb-2" placeholder="Your Email" required>
							<button class="btn btn-primary btn-block" type="submit">Subscribe</button>
						</form>
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