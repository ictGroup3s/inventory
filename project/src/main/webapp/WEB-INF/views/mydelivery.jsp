<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>배송내역</title>
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
<link href="css/chat.css" rel="stylesheet">
</head>

<body>
	<div class="row align-items-center py-3 px-xl-5">
		<div class="col-lg-3 d-none d-lg-block">
			<a href="/" class="text-decoration-none">
				<img src="\img\logo.png" class='logo' />
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
		<div class="col-lg-3 col-6 text-right" style="margin-left:-80px;">
			<a href="cart" class="btn border">
				<i class="fas fa-shopping-cart text-primary"></i>
				<span class="badge">0</span>
			</a>
		</div>
	</div>
	<!-- Main Layout -->
	<div class="container-fluid"  style="margin-left:-100px;">
		<div class="row px-xl-5">
			<div class="col-lg-2">
				<!-- Sidebar -->
				<nav class="category-sidebar">
					<h6>마이페이지</h6>
					<ul class="nav flex-column">
						<li class="nav-item"><a href="/mypage" class="nav-link">모든내역</a></li>
						<li class="nav-item"><a href="/orderhistory" class="nav-link">주문내역</a></li>
						<li class="nav-item"><a href="/mydelivery" class="nav-link active">배송내역</a></li>
						<li class="nav-item"><a href="/mycs" class="nav-link">취소·반품·교환내역</a></li>
						<li class="nav-item"><a href="/update" class="nav-link">내정보수정</a></li>
						<li class="nav-item"><a href="/delete" class="nav-link">회원탈퇴</a></li>
						<li class="nav-item"><a href="/board" class="nav-link">고객센터</a></li>
					</ul>
				</nav>
			</div>

			<!-- Main Content -->
			<div class="col-lg-10 pl-4" style="margin-top: -20px; margin-bottom: 40px;">
				<div class="text-center mb-4">
					<h4 style="margin-top:50px;">배송내역</h4>
				</div>
				<!-- 검색 결과 카운트 -->
				<span class="ml-2 text-muted"> 
				총 <strong id="totalCount">${fn:length(deliveryList)}</strong>건
				</span>

				<!-- 검색 섹션 -->
				<div class="search-box mb-3" style="margin-top: 20px;">
					<div class="row">
						<div class="col-md-6">
							<div class="input-group">
								<select id="searchType" class="form-control"
									style="max-width: 140px;">
									<option value="all">전체</option>
									<option value="order_no">주문번호</option>
									<option value="item_name">상품명</option>
								</select> <input type="text" id="searchInput" class="form-control"
									placeholder="검색어 입력">
								<div class="input-group-append">
									<button class="btn btn-primary" type="button"
										onclick="searchCR()">
										<i class="fa fa-search"></i> 검색
									</button>
								</div>
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
					<c:choose>
						<c:when test="${empty deliveryList}">
							<p class="text-center">배송 내역이 없습니다.</p>
						</c:when>
						<c:otherwise>
						
							<table class="table table-striped" style="margin-top:40px;">
								<thead>
									<tr>
										<th>주문번호</th>
										<th>주문일시</th>
										<th>상품명</th>
										<th>총 금액</th>
										<th>배송상태</th>
										<th></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="order" items="${deliveryList}">
											<tr data-order-no="${order.order_no}"
												data-item-name="${not empty order.detailList ? order.detailList[0].item_name : ''}">
												
												<td>${order.order_no}</td>
												<td>${order.order_date}</td>
												<td>
													<!-- ⭐⭐⭐ 첫 번째 상품만 표시 --> <c:if
														test="${not empty order.detailList}">
													${order.detailList[0].item_name}
													<!-- 2개 이상이면 "외 N개" 표시 -->
														<c:if test="${fn:length(order.detailList) > 1}">
															<span class="text-muted"> 외
																${fn:length(order.detailList) - 1}개</span>
														</c:if>
													</c:if>
												</td>
												<td><fmt:formatNumber value="${order.total_amount}"
														pattern="#,###" />원</td>
												<td><c:choose>
														<c:when test="${order.order_status == '배송준비중'}">
															<span class="badge badge-warning"
																style="background-color: #FFF3E0; color: #E65100;">배송준비중</span>
														</c:when>
														<c:when test="${order.order_status == '배송중'}">
															<span class="badge badge-info"
																style="background-color: #EDF1FF; color: #1565C0;">배송중</span>
														</c:when>
														<c:when test="${order.order_status == '배송완료'}">
															<span class="badge badge-success"
																style="background-color: #E8F5E9; color: #2E7D32;">배송완료</span>
														</c:when>
														<c:otherwise>
															<span class="badge badge-secondary">${order.order_status}</span>
														</c:otherwise>
													</c:choose></td>
												<td>
													<button class="btn btn-sm btn-secondary"
														data-toggle="modal"
														data-target="#detailModal_${order.order_no}">
														상세보기</button>
												</td>
											</tr>
										</c:forEach>
								</tbody>
							</table>
						<!-- 검색 결과 없음 메시지 (JavaScript로 동적 생성됨) -->
				<div id="noResultMessage" class="text-center py-4" style="display: none;">
					<i class="fas fa-search fa-3x text-muted mb-3"></i>
					<p class="text-muted">검색 결과가 없습니다.</p>
				</div>
			</c:otherwise>
		</c:choose>
	</div>
