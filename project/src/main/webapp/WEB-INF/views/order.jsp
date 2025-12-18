<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 이거 추가! --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>주문관리</title>
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
<link rel="stylesheet" href="css/stats.css">
<link rel="stylesheet" href="css/order.css">




</head>
<body
	class="${empty sessionScope.loginUser || sessionScope.loginRole != '1' ? 'hide-content' : ''}">
	<%-- 관리자 아니면 모달 띄우고 페이지 내용 숨김 --%>
	<c:if
		test="${empty sessionScope.loginUser || sessionScope.loginRole != '1'}">
		<div class="admin-overlay"></div>
		<div class="login-modal">
			<div class="lock-icon">🔒</div>
			<h3>로그인이 필요합니다</h3>
			<p>
				관리자 페이지에 접근하려면<br>먼저 로그인해주세요.
			</p>
			<%-- 현재 페이지 이름만 전달 --%>
			<a href="login?redirectURL=order" class="btn-login"
				style="display: block; text-decoration: none;">로그인</a> <a
				href="${pageContext.request.contextPath}/" class="btn-home"
				style="display: block; text-decoration: none;">홈으로</a>
		</div>
	</c:if>

	<%-- 관리자일 때만 보이는 실제 내용 --%>
	<div class="admin-content">
		<!-- 기존 관리자 페이지 내용 -->

		<!-- Topbar -->
		<div class="row align-items-center py-3 px-xl-5 bg-light">
			<div class="col-lg-3 d-none d-lg-block">
				<a href="/" class="text-decoration-none"> <img
					src="img/logo.png" class="logo" />
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
				<a href="#" class="btn border"><i
					class="fas fa-heart text-primary"></i> <span class="badge">0</span></a>
				<a href="cart" class="btn border"><i
					class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span></a>
			</div>
		</div>

		<!-- Main Layout -->
		<div class="container-fluid">
			<div class="row px-xl-5">
				<div class="col-lg-1">
					<!-- Sidebar -->
					<nav class="category-sidebar">
						<h6>관리자 페이지</h6>
						<ul class="nav flex-column">
							<li class="nav-item"><a href="dashboard" class="nav-link">대쉬보드</a></li>
							<li class="nav-item"><a href="item" class="nav-link">상품관리</a></li>
							<li class="nav-item"><a href="stock" class="nav-link">입고/재고관리</a></li>
							<li class="nav-item"><a href="order" class="nav-link active">주문관리</a></li>
							<li class="nav-item"><a href="stats" class="nav-link">통계</a></li>
							<li class="nav-item"><a href="mlist" class="nav-link">고객관리</a></li>
							<li class="nav-item"><a href="board" class="nav-link">고객센터</a></li>
						</ul>
					</nav>
				</div>

				<!-- Content -->
				<div class="col-lg-11 dashboard-content">
					<h3 class="mb-4">주문관리</h3>

					<!-- ✅ 안내 문구 추가 -->
					<p class="text-muted mb-2" style="font-size: 14px;">
						<i class="fas fa-info-circle"></i> 최근 1개월 주문만 표시됩니다. 이전 주문은 날짜 검색을
						이용해주세요.
					</p>

					<!-- 주문 검색 -->
					<form class="form-inline mb-3 flex-wrap" id="searchForm">
						<input type="text" class="form-control mr-2 mb-2"
							id="searchOrderNo" placeholder="주문번호" style="width: 120px;">
						<input type="text" class="form-control mr-2 mb-2"
							id="searchCustomer" placeholder="고객명" style="width: 120px;">
						<select class="form-control mr-2 mb-2" id="searchStatus"
							style="width: 130px;">
							<option value="">전체 상태</option>
							<option value="결제완료">결제완료</option>
							<option value="배송준비중">배송준비중</option>
							<option value="배송중">배송중</option>
							<option value="배송완료">배송완료</option>
							<option value="취소">취소</option>
							<option value="반품">반품</option>
							<option value="교환">교환</option>
						</select> <input type="date" class="form-control mr-2 mb-2"
							id="searchStartDate" style="width: 150px;"> <span
							class="mr-2 mb-2">~</span> <input type="date"
							class="form-control mr-2 mb-2" id="searchEndDate"
							style="width: 150px;">
						<div class="btn-group mb-2">
							<button type="submit" class="btn btn-primary">검색</button>
							<button type="button" class="btn btn-secondary" id="resetBtn">초기화</button>
						</div>
					</form>

					<!-- 주문 목록 테이블 -->
					<div class="table-responsive">
						<table class="table table-bordered order-table">
							<thead class="thead-light">
								<tr>
									<th class="col-order-no">주문번호</th>
									<th class="col-customer">고객명</th>
									<th class="col-items">상품</th>
									<th class="col-amount">총 금액</th>
									<th class="col-date">주문일</th>
									<th class="col-status">상태</th>
									<th class="col-action">관리</th>
								</tr>
							</thead>
							<tbody id="orderTableBody">
								<!-- JS로 채움 -->
							</tbody>
						</table>
					</div>

					<!-- 페이징 -->
					<nav>
						<ul class="pagination justify-content-center" id="pagination">
						</ul>
					</nav>
				</div>
			</div>
		</div>

		<!-- 주문 상세 모달 -->
		<div class="modal fade" id="orderModal" tabindex="-1">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">주문 상세정보</h5>
						<button type="button" class="close" data-dismiss="modal">
							<span>&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<!-- 주문 기본 정보 -->
						<div class="row mb-4">
							<div class="col-md-6">
								<p>
									<span class="order-info-label">주문번호:</span> <span
										id="modalOrderNo"></span>
								</p>
								<p>
									<span class="order-info-label">주문일시:</span> <span
										id="modalOrderDate"></span>
								</p>
								<p>
									<span class="order-info-label">결제수단:</span> <span
										id="modalPayment"></span>
								</p>
							</div>
							<div class="col-md-6">
								<p>
									<span class="order-info-label">고객 ID:</span> <span
										id="modalCustomerId"></span>
								</p>
								<p>
									<span class="order-info-label">총 결제금액:</span> <strong
										class="text-primary">₩<span id="modalTotalAmount"></span></strong>
								</p>
							</div>
						</div>

						<hr>

						<!-- 배송 정보 -->
						<!-- 배송 정보 -->
						<div
							class="d-flex justify-content-between align-items-center mb-3">
							<h6 class="mb-0">
								<i class="fas fa-truck mr-2"></i>배송 정보
							</h6>
							<button type="button" class="btn btn-sm btn-outline-secondary"
								id="editShippingBtn">
								<i class="fas fa-edit"></i> 수정
							</button>
						</div>
						<div class="row mb-4">
							<div class="col-md-6">
								<div class="form-group">
									<label class="order-info-label">수령자명</label> <input type="text"
										class="form-control shipping-input" id="modalOrderName"
										readonly>
								</div>
							</div>
							<div class="col-md-6">
								<div class="form-group">
									<label class="order-info-label">연락처</label> <input type="text"
										class="form-control shipping-input" id="modalOrderPhone"
										readonly>
								</div>
							</div>
							<div class="col-12">
								<div class="form-group">
									<label class="order-info-label">배송주소</label> <input type="text"
										class="form-control shipping-input" id="modalOrderAddr"
										readonly>
								</div>
							</div>
						</div>

						<hr>

						<!-- 주문 상품 목록 -->
						<h6 class="mb-3">
							<i class="fas fa-box mr-2"></i>주문 상품
						</h6>
						<table class="table table-sm order-items-table">
							<thead>
								<tr>
									<th>상품명</th>
									<th>수량</th>
									<th>단가</th>
									<th>금액</th>
									<th>상태</th>
									<th>관리</th>
								</tr>
							</thead>
							<tbody id="modalOrderItems">
							</tbody>
						</table>

						<hr>

						<!-- 배송 상태 관리 -->
						<h6 class="mb-3">
							<i class="fas fa-cog mr-2"></i>배송 상태 관리
						</h6>
						<div class="row">
							<div class="col-md-6">
								<div class="form-group">
									<label class="order-info-label">주문 상태</label> <select
										class="form-control" id="modalStatus">
										<option value="결제완료">결제완료</option>
										<option value="배송준비중">배송준비중</option>
										<option value="배송중">배송중</option>
										<option value="배송완료">배송완료</option>
										<option value="취소">취소</option>
										<option value="반품">반품</option>
										<option value="교환">교환</option>
									</select>
								</div>
							</div>
							<div class="col-md-6">
								<div class="form-group">
									<label class="order-info-label">운송장번호</label> <input
										type="text" class="form-control" id="modalTracking"
										placeholder="운송장번호 입력">
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-dismiss="modal">닫기</button>
						<button type="button" class="btn btn-primary" id="saveOrderBtn">저장</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- JS -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="js/main.js"></script>
	<script src="js/order.js"></script>

</body>
</html>