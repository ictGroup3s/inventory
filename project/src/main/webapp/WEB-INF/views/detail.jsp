<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>상세정보</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="Free HTML Templates" name="keywords">
<meta content="Free HTML Templates" name="description">
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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

</head>

<body>
<!-- ############## 로고부분 ############################## -->
	<div class="row align-items-center py-3 px-xl-5" style="height:150px;">
		 <div class="col-lg-3 d-none d-lg-block"><!-- 큰 화면에서는 3/12, 작은 화면에서는 숨김 -->
			<a href="/" class="text-decoration-none"> <img
				src="\img\logo.png" class='logo' />
			</a>
		</div>
		
		<div class="col-lg-6 col-6 text-left">
			<form action="">
				<div class="input-group">
					<input type="text" class="form-control"	placeholder="Search for products">
					<div class="input-group-append">
						<span class="input-group-text bg-transparent text-primary">
							<i class="fa fa-search"></i>
						</span>
					</div>
				</div>
			</form>
		</div>
		<div class="col-lg-3 col-6 text-right">
			<a href="" class="btn border"> 
			<i class="fas fa-heart text-primary"></i> 
			<span class="badge">0</span>
			</a> <a href="cart" class="btn border"> <i
				class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span>
			</a>
		</div>
	</div>
	</div>
	<!-- Topbar End -->


	<!-- Navbar Start ########### 카테고리 메뉴바 ##############-->
	<div class="container-fluid pt-5" >
		<div class="row px-xl-5">
		 <!-- ================== 왼쪽 카테고리 ================== -->
            <div class="col-lg-2 col-md-12 d-none d-lg-block">
				<nav class="category-sidebar">
					<h6 class="p-3">상품 카테고리</h6>
					<ul class="nav flex-column">
						<li class="nav-item"><a href="selectall" class="nav-link active">전체상품</a></li>
						<li class="nav-item"><a href="selectGui" class="nav-link">구이 ．찜 ．볶음</a></li>
						<li class="nav-item"><a href="selectSoup" class="nav-link">국 ．밥 ．면</a></li>
						<li class="nav-item"><a href="selectDiet" class="nav-link">식단관리</a></li>
						<li class="nav-item"><a href="selectBunsik" class="nav-link">분식 ．간식</a></li>
						<li class="nav-item"><a href="selectBanchan" class="nav-link">반찬 ．소스</a></li>
						<li class="nav-item"><a href="selectRecipe" class="nav-link">레시피</a></li>
					</ul>
				</nav>
			</div>

			 <div class="col-lg-10 col-md-12 p-0 m-0" >
			 <div class="col-lg-10 col-md-12 p-0 m-0" >
				<nav class="navbar navbar-expand-lg bg-light navbar-light py-0 py-lg-0 px-0">
					<a href="/" class="text-decoration-none d-block d-lg-none p-0 m-0"> 
					<img src="\img\logo.png" class='logo' />
					</a>
					<button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
						<span class="navbar-toggler-icon"></span>
					</button>
					<div class="collapse navbar-collapse justify-content-between" id="navbarCollapse">
						<div class="navbar-nav ml-auto py-0 p-0 m-0">
							<a href="login" class="nav-item nav-link py-1">로그인</a> 
							<a href="register" class="nav-item nav-link py-1" >회원가입</a> 
							<a href="board" class="nav-item nav-link py-1">고객센터</a>
						</div>
					</div>
				</nav>
			</div>
	<!-- Shop Detail Start ######## 이미지 파일 #########################-->
