<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>결제</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<link href="img/favicon.ico" rel="icon">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
<link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
</head>

<body>
	<!-- Header 부분 -->
	<div class="row align-items-center py-3 px-xl-5">
		<div class="col-lg-3 d-none d-lg-block">
			<a href="/" class="text-decoration-none">
				<img src='../img/logo.png' class='logo' />
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
				<i class="fas fa-heart text-primary"></i> <span class="badge">0</span>
			</a>
			<a href="cart" class="btn border">
				<i class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span>
			</a>
		</div>
	</div>

	<!-- Navbar -->
	<div class="container-fluid">
		<div class="col-lg-9" aling="right">
			<nav class="navbar navbar-expand-lg bg-light navbar-light py-3 py-lg-0 px-0">
				<a href="" class="text-decoration-none d-block d-lg-none">
					<h1 class="m-0 display-5 font-weight-semi-bold">
						<span class="text-primary font-weight-bold border px-3 mr-1">E</span>Shopper
					</h1>
				</a>
				<button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
					<span class="navbar-toggler-icon"></span>
				</button>
				<div class="collapse navbar-collapse justify-content-between" id="navbarCollapse">
					<div class="navbar-nav ml-auto py-0" style="padding-left:-50px;margin-right:-35%;">
						<a href="login" class="nav-item nav-link">로그인</a> 
						<a href="register" class="nav-item nav-link">회원가입</a> 
						<a href="board" class="nav-item nav-link">고객센터</a>
					</div>
				</div>
			</nav>
		</div>
	</div>

	<!-- Page Header -->
	<div class="container-fluid bg-secondary mb-5" align="center">
		<div class="d-flex flex-column align-items-center justify-content-center" style="min-height: 300px">
			<h1 class="font-weight-semi-bold text-uppercase mb-3">결제창</h1>
			<div class="d-inline-flex">
				<p class="m-0"><a href="">Home</a></p>
				<p class="m-0 px-2">-</p>
				<p class="m-0">payment</p>
			</div>
		</div>
	</div>

	
	<!-- Checkout Start -->
