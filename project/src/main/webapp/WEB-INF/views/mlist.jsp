<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>채팅</title>
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
<link rel="stylesheet" href="css/adminChat.css">
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
			<a href="login?redirectURL=mlist" class="btn-login"
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
			<div class="col-lg-3 offset-lg-1 d-none d-lg-block">
				<a href="/" class="text-decoration-none"> 
				<img src="img/logo.png" class="logo" />
				</a>
			</div>
		 <div class="ml-auto d-flex align-items-center gap-2">
							<!-- 회원 로그인 후   -->
							<c:if test="${not empty sessionScope.loginUser}">
								<span class="nav-item nav-link">안녕하세요,
									${sessionScope.loginUser.name}님!</span>


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
		<!-- Main Layout -->
		<div class="container-fluid">
			<div class="row px-xl-5">
				<!-- LEFT SIDEBAR (PC ONLY) -->
				<div class="col-lg-2 d-none d-lg-block">
					<nav class="category-sidebar" id="mainSidebar">
						<h6>관리자 페이지</h6>
						<ul class="nav flex-column">
							<li class="nav-item"><a href="dashboard" class="nav-link">대쉬보드</a></li>
							<li class="nav-item"><a href="item" class="nav-link">상품관리</a></li>
							<li class="nav-item"><a href="stock" class="nav-link">입고/재고관리</a></li>
							<li class="nav-item"><a href="order" class="nav-link">주문관리</a></li>
							<li class="nav-item"><a href="stats" class="nav-link">통계</a></li>
							<li class="nav-item"><a href="mlist" class="nav-link active">채팅관리</a></li>
							<li class="nav-item"><a href="board" class="nav-link">고객센터</a></li>
						</ul>
					</nav>
				</div>
				<!-- END col-lg-2 -->

				<!-- Content -->
				<!-- Admin Chat 영역 -->
				<div class="col-lg-10">

					<div class="admin-chat-wrapper">

						<h3>고객 채팅 관리</h3>

						<div id="admin-chat-container">

							<!-- 좌측 고객 목록 -->
							<div id="admin-chat-list-wrapper">
								<div class="chat-list-header">
									<span>채팅 목록</span>
									<button id="refresh-chat-list" title="새로고침">🔄</button>
								</div>
								<div id="admin-chat-list">
									<!-- JavaScript로 동적 생성 -->
								</div>
							</div>

							<!-- 우측 채팅 -->
							<div class="admin-chat-panel">
								<div class="chat-panel-header">
									<span id="current-chat-user">채팅방을 선택해주세요</span>
								</div>
								<div id="admin-chat-messages"></div>
								<div id="admin-chat-input">
									<input type="text" id="admin-chat-text" placeholder="메시지 입력...">
									<button id="admin-chat-send">Send</button>
									<button id="close-chat">종료</button>
								</div>
							</div>

						</div>
						<!-- END #admin-chat-container -->

					</div>
					<!-- END .admin-chat-wrapper -->

				</div>
				<!-- END col-lg-10 -->

			</div>
			<!-- END row -->
		</div>
		<!-- END container-fluid -->
	</div>

	<!-- Footer -->


	<!-- JS -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="lib/owlcarousel/owl.carousel.min.js"></script>
	<script src="js/main.js"></script>

	<!-- 관리자 ID 주입 (admin-chat.js보다 먼저 실행) -->
	<script>
		const adminId = "${sessionScope.loginUser.customer_id}";
		const adminRole = "${sessionScope.loginUser.role}";

		console.log("✅ 관리자 ID:", adminId);
		console.log("✅ Role:", adminRole);
	</script>

	<script src="js/AdminChat.js?v=999"></script>

</body>
</html>