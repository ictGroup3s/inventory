<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 상세보기</title>

<!-- CSS & JS 동일 적용 -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="css/style.css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

</head>
<body>

<!-- 🔥 board.jsp와 동일한 상단바 -->
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


<!-- 🔥 메인 레이아웃 -->
<div class="container-fluid">
    <div class="row px-xl-2">

        <!-- 사이드 메뉴 동일 -->
        <nav class="category-sidebar">
            <h6 class="p-3">고객센터</h6>
            <ul class="nav flex-column">
                <li class="nav-item"><a href="/board" class="nav-link active">공지사항</a></li>
                <li class="nav-item"><a href="#" class="nav-link">자주 묻는 질문</a></li>
            </ul>
        </nav>

        <!-- 🔥 상세보기 내용 -->
        <div class="col-lg-10 dashboard-content">

            <h3 class="mb-4">공지사항 상세보기</h3>

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


<!-- Footer 동일 -->
<div class="container-fluid bg-secondary text-dark mt-5 pt-5">
    <div class="row px-xl-5 pt-5">
        <div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
            <h1 class="mb-4 display-5 font-weight-semi-bold">
                <span class="text-primary font-weight-bold px-3 mr-1">S</span>StockBob
            </h1>
        </div>
    </div>
</div>

</body>
</html>