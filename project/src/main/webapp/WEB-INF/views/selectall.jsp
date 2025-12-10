<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>전체상품</title>
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

<!-- Customized Bootstrap Stylesheet -->
<link href="css/style.css" rel="stylesheet">
<!-- 채팅 관련 -->
<link href="css/chat.css" rel="stylesheet">

</head>

<body>

	<div class="row align-items-center py-3 px-xl-5">
		<div class="col-lg-3 d-none d-lg-block">
			<a href="/" class="text-decoration-none"> <img
				src="\img\logo.png" class='logo' />
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
			<a href="" class="btn border"> <i
				class="fas fa-heart text-primary"></i> <span class="badge">0</span>
			</a> <a href="cart" class="btn border"> <i
				class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span>
			</a>
		</div>
	</div>
	<!-- Topbar End -->

	<!-- Navbar Start ########### 카테고리 메뉴바 ##############-->
	<div class="container-fluid">
		<div class="row border-top px-xl-5">
			<div class="col-lg-12">
				<nav
					class="navbar navbar-expand-lg bg-light navbar-light py-3 py-lg-0 px-0">
					<a href="/" class="text-decoration-none d-block d-lg-none"> <img
						src="\img\logo.png" class='logo' />
					</a>
					<button type="button" class="navbar-toggler" data-toggle="collapse"
						data-target="#navbarCollapse">
						<span class="navbar-toggler-icon"></span>
					</button>
					<div class="collapse navbar-collapse justify-content-between"
						id="navbarCollapse">
						<div class="navbar-nav ml-auto py-0">
							<!-- 로그인전 -->
							<c:if test="${empty sessionScope.loginUser}">
								<a href="login" class="nav-item nav-link">로그인</a>
								<a href="register" class="nav-item nav-link">회원가입</a>
								<a href="board" class="nav-item nav-link">고객센터</a>
							</c:if>

							<!-- 회원 로그인 후   -->
							<c:if test="${not empty sessionScope.loginUser}">
								<span class="nav-item nav-link">안녕하세요,
									${sessionScope.loginUser.customer_id}님!</span>


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
			</div>
		</div>
	</div>


	<div class="container-fluid pt-5">
		<div class="row px-xl-5">
			<!-- ================== 왼쪽 카테고리 ================== -->
			<div class="col-lg-2 col-md-12 d-none d-lg-block">
				<nav class="category-sidebar">
					<h6 class="p-3">Categories</h6>
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
			<div class="col-lg-9 col-md-12">
				<div class="row pb-3">
					<div class="col-12 pb-1">
						<div
							class="d-flex align-items-center justify-content-between mb-4">
							<!--  아래 검색창
							<form action="selectall" method="get">
							
								<div class="input-group">
									<input type="text" name="q" class="form-control"
										placeholder="Search by name" value="${q}">
									<div class="input-group-append">
										<button class="input-group-text bg-transparent text-primary" type="submit">
											<i class="fa fa-search"></i>
										</button>
									</div>
								</div>
							 	
								<input type="hidden" name="size" value="${size}" />
							</form>
						-->
							<div class="dropdown ml-4">
								<button class="btn border dropdown-toggle" type="button"
									id="triggerId" data-toggle="dropdown" aria-haspopup="true"
									aria-expanded="false">정렬 기준</button>
								<div class="dropdown-menu dropdown-menu-right"
									aria-labelledby="triggerId">
									<a class="dropdown-item"
										href="selectall?page=1&size=${size}&q=${fn:escapeXml(q)}">최신순</a>
									<a class="dropdown-item"
										href="selectall?page=1&size=${size}&q=${fn:escapeXml(q)}&sort=price_desc">가격
										높은순</a> <a class="dropdown-item"
										href="selectall?page=1&size=${size}&q=${fn:escapeXml(q)}&sort=price_asc">가격
										낮은순</a>
								</div>
							</div>
						</div>
					</div>

					<!-- 상품 목록 시작 (상품검색시 결과) -->
					<c:if test="${empty products}">
						<div class="col-12">
							<div class="alert alert-info text-center">상품이 없습니다. 검색어를
								변경하거나 관리자에게 문의하세요.</div>
						</div>
					</c:if>

					<c:forEach var="item" items="${products}">
						<div class="col-lg-4 col-md-4 col-sm-4 pb-1">
							<div class="card product-item border-0 mb-4"
								style="width: 280px;">
								<div
									class="card-header product-img position-relative overflow-hidden bg-transparent border p-0">
									<a href="detail?item_no=${item.item_no}"> <img
										src="/img/product/${item.item_img}" width="300" height="300"
										alt="${item.item_name}" />
									</a>
								</div>
								<div
									class="card-body border-left border-right text-center p-0 pt-4 pb-3">
									<h6 class="text-truncate mb-3">${item.item_name}</h6>
									<div class="d-flex justify-content-center">
										<h6>${item.sales_p}원</h6>
										<h6 class="text-muted ml-2">
											<del>${item.sales_p}원</del>
										</h6>
									</div>
								</div>
								<div
									class="card-footer d-flex justify-content-between bg-light border">
									<a href="detail?item_no=${item.item_no}"
										class="btn btn-sm text-dark p-0"> <i
										class="fas fa-eye text-primary mr-1"></i>상세정보
									</a>
									<form method="post" action="/cart/addForm"
										style="display: inline;">
										<input type="hidden" name="item_no" value="${item.item_no}" />
										<input type="hidden" name="qty" value="1" />
										<button type="button"
											class="btn btn-sm text-dark p-0 add-to-cart-btn"
											data-item-no="${item.item_no}"
											style="background: none; border: 0; padding: 0;">
											<i class="fas fa-shopping-cart text-primary mr-1"></i>장바구니 담기
										</button>
										<noscript>
											<button type="submit" class="btn btn-sm text-dark p-0"
												style="background: none; border: 0; padding: 0;">
												<i class="fas fa-shopping-cart text-primary mr-1"></i>장바구니
												담기
											</button>
										</noscript>
									</form>
								</div>
							</div>
						</div>
					</c:forEach>
					<!-- 상품 목록 끝 (상품검색시 결과) -->

					<!-- 상품 목록 페이지 이동 시작 -->
					<div class="col-12 pb-1">
						<nav aria-label="Page navigation">
							<ul class="pagination justify-content-center mb-3">
								<li class="page-item ${page <= 1 ? 'disabled' : ''}"><a
									class="page-link"
									href="selectall?page=${page-1}&size=${size}&q=${fn:escapeXml(q)}&sort=${sort}"
									aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
										<span class="sr-only">이전</span>
								</a></li>
								<c:forEach var="i" begin="1" end="${totalPages}">
									<li class="page-item ${i == page ? 'active' : ''}"><a
										class="page-link"
										href="selectall?page=${i}&size=${size}&q=${fn:escapeXml(q)}&sort=${sort}">${i}</a>
									</li>
								</c:forEach>
								<li class="page-item ${page >= totalPages ? 'disabled' : ''}">
									<a class="page-link"
									href="selectall?page=${page+1}&size=${size}&q=${fn:escapeXml(q)}&sort=${sort}"
									aria-label="Next"> <span aria-hidden="true">&raquo;</span>
										<span class="sr-only">다음</span>
								</a>
								</li>
							</ul>
						</nav>
					</div>
					<!-- 상품 목록 페이지 이동 끝 -->

				</div>
			</div>
		</div>
	</div>

	<!-- Footer Start -->
	<div class="container-fluid bg-secondary text-dark mt-5 pt-5"
		style="margin-top: 550px !important;">
		<div class="row px-xl-5 pt-5">
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
							<a class="text-dark mb-2" href="/"><i
								class="fa fa-angle-right mr-2"></i>메인 홈</a> <a
								class="text-dark mb-2" href="selectall"><i
								class="fa fa-angle-right mr-2"></i>상품페이지로 이동</a>
							<!--  <a class="text-dark mb-2" href="mlist"><i class="fa fa-angle-right mr-2"></i>마이페이지</a>
                            <a class="text-dark mb-2" href="cart"><i class="fa fa-angle-right mr-2"></i>장바구니</a>
                            <a class="text-dark mb-2" href="checkout"><i class="fa fa-angle-right mr-2"></i>결제</a> -->
						</div>
					</div>

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
	<!-- Footer End -->

	<!-- Back to Top -->
	<a href="#" class="btn btn-primary back-to-top"><i
		class="fa fa-angle-double-up"></i></a>
	<!-- ------------------채팅 관련 추가---------------- -->
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
	</div>

	<!-- ▣ 채팅 열기 버튼 -->
	<button id="chat-open" class="chat-open-btn">💬</button>


	<!-- JavaScript Libraries -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="lib/easing/easing.min.js"></script>
	<script src="lib/owlcarousel/owl.carousel.min.js"></script>

	<!-- Contact Javascript File -->
	<script src="mail/jqBootstrapValidation.min.js"></script>
	<script src="mail/contact.js"></script>

	<!-- Javascript -->
	<script src="/js/main.js"></script>
	<!-- 채팅 JS -->
	<script src="/js/chat.js?v=1"></script>

	<!-- SockJS + StompJS -->
	<script
		src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
	<!-- 
	<script>
		// `main.js`에서 addToCart를 정의하지 않았을 때를 대비한 폴백 전역 함수 ("undefined" 오류 방지)
		if (typeof window.addToCart !== 'function') {
			window.addToCart = function(itemNo, qty) {
				try {
					console.log('fallback addToCart called', itemNo, qty);
					if (!itemNo) { alert('itemNo required'); return; }
					fetch('/cart/add', {
						method: 'POST',
						headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
						body: 'item_no=' + encodeURIComponent(itemNo) + '&qty=' + encodeURIComponent(qty || 1)
					}).then(function(res){
						return res.json().catch(function(){ return null; });
					}).then(function(json){
						if (json && json.success) {
							// 페이지 이동 대신 간단한 피드백을 보여줍니다
							try { console.log('fallback addToCart success', json); 
								alert('장바구니에 담겼습니다.'); 
								} catch(e){}
						} else {
							alert('장바구니에 추가하지 못했습니다.');
						}
					}).catch(function(err){
						console.error('fallback addToCart error', err);
						alert('네트워크 오류');
					});
				} catch(e) { console.error(e); }
			};
		}
	</script>
	<script>
		// 네이티브 클릭 핸들러: 버튼 내부(아이콘/텍스트) 어디를 눌러도 안정적으로 처리합니다
		document.addEventListener('click', function(e){
			try {
				var target = e.target;
				// 가장 가까운 'add-to-cart-btn' 클래스를 가진 요소를 찾습니다
				var btn = target.closest ? target.closest('.add-to-cart-btn') : null;
				if (!btn && target.classList && target.classList.contains('add-to-cart-btn')) btn = target;
				if (btn) {
					// 버튼 요소로부터 data-item-no 속성값을 읽습니다
					var itemNo = btn.getAttribute('data-item-no') || btn.dataset && btn.dataset.itemNo;
					console.log('Native click on add-to-cart-btn (resolved)', itemNo);
					// 전역 addToCart 함수가 있으면 이를 우선 호출합니다
					if (typeof window.addToCart === 'function') {
						// 기본 폼/버튼 동작을 막습니다
						e.preventDefault();
						try { window.addToCart(itemNo, 1); } catch(err) { console.error('addToCart call failed', err); }
					} else {
						// 폴백: JS 핸들러가 없으면 둘러싼 폼을 제출합니다
						var form = btn.closest ? btn.closest('form') : null;
						if (form) form.submit();
					}
				}
			} catch(err){ console.error('debug click listener error', err); }
		}, true);
	</script>
	 -->
</body>

</html>
