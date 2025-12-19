<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- 가격,숫자 포맷 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>상세정보</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="Free HTML Templates" name="keywords">
<meta content="Free HTML Templates" name="description">

<!-- jQuery 먼저 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- bxSlider CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css">
<!-- bxSlider JS -->
<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>

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
<!-- ############## 로고부분 ############################## -->
	<div class="row align-items-center py-3 px-xl-4" style="margin-left:80px;">
		 <div class="col-lg-3 d-none d-lg-block"><!-- 큰 화면에서는 3/12, 작은 화면에서는 숨김 -->
			<a href="/" class="text-decoration-none"> <img
				src="\img\logo.png" class='logo' />
			</a>
		</div>
		
		<div class="col-lg-6 col-6 text-left">
			<form action="selectall" method="get" style="margin-left:150px;">
				<div class="input-group">
					<input type="text" name="q" class="form-control"
						placeholder="찾고 싶은 상품을 검색하세요." value="${q}">
					<div class="input-group-append">
						<button class="input-group-text bg-transparent text-primary" type="submit">
								<i class="fa fa-search"></i>
						</button>
					</div>
				</div>
			</form>
		</div>
		<div class="col-lg-3 col-6 text-right">			
			<a href="cart" class="btn border">
				<i class="fas fa-shopping-cart text-primary"></i>
				<span class="ml-1">장바구니</span>
				<span class="badge badge-primary badge-pill" style="border-radius: 999px; color:rgb(254, 254, 254)">0</span>
			</a>
		</div>
	</div>
	
	<!-- Topbar End -->


	<!-- Navbar Start ########### 카테고리 메뉴바 ##############-->
	
	<div class="container-fluid">
		<div class="row border-top px-xl-5">
			<div class="col-lg-12">
				<nav class="navbar navbar-expand-lg bg-light navbar-light py-0 py-lg-0 px-0">
					<a href="/" class="text-decoration-none d-block d-lg-none p-0 m-0"> 
					<img src="\img\logo.png" class='logo' />
					</a>
					<button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
						<span class="navbar-toggler-icon"></span>
					</button>
					<div class="collapse navbar-collapse justify-content-between" id="navbarCollapse">
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
	<div class="container-fluid pt-2" >
		<div class="row px-xl-5">
		  <!-- ================== 왼쪽 카테고리 ================== -->
            <div class="col-lg-2 col-md-12 d-none d-lg-block">
              	<nav class="category-sidebar" style="margin-left:-40px;">
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
			
