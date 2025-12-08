<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<title>StockBob - 장바구니</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="Free HTML Templates" name="keywords">
<meta content="Free HTML Templates" name="description">

<link href="img/favicon.ico" rel="icon">

<link rel="preconnect" href="https://fonts.gstatic.com">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">

<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css"
	rel="stylesheet">

<link href="lib/owlcarousel/assets/owl.carousel.min.css"
	rel="stylesheet">

<link href="css/style.css" rel="stylesheet">
</head>

<body>
	<div class="row align-items-center py-3 px-xl-5">
		<div class="col-lg-3 d-none d-lg-block">
			<a href="/" class="text-decoration-none"> <img
				src='../img/logo.png' class='logo' />
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
	</div>
	<div class="container-fluid">
		<div class="row border-top px-xl-5">
			<div class="col-lg-3 d-none d-lg-block">
				<a
					class="btn shadow-none d-flex align-items-center justify-content-between bg-primary text-white w-100"
					data-toggle="collapse" href="#navbar-vertical"
					style="height: 65px; margin-top: -1px; padding: 0 30px;">
					<h6 class="m-0">Categories</h6> <i
					class="fa fa-angle-down text-dark"></i>
				</a>
				<nav
					class="collapse position-absolute navbar navbar-vertical navbar-light align-items-start p-0 border border-top-0 border-bottom-0 bg-light"
					id="navbar-vertical" style="width: calc(100% - 30px); z-index: 1;">
					<div class="navbar-nav w-100 overflow-hidden" style="height: 325px">
						<a href="selectall" class="nav-item nav-link">전체상품</a> 
						<a href="" class="nav-item nav-link">구이 ．찜 ．볶음 </a> 
						<a href="" class="nav-item nav-link">국 ．밥 ．면</a> 
						<a href="" class="nav-item nav-link"> 식단관리 </a> 
						<a href="" class="nav-item nav-link">분식 ．간식</a> 
						<a href="" class="nav-item nav-link">반찬 ．소스</a>
						<a href="" class="nav-item nav-link">생수 ．음료</a>						
					</div>
				</nav>
			</div>
			<div class="col-lg-9">
				<nav
					class="navbar navbar-expand-lg bg-light navbar-light py-3 py-lg-0 px-0">
					<a href="" class="text-decoration-none d-block d-lg-none"> <img
						src='../img/logo.png' class='logo' />
					</a>
					<button type="button" class="navbar-toggler" data-toggle="collapse"
						data-target="#navbarCollapse">
						<span class="navbar-toggler-icon"></span>
					</button>
					<div class="collapse navbar-collapse justify-content-between"
						id="navbarCollapse">

						<div class="navbar-nav ml-auto py-0">
							<a href="login" class="nav-item nav-link">로그인</a> .
							<a href="register" class="nav-item nav-link">회원가입</a> 
							<a href="board" class="nav-item nav-link">고객센터</a>
						</div>
					</div>
				</nav>
			</div>
		</div>
	</div>
	<div class="container-fluid bg-secondary mb-5">
		<div
			class="d-flex flex-column align-items-center justify-content-center"
			style="min-height: 300px">
			<h1 class="font-weight-semi-bold text-uppercase mb-3">장바구니</h1>
			<div class="d-inline-flex">
				<p class="m-0">
					<a href="">Home</a>
				</p>
				<p class="m-0 px-2">-</p>
				<p class="m-0">Shopping Cart</p>
			</div>
		</div>
	</div>
	<div class="container-fluid pt-5">
		<div class="row px-xl-5">
			<div class="col-lg-8 table-responsive mb-5">
				<table class="table table-bordered text-center mb-0">
					<thead class="bg-secondary text-dark">
						<tr>
							<th>상품명</th>
							<th>가격</th>
							<th>수량</th>
							<th>총액</th>
							<th>삭제하기</th>
						</tr>
					</thead>
					<tbody class="align-middle">
						<c:choose>
							<c:when test="${not empty cartItems}">
								<c:forEach var="ci" items="${cartItems}">
									<tr>
										<td class="align-middle">
											<img src="/img/product/${ci.product.item_img}" alt=""
												style="width:50px;"/> ${ci.product.item_name}
										</td>
										<td class="align-middle">${ci.product.sales_p}원</td>
										<td class="align-middle">
											<div class="input-group quantity mx-auto" style="width: 120px;">
												<div class="input-group-prepend">
													<button class="btn btn-sm btn-outline-secondary qty-decrease" data-item="${ci.product.item_no}" type="button">−</button>
												</div>
												<input type="text"
													class="form-control form-control-sm bg-secondary text-center cart-qty-input"
													data-item="${ci.product.item_no}"
													value="${ci.qty}" />
												<div class="input-group-append">
													<button class="btn btn-sm btn-outline-secondary qty-increase" data-item="${ci.product.item_no}" type="button">+</button>
												</div>
											</div>
										</td>
										<td class="align-middle"><span class="row-subtotal" data-item="${ci.product.item_no}">${ci.subtotal}</span>원</td>
										<td class="align-middle">
											<form method="post" action="/cart/remove">
												<input type="hidden" name="item_no" value="${ci.product.item_no}" />
												<button class="btn btn-sm btn-primary" type="submit"><i class="fa fa-times"></i></button>
											</form>
										</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td class="text-center" colspan="5">장바구니가 비어있습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
			<div class="col-lg-4">
				<div class="card border-secondary mb-5">
					<div class="card-header bg-secondary border-0">
						<h4 class="font-weight-semi-bold m-0">내 장바구니</h4>
					</div>
		<!-- 테이블 생각해서 작업 -->
					<div class="card-body">
						<div class="d-flex justify-content-between mb-3 pt-1">
							<h6 class="font-weight-medium">상품가격 합계</h6>
							<h6 class="font-weight-medium"><span id="cartTotal">${cartTotal}</span>원</h6>
						</div>
					</div>
					<div class="card-body">
						<div class="d-flex justify-content-between mb-3 pt-1">
							<h6 class="font-weight-medium">총 수량</h6>
							<h6 class="font-weight-medium"><span id="cartCount">${cart_cnt}</span></h6>
						</div>
					</div>
					<div class="card-footer border-secondary bg-transparent">
						<div class="d-flex justify-content-between mt-2">
							<h5 class="font-weight-bold">총가격</h5>
							<h5 class="font-weight-bold"><span id="cartTotalFooter">${cartTotal}</span>원</h5>
						</div>
						<button class="btn btn-block btn-primary my-3 py-3"
							onclick="location.href='checkout' ">결제하기</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="container-fluid bg-secondary text-dark mt-5 pt-5">
		<div class="row px-xl-5 pt-5">
			<div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
				<a href="" class="text-decoration-none">
					<h1 class="mb-4 display-5 font-weight-semi-bold">
						<span
							class="text-primary font-weight-bold border border-white px-3 mr-1">E</span>Shopper
					</h1>
				</a>
				<p>Dolore erat dolor sit lorem vero amet. Sed sit lorem magna,
					ipsum no sit erat lorem et magna ipsum dolore amet erat.</p>
				<p class="mb-2">
					<i class="fa fa-map-marker-alt text-primary mr-3"></i>123 Street,
					New York, USA
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
								class="fa fa-angle-right mr-2"></i>Checkout</a> <a class="text-dark"
								href="contact.html"><i class="fa fa-angle-right mr-2"></i>Contact
								Us</a>
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
								class="fa fa-angle-right mr-2"></i>Checkout</a> <a class="text-dark"
								href="contact.html"><i class="fa fa-angle-right mr-2"></i>Contact
								Us</a>
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
						Site Name</a>. All Rights Reserved. Designed by <a
						class="text-dark font-weight-semi-bold"
						href="https://htmlcodex.com">HTML Codex</a><br> Distributed
					By <a href="https://themewagon.com" target="_blank">ThemeWagon</a>
				</p>
			</div>
			<div class="col-md-6 px-xl-0 text-center text-md-right">
				<img class="img-fluid" src="img/payments.png" alt="">
			</div>
		</div>
	</div>
	<a href="#" class="btn btn-primary back-to-top"><i
		class="fa fa-angle-double-up"></i></a>


	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="lib/easing/easing.min.js"></script>
	<script src="lib/owlcarousel/owl.carousel.min.js"></script>

	<script src="mail/jqBootstrapValidation.min.js"></script>
	<script src="mail/contact.js"></script>

	<script src="js/main.js"></script>


