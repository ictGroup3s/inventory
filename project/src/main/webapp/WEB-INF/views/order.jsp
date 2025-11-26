<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>주문관리</title>
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

<!-- Custom Styles -->
<link rel="stylesheet" href="css/style.css">

</head>
<body>

<!-- Topbar (기존 코드 그대로) -->
<div class="row align-items-center py-3 px-xl-5 bg-light">
	<div class="col-lg-3 d-none d-lg-block">
		<a href="/" class="text-decoration-none">
			<img src="img/logo.png" class="logo" />
		</a>
	</div>
	<div class="col-lg-6 col-6 text-left">
		<form action="">
			<div class="input-group">
				<input type="text" class="form-control" placeholder="Search for products">
				<div class="input-group-append">
					<span class="input-group-text bg-transparent text-primary">
						<i class="fa fa-search"></i>
					</span>
				</div>
			</div>
		</form>
	</div>
	<div class="col-lg-3 col-6 text-right">
		<a href="#" class="btn border"><i class="fas fa-heart text-primary"></i> <span class="badge">0</span></a>
		<a href="cart" class="btn border"><i class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span></a>
	</div>
</div>

<!-- Main Layout -->
<div class="container-fluid">
	<div class="row">
		<!-- Sidebar (기존 .admin-sidebar 그대로) -->
		<nav id="sidebarMenu" class="col-lg-2 d-lg-block bg-light sidebar admin-sidebar collapse">
			<h6 class="p-3">관리자 페이지</h6>
			<ul class="nav flex-column">
				<li class="nav-item"><a href="dashboard" class="nav-link">대쉬보드</a></li>
				<li class="nav-item"><a href="item" class="nav-link">상품관리</a></li>
				<li class="nav-item"><a href="stock" class="nav-link">입고/재고관리</a></li>
				<li class="nav-item"><a href="order" class="nav-link active">주문관리</a></li>
				<li class="nav-item"><a href="stats" class="nav-link">통계</a></li>
				<li class="nav-item"><a href="mlist" class="nav-link">고객관리</a></li>
			</ul>
		</nav>

		<!-- Content -->
		<div class="col-lg-10 dashboard-content">
			<h3 class="mb-4">주문관리</h3>

			<!-- 주문 검색 -->
			<form class="form-inline mb-3">
				<input type="text" class="form-control mr-2" placeholder="주문번호 검색">
				<input type="text" class="form-control mr-2" placeholder="고객명 검색">
				<button type="submit" class="btn btn-primary">검색</button>
			</form>

			<!-- 주문 목록 테이블 -->
			<div class="table-responsive">
				<table class="table table-bordered">
					<thead class="thead-light">
						<tr>
							<th>주문번호</th>
							<th>고객명</th>
							<th>상품명</th>
							<th>수량</th>
							<th>총 금액</th>
							<th>주문일</th>
							<th>상태</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>ORD001</td>
							<td>홍길동</td>
							<td>연어</td>
							<td>2</td>
							<td>20,000</td>
							<td>2025-11-25</td>
							<td>배송중</td>
							<td><button class="btn btn-sm btn-info">상세보기</button></td>
						</tr>
						<tr>
							<td>ORD002</td>
							<td>김철수</td>
							<td>참치</td>
							<td>1</td>
							<td>18,000</td>
							<td>2025-11-24</td>
							<td>배송완료</td>
							<td><button class="btn btn-sm btn-info">상세보기</button></td>
						</tr>
						<tr>
							<td>ORD003</td>
							<td>이영희</td>
							<td>광어</td>
							<td>3</td>
							<td>42,000</td>
							<td>2025-11-23</td>
							<td>취소</td>
							<td><button class="btn btn-sm btn-info">상세보기</button></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
<script src="lib/owlcarousel/owl.carousel.min.js"></script>
<script src="js/main.js"></script>

</body>
</html>

