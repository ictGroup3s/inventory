<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>입고관리</title>
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
			<a href="login?redirectURL=stock" class="btn-login"
				style="display: block; text-decoration: none;">로그인</a> <a
				href="${pageContext.request.contextPath}/" class="btn-home"
				style="display: block; text-decoration: none;">홈으로</a>
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
				<form action="selectall" method="get">
					<div class="input-group">
						<input type="text" name="q" class="form-control"
							placeholder="찾고 싶은 상품을 검색하세요." value="${q}">
						<div class="input-group-append">
							<button class="input-group-text bg-transparent text-primary"
								type="submit">
								<i class="fa fa-search"></i>
							</button>
						</div>
					</div>
				</form>
			</div>
			<div class="col-lg-3 col-6 text-right">
				<a href="#" class="btn border"><i
					class="fas fa-heart text-primary"></i> <span class="badge">0</span></a>
				<a href="cart" class="btn border"><i
					class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span></a>
			</div>
		</div>

		<!-- Main Layout -->
		<div class="container-fluid">
			<div class="row px-xl-5">
				<div class="col-lg-1 ">
					<!-- Sidebar -->
					<nav class="category-sidebar">
						<h6>관리자 페이지</h6>
						<ul class="nav flex-column">
							<li class="nav-item"><a href="dashboard" class="nav-link">대쉬보드</a></li>
							<li class="nav-item"><a href="item" class="nav-link">상품관리</a></li>
							<li class="nav-item"><a href="stock" class="nav-link active">입고/재고관리</a></li>
							<li class="nav-item"><a href="order" class="nav-link">주문관리</a></li>
							<li class="nav-item"><a href="stats" class="nav-link">통계</a></li>
							<li class="nav-item"><a href="mlist" class="nav-link">채팅관리</a></li>
							<li class="nav-item"><a href="board" class="nav-link">고객센터</a></li>
						</ul>
					</nav>
				</div>
				<!-- Content -->
				<div class="col-lg-11">
					<!-- Mobile toggler for sidebar -->
					<nav class="navbar navbar-light bg-light d-lg-none">
						<button class="navbar-toggler" type="button"
							data-toggle="collapse" data-target="#sidebarMenu">
							<span class="navbar-toggler-icon"></span>
						</button>
					</nav>

					<div class="container-fluid py-5 px-0">

						<!-- 상품 등록 영역 -->
						<div class="container py-5">

							<div class="row" style="align-items: flex-start;">

								<!-- 좌측: 상품 이미지 -->
								<div class="col-lg-5 d-flex justify-content-start"
									style="padding-left: 0;">
									<img id="preview" src="img/insert_pic.png" alt="상품 이미지"
										class="img-fluid"
										style="max-width: 350px; height: auto; margin-top: 70px;">
								</div>

								<!-- 우측: 상품 등록 폼 -->
								<div class="col-lg-7">
									<h3 class="font-weight-semi-bold mb-4">상품입고</h3>

									<!-- 재고 부족 경고 -->
									<div id="stockWarning"
										class="alert alert-warning align-items-center"
										style="display: none;">
										<i class="fas fa-exclamation-triangle mr-2"></i> <span>재고가
											10개 미만입니다! 입고가 필요합니다.</span>
									</div>

									<form action="updateStock" method="post">
										<!-- 상품 정보 입력 테이블 -->
										<table class="table table-bordered mx-auto"
											style="max-width: 600px;">
											<tr>
												<td>상품코드</td>
												<td><input type="number" class="form-control"
													name="item_no" id="item_no" placeholder="상품코드" readonly></td>
											</tr>
											<tr>
												<td>상품명</td>
												<td><input type="text" class="form-control"
													name="item_name" id="item_name" placeholder="상품명" readonly></td>
											</tr>
											<tr>
												<td>원가</td>
												<td><input type="number" class="form-control"
													name="origin_p" id="origin_p" placeholder="원가" readonly></td>
											</tr>
											<tr>
												<td>소비자가</td>
												<td><input type="number" class="form-control"
													name="sales_p" id="sales_p" placeholder="소비자가" readonly></td>
											</tr>
											<tr>
												<td>현재 재고</td>
												<td><input type="number" class="form-control"
													id="current_stock" placeholder="현재 재고" readonly
													style="background-color: #f8f9fa;"></td>
											</tr>
											<tr>
												<td>수량 조정</td>
												<td>
													<div class="d-flex align-items-center">
														<button type="button"
															class="btn btn-outline-secondary stock-adjust-btn"
															id="minusBtn">−</button>
														<input type="number" class="form-control mx-2 text-center"
															id="adjust_qty" value="0" style="width: 80px;">
														<button type="button"
															class="btn btn-outline-secondary stock-adjust-btn"
															id="plusBtn">+</button>
														<span class="ml-3" id="adjustLabel"
															style="font-size: 14px;"></span>
													</div>
												</td>
											</tr>
											<tr>
												<td>변경 후 재고</td>
												<td><input type="number" class="form-control"
													name="stock_cnt" id="new_stock" placeholder="변경 후 재고"
													readonly
													style="background-color: #fff3cd; border-color: #ffc107;">
												</td>
											</tr>
										</table>

										<!-- 버튼 -->
										<div class="d-flex align-items-center mb-4 pt-2">
											<button class="btn btn-primary mr-2" type="submit"
												id="stockSubmitBtn" disabled>재고 수정</button>
											<button class="btn btn-secondary" type="button" id="resetBtn">초기화</button>
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
										<h4 class="mb-0">상품 목록</h4>
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
									<div class="stock-table-wrapper">
										<table class="table table-bordered w-100 stock-table">
											<thead class="thead-light text-center">
												<tr>
													<th class="item_no">상품코드</th>
													<th>상품명</th>
													<th>카테고리</th>
													<th>원가</th>
													<th>재고수량</th>
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
														data-item_img="${item.item_img}">
														<td>${item.item_no}</td>
														<td class="item_name">${item.item_name}</td>
														<td>${item.cate_name}</td>
														<td>${item.origin_p}</td>
														<td><c:choose>
																<c:when test="${item.stock_cnt < 10}">
																	<span class="text-danger font-weight-bold"> <i
																		class="fas fa-exclamation-triangle"></i>
																		${item.stock_cnt}
																	</span>
																</c:when>
																<c:otherwise>
							                            ${item.stock_cnt}
							                        </c:otherwise>
															</c:choose></td>
													</tr>
												</c:forEach>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- 상품 목록 row 끝 -->

						</div>
						<!-- container-fluid 끝 -->


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
									<p>Dolore erat dolor sit lorem vero amet. Sed sit lorem
										magna, ipsum no sit erat lorem et magna ipsum dolore amet
										erat.</p>
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
													placeholder="Your Name" required> <input
													type="email" class="form-control mb-2"
													placeholder="Your Email" required>
												<button class="btn btn-primary btn-block" type="submit">Subscribe</button>
											</form>
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
		<script src="js/main.js"></script>
		<script src="js/admin.js"></script>
</body>
</html>