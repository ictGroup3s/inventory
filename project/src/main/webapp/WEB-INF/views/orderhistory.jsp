<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
			<!-- Sidebar -->
			<div class="col-lg-2">
				<nav class="category-sidebar">
					<h6>마이페이지</h6>
					<ul class="nav flex-column">
						<li class="nav-item"><a href="/orderhistory"
							class="nav-link active">주문내역</a></li>
						<li class="nav-item"><a href="/mydelivery" class="nav-link">배송내역</a></li>
						<li class="nav-item"><a href="/mycs" class="nav-link">취소/반품/교환내역</a></li>
						<li class="nav-item"><a href="/myqna" class="nav-link">1:1문의내역</a></li>
						<li class="nav-item"><a href="/update" class="nav-link">내정보수정</a></li>
						<li class="nav-item"><a href="/delete" class="nav-link">회원탈퇴</a></li>
					</ul>
				</nav>
			</div>

			<!-- Main Content -->
			<div class="col-lg-10"
				style="margin-top: -30px; margin-bottom: 50px;">
				<div class="text-center mb-4">
					<h4 style="margin-top: 40px;">주문내역</h4>
				</div>
				<c:if test="${empty orders}">
					<p>주문 내역이 없습니다.</p>
				</c:if>

				<c:forEach var="order" items="${orders}">
					<div class="order-block">
						<h3>주문번호: ${order.order_no} / 주문일: ${order.order_date}</h3>
						<p>수취인: ${order.order_name} / 주소: ${order.order_addr}</p>
						<p>총금액: ${order.total_amount != null ? order.total_amount : order.amount}</p>
						<p>상태: ${order.order_status}</p>

						<table border="1">
							<thead>
								<tr>
									<th>상품번호</th>
									<th>상품명</th>
									<th>수량</th>
									<th>가격</th>
									<th>합계</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="d" items="${order.detailList}">
									<tr>
										<td>${d.item_no}</td>
										<td>${d.item_name}</td>
										<td>${d.item_cnt}</td>
										<td>${d.item_price}</td>
										<td>${d.amount != null ? d.amount : d.item_cnt * d.item_price}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</c:forEach>
				<c:forEach var="order" items="${orderList}">
					<div class="modal fade" id="orderDetailModal_${order.order_no}"
						tabindex="-1" role="dialog">
						<div class="modal-dialog modal-lg" role="document">
							<div class="modal-content">

								<div class="modal-header">
									<h5 class="modal-title">주문 상세내역</h5>
									<button type="button" class="close" data-dismiss="modal">
										<span>&times;</span>
									</button>
								</div>

								<div class="modal-body">

									<!-- 주문 기본 정보 -->
									<div class="row mb-3">
										<div class="col-md-6">
											<strong>주문번호:</strong> ${order.order_no}
										</div>
										<div class="col-md-6">
											<strong>주문일자:</strong> ${order.order_date}
										</div>
									</div>

									<div class="row mb-3">
										<div class="col-md-12">
											<strong>주문상태:</strong> <span class="badge badge-warning"
												style="background-color: #EDF1FF; color: black;">
												${order.order_status} </span>
										</div>
									</div>

									<hr>

									<!-- 상품 정보 -->
									<h6 class="mb-3">
										<strong>주문 상품</strong>
									</h6>

									<div class="table-responsive">
										<table class="table table-bordered">
											<thead>
												<tr>
													<th>상품명</th>
													<th>수량</th>
													<th>가격</th>
													<th>합계</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="item" items="${order.detailList}">
													<tr>
														<td>${item.item_name}</td>
														<td>${item.item_cnt}개</td>
														<td>${item.item_price}원</td>
														<td>${item.amount}원</td>
													</tr>
												</c:forEach>
											</tbody>
										</table>
									</div>

									<hr>

									<!-- 결제 정보 -->
									<h6 class="mb-3">
										<strong>결제 정보</strong>
									</h6>
									<div class="row mb-3">
										<div class="col-md-6">
											<strong>총 결제 금액:</strong>
										</div>
										<div class="col-md-6 text-right">
											<h5 class="text-primary mb-0">${order.total_amount}원</h5>
										</div>
									</div>

									<div class="row mb-3">
										<div class="col-md-12">
											<strong>결제 방법:</strong> ${order.payment}
										</div>
									</div>

									<hr>

									<!-- 배송 정보 -->
									<h6 class="mb-3">
										<strong>배송 정보</strong>
									</h6>

									<div class="row mb-2">
										<div class="col-md-12">
											<strong>받는 사람:</strong> ${order.order_name}
										</div>
									</div>

									<div class="row mb-2">
										<div class="col-md-12">
											<strong>연락처:</strong> ${order.order_phone}
										</div>
									</div>

									<div class="row mb-2">
										<div class="col-md-12">
											<strong>배송지:</strong> ${order.order_addr}
										</div>
									</div>

									<!-- 요청사항이 있을 경우만 표시 -->
									<c:if test="${not empty order.request}">
										<div class="row mb-3">
											<div class="col-md-12">
												<strong>배송 요청사항:</strong> ${order.request}
											</div>
										</div>
									</c:if>

									<hr>

									<!-- 주문 진행 상태: tracking 값 표시 -->
									<h6 class="mb-3">
										<strong>주문 진행 상태</strong>
									</h6>
									<ul class="mt-2">
										<li>주문 상태: ${order.order_status}</li>
										<li>Tracking 코드: ${order.tracking}</li>
									</ul>

								</div>

								<div class="modal-footer">
									<button type="button" class="btn btn-secondary"
										data-dismiss="modal">닫기</button>
								</div>

							</div>
						</div>
					</div>
				</c:forEach>

				<!-- Footer Start -->
				<div class="container-fluid bg-secondary text-dark mt-5 pt-5"
					style="margin-top: 550px !important;">
					<div class="row px-xl-5 pt-5">
						<div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
							<a href="" class="text-decoration-none">
								<h1 class="mb-4 display-5 font-weight-semi-bold">
									<span
										class="text-primary font-weight-bold border border-white px-3 mr-1">E</span>Shopper
								</h1>
							</a>
							<p>Dolore erat dolor sit lorem vero amet. Sed sit lorem
								magna, ipsum no sit erat lorem et magna ipsum dolore amet erat.</p>
							<p class="mb-2">
								<i class="fa fa-map-marker-alt text-primary mr-3"></i>123
								Street, New York, USA
							</p>
							<p class="mb-2">
								<i class="fa fa-envelope text-primary mr-3"></i>info@example.com
							</p>
							<p class="mb-0">
								<i class="fa fa-phone-alt text-primary mr-3"></i>+012 345 67890
							</p>
						</div>
						<div class="col-lg-8 col-md-12">
							<div class="row">
								<div class="col-md-4 mb-5">
									<h5 class="font-weight-bold text-dark mb-4">Quick Links</h5>
									<div class="d-flex flex-column justify-content-start">
										<a class="text-dark mb-2" href="index.html"><i
											class="fa fa-angle-right mr-2"></i>Home</a> <a
											class="text-dark mb-2" href="shop.html"><i
											class="fa fa-angle-right mr-2"></i>Our Shop</a> <a
											class="text-dark mb-2" href="detail.html"><i
											class="fa fa-angle-right mr-2"></i>Shop Detail</a> <a
											class="text-dark mb-2" href="cart.html"><i
											class="fa fa-angle-right mr-2"></i>Shopping Cart</a> <a
											class="text-dark mb-2" href="checkout.html"><i
											class="fa fa-angle-right mr-2"></i>Checkout</a> <a
											class="text-dark" href="contact.html"><i
											class="fa fa-angle-right mr-2"></i>Contact Us</a>
									</div>
								</div>
								<div class="col-md-4 mb-5">
									<h5 class="font-weight-bold text-dark mb-4">Quick Links</h5>
									<div class="d-flex flex-column justify-content-start">
										<a class="text-dark mb-2" href="index.html"><i
											class="fa fa-angle-right mr-2"></i>Home</a> <a
											class="text-dark mb-2" href="shop.html"><i
											class="fa fa-angle-right mr-2"></i>Our Shop</a> <a
											class="text-dark mb-2" href="detail.html"><i
											class="fa fa-angle-right mr-2"></i>Shop Detail</a> <a
											class="text-dark mb-2" href="cart.html"><i
											class="fa fa-angle-right mr-2"></i>Shopping Cart</a> <a
											class="text-dark mb-2" href="checkout.html"><i
											class="fa fa-angle-right mr-2"></i>Checkout</a> <a
											class="text-dark" href="contact.html"><i
											class="fa fa-angle-right mr-2"></i>Contact Us</a>
									</div>
								</div>
								<div class="col-md-4 mb-5">
									<h5 class="font-weight-bold text-dark mb-4">Newsletter</h5>
									<form action="">
										<div class="form-group">
											<input type="text" class="form-control border-0 py-4"
												placeholder="Your Name" required="required" />
										</div>
										<div class="form-group">
											<input type="email" class="form-control border-0 py-4"
												placeholder="Your Email" required="required" />
										</div>
										<div>
											<button class="btn btn-primary btn-block border-0 py-3"
												type="submit">Subscribe Now</button>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
					<div class="row border-top border-light mx-xl-5 py-4">
						<div class="col-md-6 px-xl-0">
							<p class="mb-md-0 text-center text-md-left text-dark">
								&copy; <a class="text-dark font-weight-semi-bold" href="#">Your
									Site Name</a>. All Rights Reserved.
							</p>
						</div>
						<div class="col-md-6 px-xl-0 text-center text-md-right">
							<img class="img-fluid" src="img/payments.png" alt="">
						</div>
					</div>
				</div>
				<!-- Footer End -->

				<!-- Back to Top -->
				<a href="#" class="btn btn-primary back-to-top"><i
					class="fa fa-angle-double-up"></i></a>

				<!-- JavaScript Libraries -->
				<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
				<script
					src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
				<script src="lib/easing/easing.min.js"></script>
				<script src="lib/owlcarousel/owl.carousel.min.js"></script>

				<!-- Template Javascript -->
				<script src="js/main.js"></script>
</body>
</html>