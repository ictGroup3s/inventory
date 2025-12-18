<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>

<head>
<meta name="viewport" content="width=device-width,initial-scale=1" />
<meta charset="utf-8">
<title>StockBob</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="Free HTML Templates" name="keywords">
<meta content="Free HTML Templates" name="description">

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

<!-- Libraries Stylesheet -->
<link href="lib/owlcarousel/assets/owl.carousel.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bxslider@4.2.17/dist/jquery.bxslider.min.css">

<!-- Customized Bootstrap Stylesheet -->
<link href="css/style.css" rel="stylesheet">
<link href="css/chat.css" rel="stylesheet">
</head>

<body>
	<!-- Topbar Start -->

	<div class="row align-items-center py-3 px-xl-5"
		style="margin-left: 20px;">
		<div class="col-lg-3 d-none d-lg-block">
			<a href="#" class="text-decoration-none"> <img
				src='../img/logo.png' class='logo' />
			</a>
		</div>
		<!--  <div class="col-lg-6 col-6 text-left">-->
		<div class="col-lg-6 col-12 mx-auto">
			<form action="selectall" method="get"
				style="margin-left: -60px; margin-right: 110px;">
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
		<div class="col-lg-3 col-6 text-right" style="margin-left: -120px;">
			<a href="cart" class="btn border">
				<i class="fas fa-shopping-cart text-primary"></i>
				<span class="ml-1">장바구니</span>
				<span class="badge badge-primary badge-pill" style="border-radius: 999px; color:rgb(254, 254, 254)">0</span>
			</a>
		</div>
	</div>
	</div>
	<!-- Topbar End -->


	<!-- Navbar Start -->
	<div class="container-fluid mb-5 ml-4">
		<div class="row border-top">
			<div class="col-lg-2 col-md-12 d-none d-lg-block">
				<nav class="category-sidebar" style="margin-left: -40px;">
					<h6 class="p-3">MENU</h6>
					<ul class="nav flex-column">
						<li class="nav-item"><a href="selectall"
							class="nav-link active">전체상품</a></li>
						<li class="nav-item"><a href="selectGui" class="nav-link">구이
								．찜 ．볶음</a></li>
						<li class="nav-item"><a href="selectSoup" class="nav-link">국
								．밥 ．면</a></li>
						<li class="nav-item"><a href="selectDiet" class="nav-link">식단관리</a></li>
						<li class="nav-item"><a href="selectBunsik" class="nav-link">분식
								．간식</a></li>
						<li class="nav-item"><a href="selectBanchan" class="nav-link">반찬
								．소스</a></li>
						<li class="nav-item"><a href="selectdrink" class="nav-link">생수
								．음료</a></li>
					</ul>
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

							<div class="navbar-nav ml-auto py-0 text-right">

							<!-- 로그인전 -->
							<c:if test="${empty sessionScope.loginUser}">
								<a href="login" class="nav-item nav-link">로그인</a>
								<a href="register" class="nav-item nav-link">회원가입</a>
								<a href="board" class="nav-item nav-link">고객센터</a>
							</c:if>

							<!-- 회원 로그인 후   -->
							<c:if test="${not empty sessionScope.loginUser}">
								<span class="nav-item nav-link">안녕하세요,
									${sessionScope.loginUser.name}님!</span>


								<c:if test="${sessionScope.loginRole == 0}">
									<a href="mypage" class="nav-item nav-link">마이페이지</a>
								</c:if>

								<c:if test="${sessionScope.loginRole == 1}">
									<a href="dashboard" class="nav-item nav-link">관리자 페이지</a>
								</c:if>
								<!-- 로그아웃 링크 -->
								<a href="logout" class="nav-item nav-link">로그아웃</a>

							</c:if>
						</div>
					</div>
				</nav>
				<div id="header-carousel" class="carousel slide"
					data-ride="carousel">
					<div class="carousel-inner">
						<div class="carousel-item active" style="height: 360px;">
							<img class="img-fluid" src="img/main_event1.png" alt="Image">
							<div
								class="carousel-caption d-flex flex-column align-items-center justify-content-center">
								<!-- <div class="p-3" style="max-width: 700px;">
                                    <h4 class="text-light text-uppercase font-weight-medium mb-3">10% Off Your First Order</h4>
                                    <h3 class="display-4 text-white font-weight-semi-bold mb-4">Fashionable Dress</h3>
                                    <a href="" class="btn btn-light py-2 px-3">Shop Now</a>
                                </div> -->
							</div>
						</div>
						<div class="carousel-item" style="height: 360px;">
							<img class="img-fluid" src="img/main_event2.png" alt="Image">
							<div
								class="carousel-caption d-flex flex-column align-items-center justify-content-center">
								<!-- <div class="p-3" style="max-width: 700px;">
                                    <h4 class="text-light text-uppercase font-weight-medium mb-3">10% Off Your First Order</h4>
                                    <h3 class="display-4 text-white font-weight-semi-bold mb-4">Reasonable Price</h3>
                                    <a href="" class="btn btn-light py-2 px-3">Shop Now</a>
                                </div> -->
							</div>
						</div>

						<div class="carousel-item" style="height: 360px;">
							<img class="img-fluid" src="img/main_event3.png" alt="Image">
							<div
								class="carousel-caption d-flex flex-column align-items-center justify-content-center">
								<!-- <div class="p-3" style="max-width: 700px;">
                                    <h4 class="text-light text-uppercase font-weight-medium mb-3">10% Off Your First Order</h4>
                                    <h3 class="display-4 text-white font-weight-semi-bold mb-4">Reasonable Price</h3>
                                    <a href="" class="btn btn-light py-2 px-3">Shop Now</a>
                                </div> -->
							</div>
						</div>
					</div>
					<a class="carousel-control-prev" href="#header-carousel"
						data-slide="prev">
						<div class="btn btn-dark" style="width: 45px; height: 45px;">
							<span class="carousel-control-prev-icon mb-n2"></span>
						</div>
					</a> <a class="carousel-control-next" href="#header-carousel"
						data-slide="next">
						<div class="btn btn-dark" style="width: 45px; height: 45px;">
							<span class="carousel-control-next-icon mb-n2"></span>
						</div>
					</a>
				</div>
			</div>
		</div>
	</div>
	<!-- Navbar End -->

	<!-- Offer Start -->
	<div class="container-fluid offer pt-1"
		style="width: 1200px; margin-left: 230px;">
		<div class="row px-xl-4">
			<div class="col-md-6 pb-4"">
				<div
					class="position-relative bg-secondary text-center text-md-right text-white mb-2 py-2 px-5">
					<img src="img/bingsu.png" alt="">
					<div class="position-relative" style="z-index: 1;">
						<h5 class="text-uppercase text-primary mb-3">season off</h5>
						<h1 class="mb-4 font-weight-semi-bold">Discount</h1>
					</div>
					<a href="event1" class="btn btn-outline-primary py-md-2 px-md-3">Shop
						Now</a>

				</div>
			</div>
			<div class="col-md-6 pb-4">
				<div
					class="position-relative bg-secondary text-center text-md-left text-white mb-2 py-2 px-5">
					<img src="img/boong1.png" alt="">
					<div class="position-relative" style="z-index: 1;">
						<h5 class="text-uppercase text-primary mb-3">new arrival</h5>
						<h1 class="mb-4 font-weight-semi-bold">New arrival</h1>
						<a href="event2" class="btn btn-outline-primary py-md-2 px-md-3">Shop
							Now</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Offer End -->

	<!-- Images Start -->
	<div class="container-fluid pt-5"
		style="width: 1200px; margin-left: 220px;">
		<div class="row px-xl-5 pb-3">
			<div class="col-lg-4 col-md-6 pb-1">
				<div class="cat-item d-flex flex-column  mb-4">
					<a href="selectGui"
						class="cat-img position-relative overflow-hidden mb-3"> <img
						class="img-fluid cat-img-fill" src="img/guizzim.png" alt="">
					</a>
					<h5>구이 ．찜 ．볶음</h5>
				</div>
			</div>
			<div class="col-lg-4 col-md-6 pb-1">
				<div class="cat-item d-flex flex-column  mb-4">
					<a href="selectSoup"
						class="cat-img position-relative overflow-hidden mb-3"> <img
						class="img-fluid cat-img-fill" src="img/gukbob.png" alt="">
					</a>
					<h5>국 ．밥 ．면</h5>
				</div>
			</div>
			<div class="col-lg-4 col-md-6 pb-1">
				<div class="cat-item d-flex flex-column  mb-4">
					<a href="selectDiet"
						class="cat-img position-relative overflow-hidden mb-3"> <img
						class="img-fluid cat-img-fill" src="img/sikdana.png" alt="">
					</a>
					<h5>식단관리</h5>
				</div>
			</div>
			<div class="col-lg-4 col-md-6 pb-1">
				<div class="cat-item d-flex flex-column  mb-4">
					<a href="selectBunsik"
						class="cat-img position-relative overflow-hidden mb-3"> <img
						class="img-fluid cat-img-fill" src="img/bunsikgan.png" alt="">
					</a>
					<h5>분식 ．간식</h5>
				</div>
			</div>
			<div class="col-lg-4 col-md-6 pb-1">
				<div class="cat-item d-flex flex-column  mb-4">
					<a href="selectBanchan"
						class="cat-img position-relative overflow-hidden mb-3"> <img
						class="img-fluid cat-img-fill" src="img/banchana.png" alt="">
					</a>
					<h5>반찬 ．소스</h5>
				</div>
			</div>
			<div class="col-lg-4 col-md-6 pb-1">
				<div class="cat-item d-flex flex-column  mb-4">
					<a href="selectdrink"
						class="cat-img position-relative overflow-hidden mb-3"> <img
						class="img-fluid cat-img-fill" src="img/drinka.png" alt="">
					</a>
					<h5>생수 ．음료</h5>
				</div>
			</div>
		</div>
	</div>
	<!-- Images End -->

	<!-- Image Slider Start 랜덤으로 호출 (bx slider용) -->
	<div class="container-fluid"
		style="width: 1500px; padding-left: 290px; margin-bottom: 0px;">
		<h5 align="center">추천상품</h5>
		<ul class="bxslider">
			<c:forEach var="rp" items="${randomProducts}">
				<li>
					<div class="slider-card" data-item-no="${rp.item_no}">
						<a href="detail?item_no=${rp.item_no}"> <img
							src="/img/product/${rp.item_img}" alt="${rp.item_name}"
							class="d-block mx-auto" />
						</a>
						<h6 class="slider-title mt-2">${rp.item_name}</h6>

						<!-- 평점 리뷰 적용 -->
						<c:set var="reviewCnt"
							value="${empty rp.review_cnt ? 0 : rp.review_cnt}" />
						<c:set var="rating"
							value="${empty rp.avg_rating ? 0 : rp.avg_rating}" />
						<c:if test="${rating > 0 || reviewCnt > 0}">
							<div class="mb-2" style="font-size: 0.9rem; color: #666;">
								<c:choose>
									<c:when test="${rating > 0}">
										<i class="fas fa-heart" style="color: #D19C97;"></i>
									</c:when>
									<c:otherwise>
										<i class="far fa-heart" style="color: #D19C97;"></i>
									</c:otherwise>
								</c:choose>
								<fmt:formatNumber value="${rating}" pattern="#.0" />
								<c:if test="${reviewCnt > 0}"> (${reviewCnt}개 리뷰)</c:if>
							</div>
						</c:if>

						<c:choose>
							<c:when test="${not empty rp.dis_rate and rp.dis_rate > 0}">
								<c:set var="discounted"
									value="${rp.sales_p * (100 - rp.dis_rate) / 100}" />
								<div class="d-flex flex-column">
									<h6 class="text-muted mb-0" style="font-size: 0.8rem;">
										<del>
											<fmt:formatNumber value="${rp.sales_p}" pattern="#,###" />
											원
										</del>
									</h6>
									<fmt:parseNumber var="flooredPrice" value="${discounted / 10}"
										integerOnly="true" />
									<h6>
										<fmt:formatNumber value="${flooredPrice * 10}" pattern="#,###" />
										원
									</h6>
								</div>
							</c:when>
							<c:otherwise>
								<h6>
									<fmt:formatNumber value="${rp.sales_p}" pattern="#,###" />
									원
								</h6>
							</c:otherwise>
						</c:choose>

					</div>
				</li>
			</c:forEach>
		</ul>
	</div>
	</div>
	<!-- Image Slider End -->

	<!-- Footer Start -->
	<div class="container-fluid bg-secondary text-dark mt-3 pt-3 pb-2"
		style="width: 1400px; margin-left: 150px;">
		<div class="row px-xl-5 pt-3" style="margin-left: -100px;">
			<div class="col-lg-4 col-md-12 mb-3 pr-3 pr-xl-3 pl-3 pl-xl-5 pt-3">

				<p class="mb-2">
					<i class="fa fa-map-marker-alt text-primary mr-3"></i>123 Street,
					Seoul, KOREA
				</p>
				<p class="mb-2">
					<i class="fa fa-envelope text-primary mr-3"></i>stockbob@stockbob.com
				</p>
				<p>
					<i class="fa fa-phone-alt text-primary mr-3"></i>평일 [월~금] 오전
					9시30분~5시30분
				</p>
				<h2 class="mb-0">
					<i class="fa fa-phone-alt text-primary mr-3"></i>+02 070 0000
				</h2>
			</div>
			<div class="col-lg-8 col-md-12">
				<div class="row">
					<div class="col-md-4 mb-3">
						<h5 class="font-weight-bold text-dark mt-4 mb-4">Quick Links</h5>
						<div class="d-flex flex-column justify-content-start">
							<a class="text-dark mb-2" href="/"> <i
								class="fa fa-angle-right mr-2"></i>메인 홈
							</a> <a class="text-dark mb-2" href="selectall"> <i
								class="fa fa-angle-right mr-2"></i>상품페이지로 이동
							</a>
						</div>
					</div>
					<div class="col-lg-8 col-md-12">
						<div class="row">
							<div class="col-md-12 mt-4 mb-5">
								<p class="text-dark mb-2">
									<span>stockbob 소개</span> &nbsp;&nbsp; | &nbsp;&nbsp; <span>이용약관</span>
									&nbsp; | &nbsp; <span>개인정보처리방침</span> &nbsp; | &nbsp; <span>이용안내</span>

								</p>
								<br>
								<p style="color: #999;">
									법인명 (상호) : 주식회사 STOCKBOB<br> 사업자등록번호 : 000-11-00000<br>
									통신판매업 : 제 2025-서울-11111 호<br> 주소 : 서울특별시 서대문구 신촌동 00<br>
									채용문의 : ict.atosoft.com<br> 팩스 : 070-0000-0000
								</p>
							</div>
						</div>

					</div>

				</div>
			</div>
		</div>
		<div class="row border-top border-light py-4"
			style="margin-left: -60px; margin-right: 60px;">
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

	<!-- footer end -->


	<!-- Back to Top -->
	<a href="#" class="btn btn-primary back-to-top"><i
		class="fa fa-angle-double-up"></i></a>

	<!-- ------------------채팅 관련 추가---------------- -->
	<c:if test="${sessionScope.loginRole == 0}">
		<!-- ▣ 채팅 목록 박스 -->
		<div id="chat-list-box" class="chat-list-box" style="display: none;">
			<div class="chat-list-header">나의 채팅 목록</div>
			<div id="chat-list" class="chat-list"></div>
		</div>

		<!-- ▣ 채팅창 -->
		<div id="chat-box" class="chat-box" style="display: none;">
			<div class="chat-header">
				<span id="chat-toggle-list" class="chat-header-btn">☰ 목록</span> <span>상담채팅</span>
				<span id="chat-close" class="chat-header-close">✕</span>
			</div>

			<div id="chat-messages" class="chat-messages"></div>

			<div class="chat-input">
				<input type="text" id="chat-text" placeholder="메시지 입력...">
				<button id="chat-send">Send</button>
			</div>
			<button id="new-chat-btn"
				style="display: none; padding: 10px; background: #4CAF50; color: white; border: none; cursor: pointer;">
				새 채팅 시작</button>
		</div>

		<!-- ▣ 채팅 열기 버튼 -->
		<button id="chat-open" class="chat-open-btn">💬</button>
	</c:if>
	<div class="toast-container" id="toast-container"></div>


	<!-- JavaScript Libraries -->
	<!-- jQuery 먼저 -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

	<!-- Bootstrap JS -->
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="lib/easing/easing.min.js"></script>
	<script src="lib/owlcarousel/owl.carousel.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bxslider@4.2.17/dist/jquery.bxslider.min.js"></script>

	<!-- Contact JS -->
	<script src="mail/jqBootstrapValidation.min.js"></script>
	<script src="mail/contact.js"></script>


	<!-- 1. 로그인 ID 주입 (가장 먼저) -->
	<script>
		const myId = "${sessionScope.loginUser.customer_id}";
		console.log("✅ myId 확인:", myId);
	</script>

	<!-- 2. Chat JS (SockJS/Stomp 준비된 이후 로드) -->
	<script src="/js/CustomerChat.js?v=999"></script>

	<!-- 3. Main JS (기타 UI 스크립트 – defer 가능) -->
	<script src="/js/main.js" defer></script>
	<!-- 리뷰 js -->
	<script src="js/Review.js"></script>

</body>

</html>