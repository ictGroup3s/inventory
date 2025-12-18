<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 수정</title>


<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="css/style.css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
</head>

<body>

<!-- ================= 상단바  ================= -->
<div class="row align-items-center py-3 px-xl-5 bg-light">
    <div class="col-lg-3 d-none d-lg-block">
        <a href="/" class="text-decoration-none">
            <img src="img/logo.png" class="logo"/>
        </a>
    </div>

    <div class="col-lg-6 col-6 text-left">
        <form>
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
            <i class="fas fa-heart text-primary"></i>
        </a>
        <a href="cart" class="btn border">
            <i class="fas fa-shopping-cart text-primary"></i>
        </a>
    </div>
</div>

<!-- ================= 메인 ================= -->
<div class="container-fluid">
<div class="row px-xl-2">

<!-- 사이드바  -->
<nav class="category-sidebar">
    <h6 class="p-3">고객센터</h6>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a href="/board" class="nav-link active">공지사항</a>
        </li>
        <li class="nav-item"><a href="/board?tab=faq" class="nav-link">자주 묻는 질문</a></li>

    </ul>
</nav>

<!-- ================= 수정 콘텐츠 ================= -->
<div class="col-lg-10 dashboard-content">

<h3 class="mb-4">공지사항 수정</h3>

<form action="/boardUpdate" method="post">

    <!-- PK 전달 -->
    <input type="hidden" name="board_no" value="${board.board_no}">
    <input type="hidden" name="customer_id" value="${board.customer_id}">

    <table class="table table-bordered">
        <tr>
            <th style="width:150px;">번호</th>
            <td>${board.board_no}</td>
        </tr>

        <tr>
            <th>제목</th>
            <td>
                <input type="text"
                       name="title"
                       class="form-control"
                       value="${board.title}"
                       required>
            </td>
        </tr>

        <tr>
            <th>내용</th>
            <td>
                <textarea name="b_content"
                          class="form-control"
                          rows="8"
                          required>${board.b_content}</textarea>
            </td>
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
        <a href="/boardDetail?id=${board.board_no}" class="btn btn-secondary">취소</a>
        <button type="submit" class="btn btn-primary">수정 완료</button>
    </div>

</form>

</div>
</div>
</div>

<!-- ================= Footer ================= -->
<div class="container-fluid bg-secondary text-dark mt-5 pt-5">
<div class="row px-xl-5 pt-5">
<div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
    <h1 class="mb-4 display-5 font-weight-semi-bold">
        <span class="text-primary font-weight-bold px-3 mr-1">E</span>Shopper
    </h1>
</div>
</div>
</div>

</body>
</html>
