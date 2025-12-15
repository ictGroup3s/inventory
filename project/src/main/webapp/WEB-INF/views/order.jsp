<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<link rel="stylesheet" href="css/order.css">


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
						<li class="nav-item"><a href="order" class="nav-link active">주문관리</a></li>
						<li class="nav-item"><a href="stats" class="nav-link">통계</a></li>
						<li class="nav-item"><a href="mlist" class="nav-link">고객관리</a></li>
						<li class="nav-item"><a href="board" class="nav-link">고객센터</a></li>
					</ul>
				</nav>
			</div>

			<!-- Content -->
			<div class="col-lg-10 dashboard-content">
				<h3 class="mb-4">주문관리</h3>

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
					<button type="submit" class="btn btn-primary mr-2 mb-2">검색</button>
					<button type="button" class="btn btn-secondary mb-2" id="resetBtn">초기화</button>
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
					<div class="d-flex justify-content-between align-items-center mb-3">
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
								<label class="order-info-label">운송장번호</label> <input type="text"
									class="form-control" id="modalTracking" placeholder="운송장번호 입력">
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

	<!-- JS -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="js/order.js"></script>

</body>
</html>