</div>
	<!-- ⭐⭐⭐ 배송 상세 모달 - 주문관리 포함 ⭐⭐⭐ -->
<c:forEach var="order" items="${deliveryList}">
	<div class="modal fade" id="detailModal_${order.order_no}" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">배송 상세내역</h5>
					<button type="button" class="close" data-dismiss="modal">
						<span>&times;</span>
					</button>
				</div>
				<div class="modal-body">
					
					<!-- 기본 정보 -->
					<div class="row mb-3">
						<div class="col-md-6">
							<strong>주문번호:</strong> ${order.order_no}
						</div>
						<div class="col-md-6">
							<strong>주문일:</strong> ${order.order_date}
						</div>
					</div>
					
					<div class="row mb-3">
						<div class="col-md-6">
							<strong>운송장번호:</strong> 
							<c:choose>
								<c:when test="${not empty order.tracking}">
									${order.tracking}
								</c:when>
								<c:otherwise>
									<span class="text-muted">배송 준비중</span>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="col-md-6">
							<strong>배송상태:</strong>
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
						</div>
					</div>

					<hr>
					
					<!-- 주문 상품 -->
					<h6><strong>주문 상품</strong></h6>
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>상품명</th>
								<th>수량</th>
								<th>금액</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="detail" items="${order.detailList}">
								<tr>
									<td>${detail.item_name}</td>
									<td>${detail.item_cnt}개</td>
									<td><fmt:formatNumber value="${detail.amount}" pattern="#,###"/>원</td>
								</tr>
							</c:forEach>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="2" class="text-right"><strong>총 결제금액:</strong></td>
								<td><strong><fmt:formatNumber value="${order.total_amount}" pattern="#,###"/>원</strong></td>
							</tr>
						</tfoot>
					</table>
					
					<hr>
					
					<!-- 배송 추적 -->
					<h6><strong>배송 추적</strong></h6>
					<ul class="mt-2">
						<li>${order.order_date}: 주문 접수</li>
						<c:choose>
							<c:when test="${order.order_status == '배송준비중'}">
								<li>현재: 상품 준비중</li>
							</c:when>
							<c:when test="${order.order_status == '배송중'}">
								<li>배송 시작됨</li>
								<li>배송 예정일: 1-2일 이내</li>
							</c:when>
							<c:when test="${order.order_status == '배송완료'}">
								<li>배송 완료</li>
							</c:when>
						</c:choose>
					</ul>
					
					<hr>
					
					<!-- ⭐⭐⭐ 주문 관리 섹션 추가 ⭐⭐⭐ -->
					<h6>
					<strong>주문 관리</strong>
					</h6>
					
					<!-- 상품 선택 -->
					<div class="mb-3">
						<h6>취소 / 반품 / 교환할 상품 선택</h6>

						<c:forEach var="detail" items="${order.detailList}">
							<div class="custom-control custom-checkbox">
								<input type="checkbox"
									class="custom-control-input product-checkbox"
									id="product_${order.order_no}_${detail.item_no}"
									value="${detail.item_no}" 
									data-order-no="${order.order_no}">
								<label class="custom-control-label"
									for="product_${order.order_no}_${detail.item_no}">
									${detail.item_name} (수량: ${detail.item_cnt}개, 금액: 
									<fmt:formatNumber value="${detail.amount}" pattern="#,###" />원)
								</label>
							</div>
						</c:forEach>

						<!-- 전체 선택 -->
						<div class="custom-control custom-checkbox mt-2">
							<input type="checkbox" class="custom-control-input"
								id="selectAll_${order.order_no}"
								onclick="toggleAllProducts(${order.order_no})">
							<label class="custom-control-label" for="selectAll_${order.order_no}">
								<strong>전체 선택</strong>
							</label>
						</div>
					</div>

					<!-- 버튼 -->
					<div class="row mb-3">
						<div class="col-md-4">
							<button type="button" class="btn btn-warning btn-block"
								onclick="handleCRRequest(${order.order_no}, '취소')">취소</button>
						</div>
						<div class="col-md-4">
							<button type="button" class="btn btn-info btn-block"
								onclick="handleCRRequest(${order.order_no}, '반품')">반품</button>
						</div>
						<div class="col-md-4">
							<button type="button" class="btn btn-success btn-block"
								onclick="handleCRRequest(${order.order_no}, '교환')">교환</button>
						</div>
					</div>

							<!-- 신청 폼 -->
							<div id="crFormContainer_${order.order_no}"
								style="display: none; margin-top: 20px;">
								<hr>
								<h6 id="crFormTitle_${order.order_no}">
									<strong>취소 · 반품 · 교환 신청</strong>
								</h6>

								<!-- ⭐ form에 id 추가 ⭐ -->
								<form id="crForm_${order.order_no}" action="/mycs/apply"
									method="post">
									<input type="hidden" name="orderNo" value="${order.order_no}">
									<input type="hidden" name="type" id="crType_${order.order_no}">
									<input type="hidden" name="selectedItems"
										id="selectedItems_${order.order_no}"> <input
										type="hidden" name="isFullOrder"
										id="isFullOrder_${order.order_no}" value="false">

									<div class="form-group">
										<label>사유 <span class="text-danger">*</span></label>
										<textarea name="reason" class="form-control" rows="4" required></textarea>
									</div>

									<div class="row">
										<div class="col-md-6">
											<button type="button" class="btn btn-secondary btn-block"
												onclick="hideCRForm(${order.order_no})">취소</button>
										</div>
										<div class="col-md-6">
											<button type="submit" class="btn btn-primary btn-block">신청하기</button>
										</div>
									</div>
								</form>
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
	<!-- ------------------채팅 관련 추가---------------- -->
	<c:if test="${sessionScope.loginRole == 0}">
		<!-- ▣ 채팅 목록 박스 -->
		<div id="chat-list-box" class="chat-list-box" style="display: none;">
			<div class="chat-list-header">나의 채팅 목록</div>
			<div id="chat-list" class="chat-list"></div>
		</div>
c 
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
	</c:if>
	<div class="toast-container" id="toast-container"></div>

		<!-- ⭐⭐⭐ JavaScript Libraries ⭐⭐⭐ -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	
	<script src="js/checkout.js"></script>
	<script src="js/order.js"></script>
	
	<!-- Bootstrap JS -->
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="lib/easing/easing.min.js"></script>
	<script src="lib/owlcarousel/owl.carousel.min.js"></script>

	<!-- Contact JS -->
	<script src="mail/jqBootstrapValidation.min.js"></script>
	<script src="mail/contact.js"></script>


	<!-- 1. 로그인 ID 주입 (가장 먼저) -->
	<script>
		const myId = "${sessionScope.loginUser.customer_id}";
		console.log("✅ myId 확인:", myId);
	</script>

	<!-- 2. Chat JS (SockJS/Stomp 준비된 이후 로드) -->
	<script src="/js/CustomerChat.js?v=999"></script>

	<!-- 3. Main JS (기타 UI 스크립트 – defer 가능) -->
	<script src="/js/main.js" defer></script>

</body>
</html>