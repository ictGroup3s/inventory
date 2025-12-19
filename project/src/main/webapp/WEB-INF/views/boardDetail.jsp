<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 상세보기</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="css/style.css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

</head>
<body>

<!-- Topbar -->
<div class="row align-items-center py-3 px-xl-4"style="margin-left:50px;">
    <div class="col-lg-3 d-none d-lg-block">
        <a href="/" class="text-decoration-none">
            <img src="img/logo.png" class="logo"/>
        </a>
    </div>

    <div class="col-lg-6 col-6 text-left">
      	<form action="selectall" method="get" style="margin-left:-20px; margin-right:120px;">
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

   <div class="col-lg-1 col-3 text-right " style="margin-left:80px;">
          <a href="cart" class="btn border">
            <i class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span>
        </a>
    </div> 
		<div class="col-11 d-flex justify-content-end align-items-center" >
							<!-- 로그인전 -->
							<c:if test="${empty sessionScope.loginUser}">
								<a href="login" class="nav-item nav-link " style="color:black;">로그인</a>
								<a href="register" class="nav-item nav-link"style="color:black;">회원가입</a>
								<a href="board" class="nav-item nav-link"style="color:black;">고객센터</a>
							</c:if>
							
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

 </div> <!-- topbar end -->



<!-- 메인 레이아웃 -->
<div class="container-fluid">
    <div class="row px-xl-5">

        <!-- 사이드 메뉴 동일 -->
        <nav class="category-sidebar" style="margin-left:-30px;">
            <h6 class="p-3">고객센터</h6>
            <ul class="nav flex-column">
                <li class="nav-item"><a href="/board" class="nav-link active">공지사항</a></li>
                <li class="nav-item"><a href="/board?tab=faq" class="nav-link">자주 묻는 질문</a></li>

            </ul>
        </nav>

        <!-- 상세보기 내용 -->
        <div class="col-lg-9 pt-5 dashboard-content" style="margin-left:20px;">

            <h3 class="mb-4">게시글 상세</h3>

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
