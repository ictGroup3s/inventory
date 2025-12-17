<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>취소/반품/교환내역</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<!-- Favicon -->
<link href="img/favicon.ico" rel="icon">

<!-- Google Web Fonts -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

<!-- ⭐ Bootstrap CSS-->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">


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
			<div class="col-lg-2">
				<!-- Sidebar -->
				<nav class="category-sidebar">
					<h6>마이페이지</h6>
					<ul class="nav flex-column">
						<li class="nav-item"><a href="/mypage" class="nav-link">모든내역</a></li>
						<li class="nav-item"><a href="/orderhistory" class="nav-link">주문내역</a></li>
						<li class="nav-item"><a href="/mydelivery" class="nav-link">배송내역</a></li>
						<li class="nav-item"><a href="/mycs" class="nav-link active">취소·반품·교환내역</a></li>
						<li class="nav-item"><a href="/update" class="nav-link">내정보수정</a></li>
						<li class="nav-item"><a href="/delete" class="nav-link">회원탈퇴</a></li>
					</ul>
				</nav>
			</div>

			<!-- Main Content -->
			<div class="col-lg-10" style="margin-top: 30px; margin-bottom: 50px;">
				<div class="text-center mb-4">
					<h4>취소·반품·교환내역</h4>
				</div>
				<!-- 검색 결과 카운트 -->
				<p class="mb-2">
					총 <strong id="totalCount">${fn:length(crList)}</strong>건 <span
						id="searchResultText"></span>
				</p>

				<!-- ⭐ 검색 및 필터 섹션 ⭐ -->
				<div class="search-box">
					<div class="row mb-3">
						<div class="col-md-4">
							<div class="input-group">
								<select id="searchType" class="form-control"
									style="max-width: 140px;">
									<option value="all">전체</option>
									<option value="order_no">주문번호</option>
									<option value="item_name">상품명</option>
								</select> <input type="text" id="searchInput" class="form-control"
									placeholder="검색어입력">
								<div class="input-group-append">
									<button class="btn btn-primary" type="button"
										onclick="searchCR()">
										<i class="fa fa-search"></i> 검색
									</button>
								</div>
							</div>
						</div>
					</div>
					<!-- 메시지 표시 -->
					<c:if test="${not empty message}">
						<div
							class="alert alert-${messageType == 'success' ? 'success' : 'danger'} alert-dismissible fade show"
							role="alert">
							${message}
							<button type="button" class="close" data-dismiss="alert">&times;</button>
						</div>
					</c:if>
					<!-- 	 ⭐ 초기화 버튼 아래로 이동 ⭐
					<div class="text-left">
						<button class="btn btn-outline-secondary" onclick="resetSearch()">
							<i class="fa fa-redo"></i> 초기화
						</button>
					</div>
				</div> -->

					<table class="table table-striped" id="crTable">
						<thead>
							<tr>
								<th>주문번호</th>
								<th>상품명</th>
								<th>신청유형</th>
								<th>상태</th>
								<th>신청일</th>
								<th></th>
							</tr>
						</thead>
						<tbody id="crTableBody">
							<c:forEach var="cr" items="${crList}">
								<tr class="cr-row" data-order-no="${cr.order_no}"
									data-item-name="${cr.item_name}" data-type="${cr.type}"
									data-status="${cr.status}">
									<td>${cr.order_no}</td>
									<td>${cr.item_name}</td>
									<td><span
										class="badge 
									${cr.type == '취소' ? 'badge-warning' : 
									  cr.type == '반품' ? 'badge-info' : 'badge-success'}">
											${cr.type} </span></td>
									<td><span
										class="badge 
									${cr.status == '신청' ? 'badge-secondary' : 
									  cr.status == '처리중' ? 'badge-primary' : 
									  cr.status == '완료' ? 'badge-success' : 'badge-danger'}">
											${cr.status} </span></td>
									<td><fmt:formatDate value="${cr.re_date}"
											pattern="yyyy-MM-dd HH:mm" /></td>
									<td>
										<button class="btn btn-sm btn-secondary" data-toggle="modal"
											data-target="#detailModal_${cr.cr_no}">상세보기</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>

					<!-- 검색 결과 없음 메시지 -->
					<div id="noResultMessage" class="text-center py-4"
						style="display: none;">
						<i class="fas fa-search fa-3x text-muted mb-3"></i>
						<p class="text-muted">검색 결과가 없습니다.</p>
					</div>

					<!-- 데이터 없음 메시지 -->
					<c:if test="${empty crList}">
						<div class="text-center py-4">
							<i class="fas fa-inbox fa-3x text-muted mb-3"></i>
							<p class="text-muted">취소·반품·교환 신청 내역이 없습니다.</p>
						</div>
					</c:if>
				</div>
			</div>
		</div>
	</div>
	<!-- 상세보기 모달 (각 항목별) -->
	<c:forEach var="cr" items="${crList}">
		<div class="modal fade" id="detailModal_${cr.cr_no}" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">취소·반품·교환 상세내역</h5>
						<button type="button" class="close" data-dismiss="modal">
							<span>&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="row mb-3">
							<div class="col-md-6">
								<strong>신청번호:</strong> ${cr.cr_no}
							</div>
							<div class="col-md-6">
								<strong>주문번호:</strong> ${cr.order_no}
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-6">
								<strong>신청유형:</strong> ${cr.type}
							</div>
							<div class="col-md-6">
								<strong>상태:</strong> ${cr.status}
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-12">
								<strong>신청일:</strong> <fmt:formatDate value="${cr.re_date}" pattern="yyyy-MM-dd HH:mm:ss" />
							</div>
						</div>
						<c:if test="${not empty cr.return_cnt}">
							<div class="row mb-3">
								<div class="col-md-12">
									<strong>교환 상품번호:</strong> ${cr.return_cnt}
								</div>
							</div>
						</c:if>
						<hr>
						<div class="row mb-3">
							<div class="col-md-12">
								<strong>사유:</strong>
								<p class="mt-2">${cr.reason}</p>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
					</div>
				</div>
			</div>
		</div>
	</c:forEach>
	
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
	<!-- ⭐⭐⭐ JavaScript Libraries ⭐⭐⭐ -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>

</body>
</html>