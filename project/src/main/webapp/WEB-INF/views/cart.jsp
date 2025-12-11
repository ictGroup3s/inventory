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

						<div class="navbar-nav ml-auto py-0" style="padding-left:-50px;margin-right:-35%;">
							<a href="login" class="nav-item nav-link">로그인</a> .
							<a href="register" class="nav-item nav-link">회원가입</a> 
							<a href="board" class="nav-item nav-link">고객센터</a>
						</div>
					</div>
				</nav>
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
											<img src="/img/product/${ci.product.item_img}" alt="" style="width:50px;"/> ${ci.product.item_name}
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
							<h5 class="font-weight-bold">총 가격</h5>
							<h5 class="font-weight-bold"><span id="cartTotalFooter">${cartTotal}</span>원</h5>
						</div>
						<form action="/payment" method="post" id="checkoutForm">
							<c:forEach var="ci" items="${cartItems}">
								<!-- 상품번호와 수량을 hidden으로 전달 -->
								<input type="hidden" name="item_no"
									value="${ci.product.item_no}">
								<input type="hidden" name="qty" value="${ci.qty}">
							</c:forEach>
							<input type="hidden" name="cartTotal" value="${cartTotal}">
							
							<a href="/checkout"class="btn btn-block btn-primary my-3 py-3"
							onclick="location.href='checkout' ">결제하기</a>
						</form>

					</div>
				</div>
			</div>
		</div>
	</div>
<!-- Footer Start -->
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
                        <span>stockbob 소개</span>
                            &nbsp;&nbsp; | &nbsp;&nbsp;
                        <span>이용약관</span>
                       		&nbsp; | &nbsp;
                       	<span>개인정보처리방침</span>
                       		&nbsp; | &nbsp;
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
                    &copy; <a class="text-dark font-weight-semi-bold" href="#">Your Site Name</a>. All Rights Reserved. Designed
                    by
                    <a class="text-dark font-weight-semi-bold" href="https://htmlcodex.com">HTML Codex</a><br>
                    Distributed By <a href="https://themewagon.com" target="_blank">ThemeWagon</a>
                </p>
            </div>
            <div class="col-md-6 px-xl-0 text-center text-md-right">
                <img class="img-fluid" src="img/payments.png" alt="">
            </div>
        </div>
    </div>
    <!-- Footer End -->

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