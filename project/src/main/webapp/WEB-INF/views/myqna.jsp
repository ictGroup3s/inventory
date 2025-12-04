<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>1:1문의내역</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<!-- Favicon -->
<link href="img/favicon.ico" rel="icon">

<!-- Google Web Fonts -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

<!-- Customized Bootstrap Stylesheet -->
<link href="css/style.css" rel="stylesheet">
</head>

<body>
	<div class="row align-items-center py-3 px-xl-5">
		<div class="col-lg-3 d-none d-lg-block">
			<a href="/" class="text-decoration-none">
				<img src="\img\logo.png" class='logo' />
			</a>
		</div>
		<div class="col-lg-6 col-6 text-left">
			<form action="">
				<div class="input-group">
					<input type="text" class="form-control" placeholder="Search for products">
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
			</a>
			<a href="cart" class="btn border">
				<i class="fas fa-shopping-cart text-primary"></i>
				<span class="badge">0</span>
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
						<li class="nav-item"><a href="/orderhistory" class="nav-link">주문내역</a></li>
						<li class="nav-item"><a href="/mydelivery" class="nav-link">배송내역</a></li>
						<li class="nav-item"><a href="/mycs" class="nav-link">취소/반품/교환내역</a></li>
						<li class="nav-item"><a href="/myqna" class="nav-link active">1:1문의내역</a></li>
					</ul>
				</nav>
			</div>

			<!-- Main Content -->
			<div class="col-lg-10" style="margin-top: -30px; margin-bottom: 50px;">
				<div class="text-center mb-4">
					<h4>1:1문의내역</h4>
				</div>
				
				<div class="col-lg-10 mx-auto">
					<table class="table table-striped">
						<thead>
							<tr>
								<th>문의번호</th>
								<th>제목</th>
								<th>상태</th>
								<th>작성일</th>
								<th></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>1001</td>
								<td>배송 문의</td>
								<td>답변완료</td>
								<td>2025-12-01</td>
								<td>
									<button class="btn btn-sm btn-secondary" data-toggle="modal" data-target="#detailModal">
										상세보기
									</button>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 모달 -->
	<div class="modal fade" id="detailModal" tabindex="-1" role="dialog" aria-labelledby="detailModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="detailModalLabel">1:1문의 상세내역</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="row mb-3">
						<div class="col-md-6">
							<strong>문의번호:</strong> 1001
						</div>
						<div class="col-md-6">
							<strong>작성일:</strong> 2025-12-01
						</div>
					</div>
					<div class="row mb-3">
						<div class="col-md-6">
							<strong>제목:</strong> 배송 문의
						</div>
						<div class="col-md-6">
							<strong>상태:</strong> <span class="badge badge-success" style="background-color:#EDF1FF; color: black;">답변완료</span>
						</div>
					</div>
					<hr>
					<div class="row mb-3">
						<div class="col-md-12">
							<strong>문의 내용:</strong>
							<p class="mt-2 p-3" style="background-color: #f8f9fa; border-radius: 5px;">
								주문한 상품이 언제 도착하나요? 배송 조회가 되지 않아 문의 드립니다.
							</p>
						</div>
					</div>
					<div class="row mb-3">
						<div class="col-md-12">
							<strong>답변 내용:</strong>
							<p class="mt-2 p-3" style="background-color: #e7f3ff; border-radius: 5px;">
								안녕하세요. 고객님의 주문 상품은 12월 3일에 출고 예정입니다. 
								배송 완료까지 2-3일 정도 소요될 예정이며, 출고 시 송장번호를 별도로 안내해드리겠습니다. 
								감사합니다.
							</p>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<strong>처리 이력:</strong>
							<ul class="mt-2">
								<li>2025-12-01 14:30: 문의 접수</li>
								<li>2025-12-01 16:45: 답변 완료</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
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

	<!-- Back to Top -->
	<a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>

	<!-- JavaScript Libraries -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="lib/easing/easing.min.js"></script>
	<script src="lib/owlcarousel/owl.carousel.min.js"></script>

	<!-- Template Javascript -->
	<script src="js/main.js"></script>
</body>
</html>