<!-- Shop Detail Start ######## 이미지 파일 #########################-->
	<div class="col-lg-10 col-md-12 p-0 m-0" >		 
		<div class="container py-5" style="margin-left:-80px;">
		    <div class="d-flex flex-wrap align-items-center">
		        <!-- 이미지 -->
		        <div class="p-2 flex-shrink-0 mr-5">
		            <img src="/img/product/${product.item_img}" alt="${product.item_name}"  width="350px" height="350px">
		        </div>
		        <!-- 텍스트 -->
		         <div class="p-2 flex-grow-1">
					<h4 class="font-weight-semi-bold" style="margin-bottom:20px; margin-top:80px;">${product.item_name}</h4>												
		            <div id="product-rating-summary" class="mb-2" style="font-size: 0.9rem; color: #666;"></div>
		            
		            <div class="d-flex mb-2 align-items-center">
		               		<small class="pt-1"></small> 
		               		
	               		<c:choose>
							<c:when test="${not empty product.dis_rate and product.dis_rate > 0}">
								<c:set var="discounted" value="${product.sales_p * (100 - product.dis_rate) / 100}" />
								
								<div class="d-flex flex-column">
									<h6 class="text-muted mb-0">
										<del><fmt:formatNumber value="${product.sales_p}" pattern="#,###" />원</del>
									</h6>
									
								<%-- 1원 단위 절삭 설정(내림) parseNumber(소수자리 버림) --%>
									<fmt:parseNumber var="flooredPrice" value="${discounted / 10}" integerOnly="true" />
									<h4><fmt:formatNumber value="${flooredPrice * 10}" pattern="#,###" />원</h4>
								<%-- 1원 단위 절삭 설정(내림) parseNumber(소수자리 버림) --%>
								</div>
								
							</c:when>
							<c:otherwise>
								<h4><fmt:formatNumber value="${product.sales_p}" pattern="#,###" />원</h4>
							</c:otherwise>
						</c:choose>			
					</div>					
				
				<form action="/cart/addForm" method="post" style="margin-top:80px;">
					<input type="hidden" name="item_no" value="${product.item_no}" />
					<c:if test="${product.stock_cnt <= 10}">
							<p style="font-size:12px; color:#b90000;"> 남은 수량: ${product.stock_cnt} 개</p>
					</c:if>
				 <div class="d-flex align-items-center mb-3">					
				     <!-- 수량 조절 -->
			        <div class="input-group mr-2  quantity" style="width:130px;">		
			        <button type="button" class="btn btn-primary btn-minus">-</button>
			        	<input type="number" class="form-control text-center" name="qty" id="qty" value="1" min="1" max="${product.stock_cnt}" data-max="${product.stock_cnt}">
			        <button type="button" class="btn btn-primary btn-plus">+</button>
			       </div>
			      <!-- 장바구니 담기 버튼 -->   
			       <button type="submit" class="btn btn-primary">
					<i class="fa fa-shopping-cart mr-1"></i> 장바구니 담기
					</button>
					 
				</form>
		
						</div>
					</div>
				</div>
			</div>

		<div class="row px-xl-5">
			<div class="col">
				<div class="nav nav-tabs justify-content-center border-secondary mb-4">
					<c:set var="activeTab" value="${param.tab eq 'review' ? 'review' : 'info'}" />
					<a class="nav-item nav-link ${activeTab eq 'info' ? 'active' : ''}" data-toggle="tab" href="#tab-pane-2">상품정보</a> 
					<a class="nav-item nav-link ${activeTab eq 'review' ? 'active' : ''}" data-toggle="tab" href="#tab-pane-3">리뷰</a>
				</div>

				<div class="tab-content">
					<div class="tab-pane fade ${activeTab eq 'info' ? 'show active' : ''}" id="tab-pane-2">
						<h4 class="mb-3">상품 상세정보</h4>
						<div class="row">
							<div class="col-md-6">
								<ul class="list-group list-group-flush">
									<li class="list-group-item px-0"> ${product.item_content}</li>								
								</ul>
							</div>				
						</div>
					</div>

					<div class="tab-pane fade ${activeTab eq 'review' ? 'show active' : ''}" id="tab-pane-3">
						<div class="row">
							<div class="col-md-6">
								<h4 class="mb-4">리뷰 목록 <span id="review-summary" style="font-size: 0.6em; color: #666;"></span></h4>
								<div id="review-section" data-item-no="${product.item_no}" data-login-user="${sessionScope.loginUser.customer_id}">
								
								<!-- 리뷰 목록 출력 부분 ajax / 리뷰 수정-삭제(Review.js)-->
									<div id="review-list">										
								
									</div>

									<!-- 페이지 이동 버튼 영역 -->
									<div id="review-pagination" class="mt-3 d-flex justify-content-center"></div>
									<!-- 페이지 이동 버튼 영역 -->
									    
								</div>
							</div>
					          
						<div class="col-md-6">
							<h4 class="mb-4">리뷰 작성</h4>
							<c:choose>
								<c:when test="${empty sessionScope.loginUser}">
									<p class="text-muted">로그인 후 리뷰 작성이 가능합니다.</p>
								</c:when>
								<c:when test="${not empty sessionScope.loginUser and not canWriteReview}">
									<p class="text-muted">${reviewBlockReason}</p>
								</c:when>
								<c:otherwise>
									<form id="reviewForm">
										<input type="hidden" name="item_no" value="${product.item_no}" />
									    <input type="hidden" name="customer_id" value="${sessionScope.loginUser.customer_id}" />
								
								<div class="form-group">
                                    <label class="mb-1">평점 *</label>
                                    <div id="rating-input" class="d-flex align-items-center">
                                        <i class="fas fa-heart fa-lg rating-heart mr-1" data-value="1" style="cursor:pointer; color: #D19C97;"></i>
                                        <i class="fas fa-heart fa-lg rating-heart mr-1" data-value="2" style="cursor:pointer; color: #D19C97;"></i>
                                        <i class="fas fa-heart fa-lg rating-heart mr-1" data-value="3" style="cursor:pointer; color: #D19C97;"></i>
                                        <i class="fas fa-heart fa-lg rating-heart mr-1" data-value="4" style="cursor:pointer; color: #D19C97;"></i>
                                        <i class="fas fa-heart fa-lg rating-heart mr-1" data-value="5" style="cursor:pointer; color: #D19C97;"></i>
                                        <input type="hidden" name="rating" id="rating" value="5">
                                    </div>
                                </div>

								<div class="form-group">
									<label for="re_content">내 리뷰작성 *</label>
											<textarea id="re_content" name="re_content" cols="30" rows="5" class="form-control"
												placeholder="리뷰 내용을 입력하세요 (예: 맛/양/배송 상태)"
												data-placeholder="리뷰 내용을 입력하세요 (예: 맛/양/배송 상태)"></textarea>
								</div>
								<div class="form-group">
									<label for="re_title">제목 *</label> 
									<input type="text" id="re_title" name="re_title" class="form-control" id="name">
								</div>
								
								<div class="form-group mb-0">
									<input type="button" id="addReview" value="리뷰 남기기" class="btn btn-primary px-3">
								</div>
											
								</form>
								</c:otherwise>
							</c:choose>

						</div>
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Shop Detail End -->
	
