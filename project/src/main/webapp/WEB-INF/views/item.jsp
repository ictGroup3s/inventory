<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>상품등록</title>
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
<!-- jQuery CDN (최신 버전) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- main.js -->
<script src="/js/main.js"></script>
<script src="/js/admin.js"></script>

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
			<a href="${pageContext.request.contextPath}/login" class="btn-login"
				style="display: block; text-decoration: none;">로그인</a>
		</div>
	</c:if>

	<%-- 관리자일 때만 보이는 실제 내용 --%>
	<div class="admin-content">
		<!-- 기존 관리자 페이지 내용 -->

		<!-- Topbar -->
		<div class="row align-items-center py-3 px-xl-5 bg-light">
			<div class="col-lg-3 d-none d-lg-block">
				<a href="/" class="text-decoration-none"> <img
					src="img/logo.png" class="logo" />
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
				<div class="col-lg-2 ">
					<!-- Sidebar -->
					<nav class="category-sidebar">
						<h6>관리자 페이지</h6>
						<ul class="nav flex-column">
							<li class="nav-item"><a href="dashboard" class="nav-link">대쉬보드</a></li>
							<li class="nav-item"><a href="item" class="nav-link active">상품관리</a></li>
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
						<button class="navbar-toggler" type="button"
							data-toggle="collapse" data-target="#sidebarMenu">
							<span class="navbar-toggler-icon"></span>
						</button>
					</nav>

					<div class="container-fluid py-5 px-0">

						<!-- 상품 등록 영역 -->
						<div class="row px-xl-0">
							<!-- 좌측: 상품 이미지 -->
							<div class="col-lg-5 pb-5 text-center">
								<img id="preview" src="img/insert_pic.png" alt="상품 이미지"
									class="img-fluid" style="width: 600px; height: 500px;">
							</div>

							<!-- 우측: 상품 등록 폼 -->
							<div class="col-lg-7 pb-5">
								<h3 class="font-weight-semi-bold mb-4">상품관리</h3>

								<form action="saveItem" method="post"
									enctype="multipart/form-data">
									<input type="hidden" name="item_no">
									<!-- 상품 정보 입력 테이블 -->
									<table class="table table-bordered">
										<tr>
											<td>상품명</td>
											<td><input type="text"
												class="form-control required-field" name="item_name"
												placeholder="상품명"> <small
												class="error-msg text-danger d-none">필수 입력 항목입니다.</small></td>
										</tr>

										<tr>
											<td>수량</td>
											<td><input type="number"
												class="form-control required-field" name="stock_cnt"
												placeholder="수량"> <small
												class="error-msg text-danger d-none">필수 입력 항목입니다.</small></td>
										</tr>

										<tr>
											<td>카테고리</td>
											<td><select class="form-control required-field"
												name="cate_no">
													<option value="">선택하세요</option>
													<option value="1">구이찜볶음</option>
													<option value="2">국밥면</option>
													<option value="3">식단관리</option>
													<option value="4">분식간식</option>
													<option value="5">반찬소스</option>
													<option value="6">생수음료</option>
											</select> <small class="error-msg text-danger d-none">필수 입력
													항목입니다.</small></td>
										</tr>

										<tr>
											<td>원가</td>
											<td><input type="number"
												class="form-control required-field" name="origin_p"
												placeholder="원가"> <small
												class="error-msg text-danger d-none">필수 입력 항목입니다.</small></td>
										</tr>

										<tr>
											<td>판매가</td>
											<td><input type="number"
												class="form-control required-field" name="sales_p"
												placeholder="판매가"> <small
												class="error-msg text-danger d-none">필수 입력 항목입니다.</small></td>
										</tr>

										<tr>
											<td>이미지 업로드</td>
											<td><input type="file" id="uploadFile"
												class="form-control required-field" name="item_imgFile">
												<small class="error-msg text-danger d-none">필수 입력
													항목입니다.</small></td>
										</tr>

										<tr>
											<td>상품 상세설명</td>
											<td><textarea class="form-control required-field"
													name="item_content" rows="6" placeholder="상품 상세설명을 입력하세요"></textarea>
												<small class="error-msg text-danger d-none">필수 입력
													항목입니다.</small></td>
										</tr>
										<tr>
											<td>할인률</td>
											<td>
												<div class="input-group">
													<input type="number" class="form-control required-field"
														name="dis_rate" placeholder="할인률" aria-label="할인률">
													<div class="input-group-append">
														<span class="input-group-text">%</span>
													</div>
												</div> <small class="error-msg text-danger d-none">필수 입력
													항목입니다.</small>
											</td>
										</tr>
									</table>

									<!-- 등록/수정/삭제 버튼 -->
									<div class="d-flex align-items-center mb-4 pt-2">
										<button class="btn btn-primary mr-2 submit-btn register">등록</button>
										<button class="btn btn-warning mr-2 submit-btn update"
											formaction="/itemUpdate">수정</button>

									</div>
								</form>
							</div>
						</div>
						<!-- 상품 등록 row 끝 -->

						<!-- 상품 목록 테이블 영역 -->
						<div class="row px-xl-5 mt-4">
							<div class="col-lg-12">
								<div
									class="d-flex justify-content-between align-items-center mb-3">
									<h4 class="mb-0">등록된 상품 목록</h4>
									<div class="d-flex">
										<input type="text" id="itemSearch" class="form-control mr-2"
											placeholder="상품명 검색" style="width: 200px;"> <select
											id="categoryFilter" class="form-control"
											style="width: 200px;">
											<option value="">전체 카테고리</option>
											<option value="1">구이찜볶음</option>
											<option value="2">국밥면</option>
											<option value="3">식단관리</option>
											<option value="4">분식간식</option>
											<option value="5">반찬소스</option>
											<option value="6">생수음료</option>
										</select>
									</div>
								</div>
								<!-- 상품 목록 테이블: 가로 전체(w-100) -->
								<table class="table table-bordered w-100">
									<thead class="thead-light">
										<tr>
											<th>상품코드</th>
											<th>상품명</th>
											<th>카테고리</th>
											<th>원가</th>
											<th>소비자가</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${list}" var="item">
											<tr class="item-row" data-item_no="${item.item_no}"
												data-item_name="${item.item_name}"
												data-origin_p="${item.origin_p}"
												data-sales_p="${item.sales_p}"
												data-cate_no="${item.cate_no}"
												data-stock_cnt="${item.stock_cnt}"
												data-item_content="${item.item_content}"
												data-item_img="${item.item_img}"
												data-dis_rate="${item.dis_rate }">
												<td>${item.item_no}</td>
												<td>${item.item_name}</td>
												<td>${item.cate_name}</td>
												<td>${item.origin_p}</td>
												<td>${item.sales_p}</td>
												<td><button class="btn btn-danger delete-btn"
														data-itemno="${item.item_no}">삭제</button></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
						<!-- 상품 목록 row 끝 -->

					</div>
					<!-- container-fluid 끝 -->
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
	</div>
	<!-- JS -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="lib/owlcarousel/owl.carousel.min.js"></script>
	<script src="js/main.js"></script>

	<div id="toast"></div>

</body>
</html>