<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>공지사항 게시판</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<!-- Favicon -->
<link href="img/favicon.ico" rel="icon">

<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

<!-- Bootstrap CSS -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom Styles -->
<link rel="stylesheet" href="css/style.css">

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

</head>
<body>

	<!-- Topbar -->
	<div class="row align-items-center py-3 px-xl-5 bg-light">
		<div class="col-lg-3 d-none d-lg-block">
			<a href="/" class="text-decoration-none">
				<img src="img/logo.png" class="logo"/>
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
			<a href="#" class="btn border">
				<i class="fas fa-heart text-primary"></i> <span class="badge">0</span>
			</a>
			<a href="cart" class="btn border">
				<i class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span>
			</a>
		</div>
	</div>

	<!-- Main Layout -->
	<div class="container-fluid">
		<div class="row px-xl-2">

			<!-- Sidebar -->
			<nav class="category-sidebar">
				<h6 class="p-3">고객센터</h6>
				<ul class="nav flex-column">
					<li class="nav-item"><a href="board" class="nav-link active">공지사항</a></li>
					<li class="nav-item"><a href="#" class="nav-link">자주 묻는 질문</a></li>
				</ul>
			</nav>

			<!-- Content -->
			<div class="col-lg-10 dashboard-content">

				<h3 class="mb-4">공지사항 게시판</h3>

				<!-- 🔥 AJAX로 내부만 교체되는 영역 -->
				<div id="contentArea">

					<!-- 게시글 리스트 -->
					<div class="table-responsive mb-4">
						<table class="table table-bordered text-center">
							<thead class="thead-light">
								<tr>
									<th style="width: 80px;">번호</th>
									<th>제목</th>
									<th style="width: 150px;">작성자</th>
									<th style="width: 150px;">작성일</th>
								</tr>
							</thead>
							<tbody>

								<c:forEach var="b" items="${list}">
									<tr>
										<td>${b.board_no}</td>
										<td>
											<!-- 🔥 제목 클릭 시 상세보기로 이동 -->
											<a href="boardDetail?id=${b.board_no}">
												${b.title}
											</a>
										</td>
										<td>${b.customer_id}</td>
										<td>${b.b_date}</td>
									</tr>
								</c:forEach>

								<c:if test="${empty list}">
									<tr>
										<td colspan="4">등록된 공지사항이 없습니다.</td>
									</tr>
								</c:if>

							</tbody>
						</table>
					</div>

					<div class="text-right mb-3">
						<button class="btn btn-primary" onclick="showWriteForm()">글쓰기</button>
					</div>

				</div>
				<!-- AJAX contentArea 끝 -->

			</div>
		</div>
	</div>

	<!-- Footer -->
	<div class="container-fluid bg-secondary text-dark mt-5 pt-5">
		<div class="row px-xl-5 pt-5">
			<div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
				<a href="#" class="text-decoration-none">
					<h1 class="mb-4 display-5 font-weight-semi-bold">
						<span class="text-primary font-weight-bold border border-white px-3 mr-1">E</span>Shopper
					</h1>
				</a>
				<p>Dolore erat dolor sit lorem vero amet...</p>
			</div>
		</div>
	</div>

	<!-- JS -->
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
	<script src="lib/owlcarousel/owl.carousel.min.js"></script>
	<script src="js/main.js"></script>

	<!-- 🔥 글쓰기 AJAX 로드 -->
	<script>
	    function showWriteForm(){
	        $("#contentArea").load("<%=request.getContextPath()%>/boardWrite");
	    }
	</script>

</body>
</html>