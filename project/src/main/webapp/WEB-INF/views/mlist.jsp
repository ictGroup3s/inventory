<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>고객관리</title>
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
<link rel="stylesheet" href="css/adminChat.css">
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
			<a href="#" class="btn border"><i
				class="fas fa-heart text-primary"></i> <span class="badge">0</span></a>
			<a href="cart" class="btn border"><i
				class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span></a>
		</div>
	</div>

	<!-- Main Layout -->
	<div class="container-fluid">
		<div class="row px-xl-5">

			<div class="col-lg-2">
				<!-- Sidebar -->
				<nav class="category-sidebar">
					<h6>관리자 페이지</h6>
					<ul class="nav flex-column">
						<li class="nav-item"><a href="dashboard" class="nav-link">대쉬보드</a></li>
						<li class="nav-item"><a href="item" class="nav-link">상품관리</a></li>
						<li class="nav-item"><a href="stock" class="nav-link">입고/재고관리</a></li>
						<li class="nav-item"><a href="order" class="nav-link">주문관리</a></li>
						<li class="nav-item"><a href="stats" class="nav-link">통계</a></li>
						<li class="nav-item"><a href="mlist" class="nav-link active">고객관리</a></li>
						<li class="nav-item"><a href="board" class="nav-link">고객센터</a></li>
					</ul>
				</nav>
			</div>
			<!-- END col-lg-2 -->

			<!-- Content -->
			<!-- Admin Chat 영역 -->
			<div class="col-lg-10">

				<div class="admin-chat-wrapper">

					<h3>고객 채팅 관리</h3>

					<div id="admin-chat-container">

						<!-- 좌측 고객 목록 -->
						<div id="admin-chat-list-wrapper">
							<div class="chat-list-header">
								<span>채팅 목록</span>
								<button id="refresh-chat-list" title="새로고침">🔄</button>
							</div>
							<div id="admin-chat-list">
								<!-- JavaScript로 동적 생성 -->
							</div>
						</div>

						<!-- 우측 채팅 -->
						<div class="admin-chat-panel">
							<div class="chat-panel-header">
								<span id="current-chat-user">채팅방을 선택해주세요</span>
							</div>
							<div id="admin-chat-messages"></div>
							<div id="admin-chat-input">
								<input type="text" id="admin-chat-text" placeholder="메시지 입력...">
								<button id="admin-chat-send">Send</button>
								<button id="close-chat">종료</button>
							</div>
						</div>

					</div>
					<!-- END #admin-chat-container -->

				</div>
				<!-- END .admin-chat-wrapper -->

			</div>
			<!-- END col-lg-10 -->

		</div>
		<!-- END row -->
	</div>
	<!-- END container-fluid -->

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
							<a class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Home</a> <a
								class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Our Shop</a> <a
								class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Shop Detail</a> <a
								class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Shopping Cart</a> <a
								class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Checkout</a> <a class="text-dark"
								href="#"><i class="fa fa-angle-right mr-2"></i>Contact Us</a>
						</div>
					</div>

					<div class="col-md-4 mb-5">
						<h5 class="font-weight-bold text-dark mb-4">Quick Links</h5>
						<div class="d-flex flex-column justify-content-start">
							<a class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Home</a> <a
								class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Our Shop</a> <a
								class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Shop Detail</a> <a
								class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Shopping Cart</a> <a
								class="text-dark mb-2" href="#"><i
								class="fa fa-angle-right mr-2"></i>Checkout</a> <a class="text-dark"
								href="#"><i class="fa fa-angle-right mr-2"></i>Contact Us</a>
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
	<script src="js/main.js"></script>

	<!-- 관리자 ID 주입 (admin-chat.js보다 먼저 실행) -->
	<script>
		const adminId = "${sessionScope.loginUser.customer_id}";
		const adminRole = "${sessionScope.loginUser.role}";

		console.log("✅ 관리자 ID:", adminId);
		console.log("✅ Role:", adminRole);
		
	</script>

	<script src="js/AdminChat.js?v=999"></script>

</body>
</html>