<div class="container-fluid pt-5">
 <form id="checkoutForm" method="post"  action="/order/submit">
    <div class="row px-xl-5">
        <!-- 왼쪽: 주소 입력 -->
        <div class="col-lg-8">
            <div class="mb-4">
                <h4 class="font-weight-semi-bold mb-4">주소 입력</h4>
                <div class="row">
                    <div class="col-md-6 form-group">
                        <label>이름</label>
                        <input class="form-control" type="text" id="Name" name="name" 
                               placeholder="이름을 입력해주세요"
                               value="${name}"
                               onfocus="this.placeholder=''"
                               onblur="this.placeholder='이름을 입력해주세요'">
                        <small id="NameError" class="text-danger"></small>
                        <c:if test="${not empty nameError}">
                            <small class="text-danger">${nameError}</small>
                        </c:if>
                    </div>
                    <div class="col-md-6 form-group">
                        <label>이메일</label>
                        <input class="form-control" type="email" id="Email" name="email" 
                               placeholder="이메일을 입력해주세요"
                               value="${email}"
                               onfocus="this.placeholder=''"
                               onblur="this.placeholder='이메일을 입력해주세요'">
                        <small id="EmailError" class="text-danger"></small>
                        <c:if test="${not empty emailError}">
                            <small class="text-danger">${emailError}</small>
                        </c:if>
                    </div>
                    <div class="col-md-6 form-group">
                        <label>전화번호</label>
                        <input class="form-control" type="tel" id="Phone" name="phone"
                               placeholder="전화번호를 입력해주세요"
                               value="${phone}"
                               onfocus="this.placeholder=''"
                               onblur="this.placeholder='전화번호를 입력해주세요'">
                        <small id="PhoneError" class="text-danger"></small>
                        <c:if test="${not empty phoneError}">
                            <small class="text-danger">${phoneError}</small>
                        </c:if>
                    </div>
                    <div class="col-md-6 form-group">
                        <label>주 소</label>
                        <input class="form-control" type="text" id="Address" name="address" 
                               placeholder="주소를 입력해주세요"
                               value="${address}"
                               onfocus="this.placeholder=''"
                               onblur="this.placeholder='주소를 입력해주세요'">
                        <small id="AddressError" class="text-danger"></small>
                        <c:if test="${not empty addressError}">
                            <small class="text-danger">${addressError}</small>
                        </c:if>
                    </div>
                </div>
                <div class="col-md-6 form-group">
                    <label style="padding-right:-50px; margin-top:30px;">지역선택</label>
                    <select class="custom-select" name="region" style="margin-left:-15px;">
                        <option selected>서울특별시</option>
                        <option>경기도</option>
                        <option>대전광역시</option>
                        <option>광주광역시</option>
                    </select>
                    <div class="col-md-12 form-group">
                        <div class="custom-control custom-checkbox">
                            <input type="checkbox" class="custom-control-input" id="newaccount">
                            <label class="custom-control-label" for="newaccount" style="margin-top:20px; margin-left:-25px;">위 내용과 동일</label>
                        </div>
                    </div>
                    <div class="col-md-12 form-group">
                        <div class="custom-control custom-checkbox">
                            <input type="checkbox" class="custom-control-input" id="shipto">
                            <label class="custom-control-label" for="shipto" data-toggle="collapse" data-target="#shipping-address" style="margin-top:5px; margin-left:-25px;">수령지주소입력</label>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 수령지 주소 -->
            <div class="collapse mb-4" id="shipping-address">
                <h4 class="font-weight-semi-bold mb-4">수령지 주소</h4>
                <div class="row">
                    <div class="col-md-6 form-group">
                        <label>이름</label>
                        <input class="form-control" type="text" id="shipName" name="shipName" 
                               placeholder="이름을 입력해주세요"
                               onfocus="this.placeholder=''"
                               onblur="this.placeholder='이름을 입력해주세요'">
                    </div>
                    <div class="col-md-6 form-group">
                        <label>전화번호</label>
                        <input class="form-control" type="tel" id="shipPhone" name="shipPhone" 
                               placeholder="전화번호를 입력해주세요"
                               onfocus="this.placeholder=''"
                               onblur="this.placeholder='전화번호를 입력해주세요'">
                               <small id="shipPhoneError" class="text-danger"></small>
                               
                    </div>
                    <div class="col-md-6 form-group">
                        <label>수령주소</label>
                        <input class="form-control" type="text" id="shipAddress" name="shipAddress" 
                               placeholder=" (수령주소가 다르면 직접입력해주세요.)"
                               onfocus="this.placeholder=''"
                               onblur="this.placeholder=' (수령주소가 다르면 직접입력해주세요.)'">
                    </div>
                    <div class="col-md-6 form-group">
                        <label>메모</label>
                        <select class="custom-select" id="memoSelect" name="memo">
                            <option selected>요청사항</option>
                            <option>문앞에 놓아주세요</option>
                            <option>경비실에 맡겨주세요</option>
                            <option>택배함에 넣어주세요</option>
                            <option value="direct">직접입력</option>
                        </select>
                        <input type="text" class="form-control mt-2" id="memoInput" name="memoInput" 
                               placeholder="요청사항 입력" style="display: none;">
                    </div>
                </div>
            </div>
        </div>

        <!-- 오른쪽: 주문서 및 결제 -->
        <div class="col-lg-4">
            <!-- 주문서 -->
            <div class="card border-secondary mb-5">
                <div class="card-header bg-secondary border-0">
                    <h4 class="font-weight-semi-bold m-0">주문서</h4>
                </div>
                <div class="card-body">
                    <h5 class="font-weight-medium mb-3">상품</h5>
                    <c:forEach var="ci" items="${cartItems}">
                        <div class="d-flex justify-content-between">
                            <p>${ci.product.item_name}x ${ci.qty}</p>
                            <p>${ci.subtotal}원</p>
                        </div>
                    </c:forEach>
                    <hr class="mt-0">
                    <div class="d-flex justify-content-between mb-3 pt-1">
                        <h6 class="font-weight-medium">상품수량</h6>
                        <h6 class="font-weight-medium">
                            <span id="cartCount">${cartCount}</span>
                        </h6>
                    </div>
                </div>
                <div class="card-footer border-secondary bg-transparent">
                    <div class="d-flex justify-content-between mt-2">
                        <h5 class="font-weight-bold">총 금액</h5>
                        <h5 class="font-weight-bold">
                            <span id="cartTotal">${cartTotal}원</span>
                        </h5>
                    </div>
                </div>
            </div>

            <!-- 결제 방식 선택 카드 -->
            <div class="card border-secondary mb-5">
                <div class="card-header bg-secondary border-0">
                    <h4 class="font-weight-semi-bold m-0">결제방식</h4>
                </div>
                <div class="card-body">
                    <!-- 결제 방식 라디오 버튼 -->
                    <div class="form-group">
                        <div class="custom-control custom-radio" style="padding-top:10px;">
									<input type="radio" class="custom-control-input" name="payment"
										id="paypal" value="card" data-toggle="modal"
										data-target="#payModal"> <label class="custom-control-label" for="paypal">카드결제</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="custom-control custom-radio">
                            <input type="radio" class="custom-control-input" name="payment" id="directcheck" value="bank">
                            <label class="custom-control-label" for="directcheck">계좌이체</label>
                        </div>
                        <div class="form-group" id="bankInfo" style="display: none;">
                            <p>국민은행 123-456-7890</p>
                        </div>
                    </div>

                    <!-- 기타 결제 (네이버페이, 카카오페이) -->
                    <div class="tab-pane fade show active" id="social" role="tabpanel">
                        <div class="text-center mb-4">
                            <button type="button" id="naverPayBtn" class="btn btn-light border d-block mb-2 py-2 social-btn">
                                <img src="/img/naver.png"> NaverPay로 결제
                            </button>
                            <button type="button" id="kakaoPayBtn" class="btn btn-light border d-block py-2 social-btn">
                                <img src="/img/kakao.png"> KakaoPay로 결제
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 결제하기 버튼 -->
                <div class="card-footer border-secondary bg-transparent">
                    <c:choose>
                        <c:when test="${empty cartItems or cartCount == 0}">
                            <button type="button" class="btn btn-block btn-secondary my-3 py-3" disabled>
                                장바구니가 비어있습니다
                            </button>
                        </c:when>
                        <c:otherwise>
									<button type="submit"
										class="btn btn-block btn-primary my-3 py-3">결제하기</button>
								</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    </form>