<div class="container py-4">
    <div class="d-flex flex-wrap align-items-center">
        <!-- 이미지 -->
        <div class="p-2 flex-shrink-0">
            <img src="/img/product/${product.item_img}" alt="${product.item_name}"  width="350px" heigh="400px">
        </div>
         <div class="p-2 flex-grow-1">
            <h3 class="font-weight-semi-bold">${product.item_name}</h3>
            
            <div class="d-flex mb-2 align-items-center">
               		<small class="pt-1">(3 Reviews)</small> </div>
               		
				<h4 class="font-weight-semi-bold mb-2">가격: ${product.sales_p}원</h4>
				<p class="mb-4"> </p> <!-- 내용쓰러면 작은글 출력됨 -->
		
				
				<div class="d-flex mb-3">
			</div>
			
		
		<form action="/cart/addForm" method="post">
			<input type="hidden" name="item_no" value="${product.item_no}" />

	 <div class="d-flex align-items-center mb-3">
	     <!-- 수량 조절 -->
        <div class="input-group mr-2  quantity" style="width:130px;">		
        <button type="button" class="btn btn-primary btn-minus">-</button>
        <input type="text" class="form-control text-center" name="qty" id="qty" value="1">
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
		<div class="row px-xl-5">
			<div class="col">
				<div
					class="nav nav-tabs justify-content-center border-secondary mb-4">
					<a class="nav-item nav-link"
						data-toggle="tab" href="#tab-pane-2">상품정보</a> <a
						class="nav-item nav-link" data-toggle="tab" href="#tab-pane-3">리뷰
						(0)</a>
				</div>
				<div class="tab-content">
					<div class="tab-pane fade" id="tab-pane-2">
						<h4 class="mb-3">상품 상세정보</h4>
						<div class="row">
							<div class="col-md-6">
								<ul class="list-group list-group-flush">
									<li class="list-group-item px-0">알레르기 정보</li>
									<li class="list-group-item px-0">밀,계란 함유</li>
										<li class="list-group-item px-0">대추, 고등어, 게, 새우, 오징어, 조개류(굴,전복,홍합포함)와 같은 시설에서 제조</li>
								</ul>
							</div>
							<div class="col-md-6">
								<ul class="list-group list-group-flush">
									<li class="list-group-item px-0">    </li>
										
							
								</ul>
							</div>
						</div>
					</div>
					<div class="tab-pane fade" id="tab-pane-3">
						<div class="row">
							<div class="col-md-6">
								<h4 class="mb-4">1 review for "최고에요"</h4>
								<div class="media mb-4">
									<img src="img/user.jpg" alt="Image" class="img-fluid mr-3 mt-1"
										style="width: 45px;">
									<div class="media-body">
										<h6>
											홍길동<small> - <i>01 Jan 2025</i></small>
										</h6>
										<p>정말 바삭하고 맛있어요.</p>
									</div>
								</div>
							</div>
							<div class="col-md-6">
								<h4 class="mb-4">리뷰 작성</h4>
								<form>
									<div class="form-group">
										<label for="message">내 리뷰작성 *</label>
										<textarea id="message" cols="30" rows="5" class="form-control"></textarea>
									</div>
									<div class="form-group">
										<label for="name">이름 *</label> <input type="text"
											class="form-control" id="name">
									</div>
									<div class="form-group">
										<label for="email">이메일 *</label> <input type="email"
											class="form-control" id="email">
									</div>
									<div class="form-group mb-0">
										<input type="submit" value="리뷰 남기기"
											class="btn btn-primary px-3">
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Shop Detail End -->
	
<!-- Image Slider Start -->
<div class="container py-5">
   <ul class="bxslider">
    <li>
        <div class="slider-card" data-item-no="129">
           <img src="/img/product/1764664988078_감자채볶음.png" alt="감자채볶음" />
            <h5 class="slider-title">햄감자채볶음</h5>
            <p class="slider-price">4,000원</p>
        
        <button class="btn btn-primary slider-cart" data-item-no="129">장바구니 담기</button>
        </div>
    </li>
        <li>
    <div class="slider-card">
     <a href="productDetail.jsp?id=1">
     <img src="img/fish.png" alt="Slider Image 2" /></a>
      <h5 class="slider-title">고등어구이</h5>
        <p class="slider-price">12,000원</p>
         <button class="btn btn-primary slider-cart" >장바구니 담기</button>
            </div>
        </li> 
     <li>
    <div class="slider-card">
       <img src="img/egg.png" alt="Slider Image 3" />
      <h5 class="slider-title">계란세트</h5>
        <p class="slider-price">12,000원</p>
         <button class="btn btn-primary slider-cart">장바구니 담기</button>
            </div>
        </li> 
     <li>
    <div class="slider-card">
       <img src="img/oven.png" alt="Slider Image 4" />
      <h5 class="slider-title">파스타</h5>
        <p class="slider-price">12,000원</p>
         <button class="btn btn-primary slider-cart">장바구니 담기</button>
            </div>
        </li> 
     </ul>
</div>
<!-- Image Slider End -->

	 <!-- Footer Start -->
    <div class="container-fluid bg-secondary text-dark mt-5 pt-0 pb-2" style="margin-top: 0px;">
				<div class="row px-xl-5 pt-2 pb-0">
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
                    <div class="col-md-4 mb-3 ">
                        <h5 class="font-weight-bold text-dark mt-4 mb-4">Quick Links</h5>
                        <div class="d-flex flex-column justify-content-start">
                            <a class="text-dark mb-2" href="/"><i class="fa fa-angle-right mr-2"></i>메인 홈</a>
                            <a class="text-dark mb-2" href="selectall"><i class="fa fa-angle-right mr-2"></i>상품페이지로 이동</a>
                     <!--  <a class="text-dark mb-2" href="mlist"><i class="fa fa-angle-right mr-2"></i>마이페이지</a>
                            <a class="text-dark mb-2" href="cart"><i class="fa fa-angle-right mr-2"></i>장바구니</a>
                            <a class="text-dark mb-2" href="checkout"><i class="fa fa-angle-right mr-2"></i>결제</a> -->      
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


	<!-- Back to Top -->
	<a href="#" class="btn btn-primary back-to-top"><i
		class="fa fa-angle-double-up"></i></a>


	<!-- JavaScript Libraries -->
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="lib/easing/easing.min.js"></script>
	<script src="lib/owlcarousel/owl.carousel.min.js"></script>

	<!-- Contact Javascript File -->
	<script src="mail/jqBootstrapValidation.min.js"></script>
	<script src="mail/contact.js"></script>

	<!-- Template Javascript -->
	<script src="js/main.js"></script>


</body>



</html>