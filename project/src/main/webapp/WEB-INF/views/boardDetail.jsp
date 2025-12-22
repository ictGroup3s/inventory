<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- ※ 수정: 제목 문구 -->
<title>문의 상세보기</title>


<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="css/style.css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
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
</head>
<body>

<!-- 상단바 -->
<div class="row align-items-center py-3 px-xl-5 bg-light">
    <div class="col-lg-3 d-none d-lg-block">
        <a href="/" class="text-decoration-none">
            <img src="img/logo.png" class="logo"/>
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


<!-- 메인 레이아웃 -->
<div class="container-fluid">
    <div class="row ">

        <!-- 사이드 메뉴 동일 -->
        <nav class="category-sidebar">
            <h6 class="p-3">고객센터</h6>
            <ul class="nav flex-column">

                <!-- ※ 수정: 문의가 active -->
                <li class="nav-item">
                    <a href="/board" class="nav-link active">문의</a>
                </li>

                <li class="nav-item">
                    <a href="/board?tab=faq" class="nav-link">자주 묻는 질문</a>
                </li>

            </ul>
        </nav>

        <!-- 상세보기 내용 -->
        <div class="col-lg-10 dashboard-content" style="margin-left: 240px; margin-top:-180px; ">
        

            <!-- ※ 수정: 타이틀 문구 -->
            <h3 class="mb-4">문의 상세보기</h3>

            <table class="table table-bordered">
                <tr>
                    <th style="width:150px;">번호</th>
                    <td>${board.board_no}</td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td>${board.title}</td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td style="height:200px;">${board.b_content}</td>
                </tr>
                <tr>
                    <th>작성자</th>
                    <td>${board.customer_id}</td>
                </tr>
                <tr>
                    <th>작성일</th>
                    <td>${board.b_date}</td>
                </tr>
            </table>

            <!-- 버튼 -->
            <div class="text-right">
                <a href="/board" class="btn btn-secondary">목록으로</a>
                <a href="/boardEdit?id=${board.board_no}" class="btn btn-primary">수정</a>
                <a href="/boardDelete?id=${board.board_no}" class="btn btn-danger">삭제</a>
            </div>

        </div>
    </div>
</div>



</body>
</html>