</div>
	<!-- FORM 끝 -->
	
	<!-- Footer -->
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
									<span>stockbob 소개</span> &nbsp;&nbsp; | &nbsp;&nbsp;
									<span>이용약관</span> &nbsp; | &nbsp;
									<span>개인정보처리방침</span> &nbsp; | &nbsp;
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
					&copy; <a class="text-dark font-weight-semi-bold" href="#">Your Site Name</a>. All Rights Reserved.
				</p>
			</div>
			<div class="col-md-6 px-xl-0 text-center text-md-right">
				<img class="img-fluid" src="img/payments.png" alt="">
			</div>
		</div>
	</div>

	<!-- Back to Top -->
	<a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>

	<!-- 결제 모달 -->
	<div class="modal fade" id="payModal" tabindex="-1">
		<div class="modal-dialog modal-dialog-centered modal-lg">
			<div class="modal-content">
				<div class="modal-header bg-primary text-white">
					<h5 class="modal-title">결제하기</h5>
					<button type="button" class="close text-white" data-dismiss="modal">&times;</button>
				</div>
				<div class="modal-body">
					<h5><b>카드사 선택</b></h5>
					<div class="row text-center mt-3">
						<div class="col-4">
							<button class="btn btn-outline-primary btn-block card-btn" onclick="selectCard('국민')">국민</button>
						</div>
						<div class="col-4">
							<button class="btn btn-outline-primary btn-block card-btn" onclick="selectCard('현대')">현대</button>
						</div>
						<div class="col-4">
							<button class="btn btn-outline-primary btn-block card-btn" onclick="selectCard('농협')">농협</button>
						</div>
						<div class="col-4">
							<button class="btn btn-outline-primary btn-block card-btn" onclick="selectCard('카카오뱅크')" style="margin-bottom:20px;">카카오뱅크</button>
						</div>
					</div>
					<p id="selectedCardDisplay" class="mt-3" style="color: #D19C97; font-weight: bold;"></p>
					<hr>
					<h5 class="mt-3"><b>결제금액</b></h5>
					<h4 class="text-primary font-weight-bold">${cartTotal}원</h4>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary btn-lg" onclick="processPayment()">결제진행</button>
				</div>
			</div>
		</div>
	</div>

	<!-- JavaScript Libraries -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="lib/easing/easing.min.js"></script>
	<script src="lib/owlcarousel/owl.carousel.min.js"></script>
	<script src="mail/jqBootstrapValidation.min.js"></script>
	<script src="mail/contact.js"></script>
	<script src="js/main.js"></script>
	<script src="js/checkout.js"></script>
</body>
</html>