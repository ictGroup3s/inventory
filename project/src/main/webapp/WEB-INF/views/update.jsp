<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5" style="max-width:600px;">
    <h3>회원정보 수정</h3>
    <form action="/updateUser" method="post">
        <!-- 아이디 (수정 불가) -->
        <div class="mb-3">
            <label>아이디</label>
            <input type="text" class="form-control" value="${customer.customer_id}" disabled>
        </div>

        <!-- 이름 -->
        <div class="mb-3">
            <label>이름</label>
            <input type="text" name="name" class="form-control" value="${customer.name}" required>
        </div>

        <!-- 비밀번호 -->
        <div class="mb-3">
            <label>비밀번호</label>
            <input type="password" name="pwd" class="form-control" placeholder="변경 시 입력">
        </div>

        <!-- 전화번호 -->
        <div class="mb-3">
            <label>전화번호</label>
            <input type="text" name="phone" class="form-control" value="${customer.phone}">
        </div>

        <!-- 이메일 -->
        <div class="mb-3">
            <label>이메일</label>
            <input type="email" name="email" class="form-control" value="${customer.email}">
        </div>

        <!-- 주소 -->
        <div class="mb-3">
            <label>주소</label>
            <input type="text" name="addr" class="form-control" value="${customer.addr}">
        </div>

        <button type="submit" class="btn btn-primary w-100">수정하기</button>
    </form>
    <a href="/mypage" class="btn btn-secondary w-100 mt-2">뒤로가기</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>