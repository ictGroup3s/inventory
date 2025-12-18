<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>마이페이지</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<link href="img/favicon.ico" rel="icon">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
<link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">

<!-- Favicon -->
<link href="/img/favicon.ico" rel="icon">

<!-- Google Web Fonts -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

<!-- Bootstrap CSS -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">

<!-- Customized Bootstrap Stylesheet -->
<link href="/css/style.css" rel="stylesheet">
</head>

<body>
<!-- Header 부분 -->
	<div class="row align-items-center py-3 px-xl-4" style="margin-left:90px;">
		<div class="col-lg-3 d-none d-lg-block">
			<a href="/" class="text-decoration-none">
				<img src='../img/logo.png' class='logo' />
			</a>
		</div>
		<div class="col-lg-6 col-6 text-left">
			<form action="selectall" method="get" style="margin-left:-20px; margin-right:90px;">
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
				<i class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span>
			</a>
		</div>
	</div>

	<!-- Main Layout -->
	<div class="container-fluid">
		<div class="row px-xl-5">
			<!-- LEFT SIDEBAR (PC ONLY) -->
			<div class="col-lg-2 d-none d-lg-block">
			<nav class="category-sidebar" id="mainSidebar" style="margin-left:-20px;">
				<h6>마이페이지</h6>
					<ul class="nav flex-column">
						<li class="nav-item"><a href="/mypage" class="nav-link active">모든내역</a></li>
						<li class="nav-item"><a href="/orderhistory" class="nav-link">주문내역</a></li>
						<li class="nav-item"><a href="/mydelivery" class="nav-link">배송내역</a></li>
						<li class="nav-item"><a href="/mycs" class="nav-link">취소/반품/교환내역</a></li>
						<li class="nav-item"><a href="/update" class="nav-link">내 정보수정</a></li>
						<li class="nav-item"><a href="/delete" class="nav-link">회원탈퇴</a></li>
						
					</ul>
				</nav>
			</div>
			<!-- ✅ 메인 대시보드 -->
			<div class="col-lg-10" style="margin-top: 30px; margin-bottom: 50px;">
				<div class="text-center mb-4">
					<h3>모든내역</h3>
					<p class="text-muted">주문 및 배송 현황을 한눈에 확인하세요</p>
				</div>

				<!-- 📊 통계 카드 -->
				<div class="row mb-4">
					<div class="col-md-4">
						<div class="stats-box">
							<h3>${fn:length(deliveryList)}</h3>
							<p>전체 주문</p>
						</div>
					</div>
					<div class="col-md-4">
						<div class="stats-box">
							<h3>
								<c:set var="deliveryCount" value="0"/>
								<c:forEach var="order" items="${deliveryList}">
									<c:if test="${order.order_status == '배송중' || order.order_status == '배송준비중'}">
										<c:set var="deliveryCount" value="${deliveryCount + 1}"/>
									</c:if>
								</c:forEach>
								${deliveryCount}
							</h3>
							<p>배송 진행중</p>
						</div>
					</div>
					<div class="col-md-4">
						<div class="stats-box">
							<h3>${fn:length(crList)}</h3>
							<p>CS 신청</p>
						</div>
					</div>
				</div>

				<!-- 📦 최근 주문내역 -->
				<div class="dashboard-card">
					<h5><i class="fas fa-shopping-cart mr-2"></i>최근 주문내역</h5>
					<c:choose>
						<c:when test="${empty deliveryList}">
							<p class="text-center text-muted py-4">주문 내역이 없습니다.</p>
						</c:when>
						<c:otherwise>
							<table class="table table-hover mini-table">
								<thead>
									<tr>
										<th>주문번호</th>
										<th>상품명</th>
										<th>결제금액</th>
										<th>주문상태</th>
										<th>주문일시</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="order" items="${deliveryList}">
										<c:forEach var="detail" items="${order.detailList}" begin="0"
											end="4">
											<tr>
												<td>${order.order_no}</td>
												<td>${detail.item_name}</td>
												<td><fmt:formatNumber value="${detail.item_price}"
														pattern="#,###" />원</td>
												<td><span class="badge badge-secondary">
														${order.order_status} </span></td>
												<td>${order.order_date}</td>
											</tr>
										</c:forEach>
									</c:forEach>
								</tbody>
							</table>
							<a href="/orderhistory" class="btn btn-outline-primary view-more-btn">
								전체 주문내역 보기 <i class="fas fa-arrow-right ml-1"></i>
							</a>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- 🚚 배송 현황 -->
				<div class="dashboard-card">
					<h5><i class="fas fa-truck mr-2"></i>배송 현황</h5>
					<c:choose>
						<c:when test="${empty deliveryList}">
							<p class="text-center text-muted py-4">배송 내역이 없습니다.</p>
						</c:when>
						<c:otherwise>
							<table class="table table-hover mini-table">
								<thead>
									<tr>
										<th>주문번호</th>
										<th>주문일시</th>
										<th>상품명</th>
										<th>총 금액</th>
										<th>배송상태</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="order" items="${deliveryList}" begin="0" end="4">
										<tr>
											<td>${order.order_no}</td>
											<td>${order.order_date}</td>
											<td>
												<c:if test="${not empty order.detailList}">
													${order.detailList[0].item_name}
													<c:if test="${fn:length(order.detailList) > 1}">
														<span class="text-muted"> 외 ${fn:length(order.detailList) - 1}개</span>
													</c:if>
												</c:if>
											</td>
											<td><fmt:formatNumber value="${order.total_amount}" pattern="#,###"/>원</td>
											<td>
												<c:choose>
													<c:when test="${order.order_status == '배송준비중'}">
														<span class="badge badge-warning" style="background-color:#FFF3E0; color: #E65100;">배송준비중</span>
													</c:when>
													<c:when test="${order.order_status == '배송중'}">
														<span class="badge badge-info" style="background-color:#EDF1FF; color: #1565C0;">배송중</span>
													</c:when>
													<c:when test="${order.order_status == '배송완료'}">
														<span class="badge badge-success" style="background-color:#E8F5E9; color: #2E7D32;">배송완료</span>
													</c:when>
													<c:otherwise>
														<span class="badge badge-secondary">${order.order_status}</span>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<a href="/mydelivery" class="btn btn-outline-primary view-more-btn">
								전체 배송내역 보기 <i class="fas fa-arrow-right ml-1"></i>
							</a>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- 🔄 취소/반품/교환 신청 -->
