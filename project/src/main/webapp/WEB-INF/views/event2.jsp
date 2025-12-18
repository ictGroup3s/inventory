<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%><!DOCTYPE html>
<html lang="en">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<head>
    <meta charset="utf-8">
    <title>StockBob</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="Free HTML Templates" name="keywords">
    <meta content="Free HTML Templates" name="description">

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet"> 

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/style.css" rel="stylesheet">
</head>

<body>
    <!-- Topbar Start -->
    
        <div class="row align-items-center py-3 px-xl-5" style="margin-left:60px;">
            <div class="col-lg-3 d-none d-lg-block">
                <a href="/" class="text-decoration-none">
                    <img src='../img/logo.png' class='logo'/>
                    <!-- <h1 class="m-0 display-5 font-weight-semi-bold">
                    <span class="text-primary font-weight-bold border px-3 mr-1">E</span>Shopper</h1> -->
                </a>
            </div>
         	<div class="col-lg-6 col-6 text-left">
			<form action="selectall" method="get" style="margin-left:20px; margin-right:80px;">
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
            <div class="col-lg-3 col-6 text-right" style="margin-left:-102px;">
                
                <a href="cart" class="btn border">
                    <i class="fas fa-shopping-cart text-primary"></i>
                    <span class="badge">0</span>
                </a>
            </div>
        </div>
    </div>
    <!-- Topbar End -->


    <!-- Navbar Start -->
    <div class="container-fluid pt-0">
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
            <div class="col-lg-9">
                <nav class="navbar navbar-expand-lg bg-light navbar-light py-3 py-lg-0 px-0">
                    <a href="" class="text-decoration-none d-block d-lg-none">
						<img src='../img/logo.png' class='logo'/>
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
                <div id="header-carousel" class="carousel slide" data-ride="carousel">
                    <div class="carousel-inner">
                        <div class="carousel-item active" style="height: 350px;" onclick="location.href='event1'">
                           <img class="img-fluid" src="img/main_event1.png" alt="Image">
                           <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                             
                            </div>
                        </div>
                        <div class="carousel-item" style="height: 350px;" onclick="location.href='event1'">
                         <img class="img-fluid" src="img/main_event2.png" alt="Image">
                          <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                               
                            </div>
                        </div>
                        
                        <div class="carousel-item" style="height:350px;"onclick="location.href='event2'">
                          <a href="event3">   <img class="img-fluid" src="img/main_event3.png" alt="Image">
                           </a> <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                                
                            </div>
                        </div>
                    </div>
                   <a class="carousel-control-prev" href="#header-carousel" data-slide="prev">
                        <div class="btn btn-dark" style="width: 45px; height: 45px;">
                            <span class="carousel-control-prev-icon mb-n2"></span>
                        </div>
                    </a>
                    <a class="carousel-control-next" href="#header-carousel" data-slide="next">
                        <div class="btn btn-dark" style="width: 45px; height: 45px;">
                            <span class="carousel-control-next-icon mb-n2"></span>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>


   <!-- Products Start -->
  <div class="container-fluid pt-2" style="margin-left:-40px;">
        <div class="text-center mb-4" style="margin-top:70px; ">
            <h3 class="section-title px-5"><span class="px-2">새 상품</span></h3>
        </div>
        
   <div class="row px-xl-5 pb-3"> 
  	<c:forEach var="item" items="${newArrivals}">
  	<div class="col-lg-4 col-md-4 col-sm-4 pb-1" >
	<div class="card product-item border-0 mb-4 w-76 mx-auto" style="width: 270px;"> 
	<div class="card-header product-img position-relative overflow-hidden bg-transparent border p-0">
	<a href="detail?item_no=${item.item_no}"> 
<img src="/img/product/${item.item_img}" width="270" height="250" alt="${item.item_name}" style="object-fit: cover;" />
	</a>
		</div>
		<div class="card-body border-left border-right text-center p-0 pt-4 ">
		<h5 class="text-truncate mb-3">${item.item_name}</h5>
		<div class="d-flex justify-content-center">
		<h5>${item.sales_p}원</h5>
		</div>
		</div>
<div class="card-footer d-flex justify-content-between bg-light border">
		<a href="detail?item_no=${item.item_no}" class="btn btn-sm text-dark p-0"> 
		<i class="fas fa-eye text-primary mr-1"></i>상세정보</a>
	<form method="post" action="/cart/addForm" style="display: inline;">
		<input type="hidden" name="item_no" value="${item.item_no}" />
		<input type="hidden" name="qty" value="1" />
	<button type="button" class="btn btn-sm text-dark p-0 add-to-cart-btn" data-item-no="${item.item_no}"
		style="background: none; border: 0; padding: 0;">
	<i class="fas fa-shopping-cart text-primary mr-1"></i>장바구니 담기</button>
     </form>
      </div>
         </div>
            </div>
</c:forEach></div>
    <!-- Products End -->
      <!-- 페이지 네비게이션 -->
    <div class="pagination-container" >
       <ul class="pagination justify-content-center mb-3">
            <!-- 이전 페이지 버튼 -->
            <c:if test="${currentPage > 1}">
                <li class="page-item">
                    <a class="page-link" href="event1?page=${currentPage - 1}&size=${size}">이전</a>
                </li>
            </c:if>
            <!-- 페이지 번호 버튼들 -->
            <c:forEach var="i" begin="1" end="${totalPages}">
                <li class="page-item <c:if test="${i == currentPage}">active</c:if>">
                    <a class="page-link" href="event1?page=${i}&size=${size}">${i}</a>
                </li>
            </c:forEach>

            <!-- 다음 페이지 버튼 -->
            <c:if test="${currentPage < totalPages}">
                <li class="page-item">
                    <a class="page-link" href="event1?page=${currentPage + 1}&size=${size}">다음</a>
                </li>
            </c:if>
        </ul>
    </div>
      <!-- 다른 이벤트페이지 링크 -->  
     <!-- Offer Start  -->
    <div class="container-fluid offer pt-5">
          <div class="row px-xl-5 justify-content-end">
            <div class="col-md-6 pb-4">
                <div class="position-relative bg-secondary text-center text-md-right text-white mb-2 py-2 px-5">
                    <img src="img/bingsu.png" alt="">
                    <div class="position-relative" style="z-index: 1;">
                        <h5 class="text-uppercase text-primary mb-3">season off</h5>
                        <h1 class="mb-4 font-weight-semi-bold">Discount</h1>
                      </div>
                        <a href="event1" class="btn btn-outline-primary py-md-2 px-md-3">Shop Now</a>
                       
                </div>
            </div>
        </div>
    </div>
 <!-- Offer End  -->
 
	<!-- 상품 목록 페이지 이동 끝 -->
<!-- Footer Start -->
	<div class="container-fluid bg-secondary text-dark mt-3 pt-3 pb-2" 	style="width:1350px; margin-left:-30px;" >
		<div class="row px-xl-5 pt-3" style="margin-left:-100px;">
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
		<div class="row border-top border-light py-4" style="margin-left:-60px; margin-right:60px;">
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
    <a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>


    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="lib/easing/easing.min.js"></script>
    <script src="lib/owlcarousel/owl.carousel.min.js"></script>

    <!-- Contact Javascript File -->
    <script src="mail/jqBootstrapValidation.min.js"></script>
    <script src="mail/contact.js"></script>

    <!-- Template Javascript -->
    <script src="js/main.js"></script>
</body>

</html>