<!-- Image Slider Start 랜덤으로 호출 (bx slider용) -->
<div class="container-fluid py-5" style="margin-left:-20px;">
   <ul class="bxslider">
            <c:forEach var="rp" items="${randomProducts}">  
               <li>
                    <div class="slider-card" data-item-no="${rp.item_no}">
                        <a href="detail?item_no=${rp.item_no}">
                            <img src="/img/product/${rp.item_img}" alt="${rp.item_name}" class="d-block mx-auto"/>
                        </a>
                        <h6 class="slider-title mt-2">${rp.item_name}</h6>

                        <!-- 평점 리뷰 적용 -->
						<c:set var="reviewCnt" value="${empty rp.review_cnt ? 0 : rp.review_cnt}" />
						<c:set var="rating" value="${empty rp.avg_rating ? 0 : rp.avg_rating}" />
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
								<fmt:formatNumber value="${rating}" pattern="#.0"/>
								<c:if test="${reviewCnt > 0}"> (${reviewCnt}개 리뷰)</c:if>
							</div>
						</c:if>

                        <c:choose>
                            <c:when test="${not empty rp.dis_rate and rp.dis_rate > 0}">
                                <c:set var="discounted" value="${rp.sales_p * (100 - rp.dis_rate) / 100}" />
                                <div class="d-flex flex-column">
                                    <h6 class="text-muted mb-0" style="font-size: 0.8rem;">
                                        <del><fmt:formatNumber value="${rp.sales_p}" pattern="#,###" />원</del>
                                    </h6>
                                    <fmt:parseNumber var="flooredPrice" value="${discounted / 10}" integerOnly="true" />
                                    <h6><fmt:formatNumber value="${flooredPrice * 10}" pattern="#,###" />원</h6>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <h6><fmt:formatNumber value="${rp.sales_p}" pattern="#,###" />원</h6>
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
	style="width:1400px; margin-left:-50px; ">
		<div class="row px-xl-5 pt-3" style="margin-left:-90px;">
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
		<button id="new-chat-btn"
			style="display: none; width: 100%; padding: 10px; background: #4CAF50; color: white; border: none; cursor: pointer;">
			새 채팅 시작</button>
	</div>

	<!-- ▣ 채팅 열기 버튼 -->
	<button id="chat-open" class="chat-open-btn">💬</button>
	<div class="toast-container" id="toast-container"></div>

	<!-- JavaScript Libraries -->
	<!-- jQuery 먼저 -->

	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="lib/easing/easing.min.js"></script>
	<script src="lib/owlcarousel/owl.carousel.min.js"></script>

	<!-- Contact Javascript File -->
	<script src="mail/jqBootstrapValidation.min.js"></script>
	<script src="mail/contact.js"></script>
	
	<!-- 로그인 ID 주입 (chat.js보다 위에) -->
	<script>
		const myId = "${sessionScope.loginUser.customer_id}";
		console.log("✅ myId 확인:", myId);
	</script>
	
	<!-- 채팅 JS -->
	<script src="/js/CustomerChat.js?v=999"></script>
	
	<!-- Main JS -->
	<script src="/js/main.js"></script>
	<!-- 리뷰 js -->	
	<script src="js/Review.js"></script>	

	<!-- SockJS + STOMPJS (chat.js보다 위에) -->
	<script
		src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

		
	

</body>

</html>