<!-- 장바구니 수량 제어 스크립트 
전역 JS(main.js)로 처리하면, 장바구니 페이지의 고유 AJAX/동기화 로직과 충돌해 중복 업데이트나 잘못된 표시가 발생
-->
	<script>
		// 장바구니 수량 제어: 감소/증가 버튼 및 AJAX로 서버에 갱신
		(function(){
			function updateQtyOnServer(itemNo, qty) {
				return $.post('/cart/update', { item_no: itemNo, qty: qty });
			}

			$(document).on('click', '.qty-decrease', function(e){
				var item = $(this).data('item');
				var $input = $('.cart-qty-input[data-item="'+item+'"]');
				var val = parseInt($input.val()) || 0;
				var next = Math.max(0, val - 1);
				$input.val(next);
				updateQtyOnServer(item, next).done(function(resp){
					if (resp && resp.success) {
						$('.badge').text(resp.cartCount);
						$('#cartCount').text(resp.cartCount);
						if (typeof resp.cartTotal !== 'undefined') {
							$('#cartTotal').text(resp.cartTotal);
							$('#cartTotalFooter').text(resp.cartTotal);
						}
						if (typeof resp.itemSubtotal !== 'undefined') {
							$('.row-subtotal[data-item="'+item+'"]').text(resp.itemSubtotal);
						}
					}
				});
			});

			$(document).on('click', '.qty-increase', function(e){
				var item = $(this).data('item');
				var $input = $('.cart-qty-input[data-item="'+item+'"]');
				var val = parseInt($input.val()) || 0;
				var next = val + 1;
				$input.val(next);
				updateQtyOnServer(item, next).done(function(resp){
					if (resp && resp.success) {
						$('.badge').text(resp.cartCount);
						$('#cartCount').text(resp.cartCount);
						if (typeof resp.cartTotal !== 'undefined') {
							$('#cartTotal').text(resp.cartTotal);
							$('#cartTotalFooter').text(resp.cartTotal);
						}
						if (typeof resp.itemSubtotal !== 'undefined') {
							$('.row-subtotal[data-item="'+item+'"]').text(resp.itemSubtotal);
						}
					}
				});
			});

	// 장바구니 품목 수량을 직접 입력한 후 포커스가 벗어나면(blur) 서버에 갱신 요청(db반영)
			$(document).on('blur', '.cart-qty-input', function(){
				var item = $(this).data('item');
				var val = parseInt($(this).val()) || 0;
				if (val < 0) val = 0;
				$(this).val(val);
				updateQtyOnServer(item, val).done(function(resp){
					if (resp && resp.success) {
						$('.badge').text(resp.cartCount);
						$('#cartCount').text(resp.cartCount);
						if (typeof resp.cartTotal !== 'undefined') {
							$('#cartTotal').text(resp.cartTotal);
							$('#cartTotalFooter').text(resp.cartTotal);
						}
						if (typeof resp.itemSubtotal !== 'undefined') {
							$('.row-subtotal[data-item="'+item+'"]').text(resp.itemSubtotal);
						}
					}
				});
			});
		})();
	</script>

</body>

</html>