<div class="dashboard-card">
	<div class="d-flex justify-content-between align-items-center mb-3">
		<h5 class="mb-0"><i class="fas fa-exchange-alt mr-2"></i>취소·반품·교환 신청</h5>
		<button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#crApplyModal">
			신청하기
		</button>
	</div>
	<c:choose>
		<c:when test="${empty crList}">
			<p class="text-center text-muted py-4">취소·반품·교환 신청 내역이 없습니다.</p>
		</c:when>
		<c:otherwise>
			<table class="table table-hover mini-table">
				<thead>
					<tr>
						<th>주문번호</th>
						<th>상품명</th>
						<th>신청유형</th>
						<th>상태</th>
						<th>신청일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="cr" items="${crList}" begin="0" end="4">
						<tr>
							<td>${cr.order_no}</td>
							<td>${cr.item_name}</td>
							<td><span class="badge badge-info">${cr.type}</span></td>
							<td>${cr.status}</td>
							<td><fmt:formatDate value="${cr.re_date}" pattern="yyyy-MM-dd"/></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<a href="/mycs" class="btn btn-outline-primary view-more-btn">
				전체 CS내역 보기 <i class="fas fa-arrow-right ml-1"></i>
			</a>
		</c:otherwise>
	</c:choose>
</div>

			</div>
		</div>
	</div>

	<!-- 취소/반품/교환 신청 모달 -->
	<div class="modal fade" id="crApplyModal" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<form action="/mycs/apply" method="post" id="crApplyForm">
					<div class="modal-header">
						<h5 class="modal-title">취소·반품·교환 신청</h5>
						<button type="button" class="close" data-dismiss="modal">
							<span>&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<!-- 주문번호 입력 -->
						<div class="form-group">
							<label><h6>주문번호 <span class="text-danger">*</span></h6></label>
							<select name="order_no" id="order_no" class="form-control" required>
								<option value="">주문번호를 선택하세요</option>
								<c:forEach var="order" items="${orderList}">
									<option value="${order}">${order}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group">
							<label>상품번호</label>
							<select name="return_cnt" id="return_cnt" class="form-control">
								<option value="">상품을 선택하세요</option>
							</select>
						</div>
						<!-- 신청 유형 -->
						<div class="form-group">
							<label>신청 유형 <span class="text-danger">*</span></label>
							<select name="type" id="type" class="form-control" required>
								<option value="">선택하세요</option>
								<option value="취소">취소</option>
								<option value="반품">반품</option>
								<option value="교환">교환</option>
							</select>
						</div>

						<!-- 사유 -->
						<div class="form-group">
							<label>사유 <span class="text-danger">*</span></label>
							<textarea name="reason" id="reason" class="form-control" rows="4" 
									  placeholder="사유를 입력해주세요" required></textarea>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
						<button type="submit" class="btn btn-primary">신청하기</button>
					</div>
				</form>
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