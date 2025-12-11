<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="user_type" value="${user_type != null ? user_type : 'member'}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>회원가입</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<!-- Font -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<!-- Bootstrap -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css">

<!-- Custom -->
<link href="css/style.css" rel="stylesheet">

</head>

<body>

<!-- Header -->
<div class="row align-items-center py-3 px-xl-5">
    <div class="col-lg-3 d-none d-lg-block">
        <a href="/" class="text-decoration-none">
            <img src="/img/logo.png" class="logo" />
        </a>
    </div>
    <div class="col-lg-6 col-6 text-left">
        <form action="">
            <div class="input-group">
                <input type="text" class="form-control" placeholder="Search for products">
                <div class="input-group-append">
                    <span class="input-group-text bg-transparent text-primary"><i class="fa fa-search"></i></span>
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

<!-- Page Title -->
<div class="container-fluid bg-secondary mb-5">
    <div class="d-flex flex-column align-items-center justify-content-center" style="min-height: 200px">
        <h1 class="font-weight-semi-bold text-uppercase mb-3">회원가입</h1>
        <div class="d-inline-flex">
            <p class="m-0"><a href="/">Home</a></p>
            <p class="m-0 px-2">-</p>
            <p class="m-0">Register</p>
        </div>
    </div>
</div>

<!-- Register Card with Tabs -->
<div class="container mb-5">
    <div class="register-card p-4">

        <h3 class="text-center font-weight-bold mb-4" >회원가입</h3>

        <!-- Nav Tabs -->
        <ul class="nav nav-tabs mb-4" id="registerTab" role="tablist">
          
            <li class="nav-item">
                <a class="nav-link ${user_type == 'member' ? 'active' : ''}" id="user-tab" data-toggle="tab" href="#userForm" role="tab">일반 회원가입</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${user_type == 'admin' ? 'active' : ''}" id="admin-tab" data-toggle="tab" href="#adminForm" role="tab">관리자 회원가입</a>
            </li>
        </ul>

        <!-- Tab Content -->
        <div class="tab-content">
      

            <!-- 2) 일반 회원가입 폼 -->
				 <div class="tab-pane fade ${user_type == 'member' ? 'show active' : ''}" id="userForm" role="tabpanel">
                <form action="registerAction" method="post">
                    <input type="hidden" name="user_type" value="member">
                    <input type="hidden" name="role" value="0">
                    <input type="hidden" name="business_no" value="0">

                    <div class="form-group">
                        <label>아이디 *</label>
                        <input type="text" name="customer_id" class="form-control" placeholder="아이디 입력"
                            value="${customerVO.customer_id != null ? customerVO.customer_id : ''}" required>
                            
                        <c:if test="${not empty idError}">
                            <span style="color:red; font-size:14px;">${idError}</span>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label>비밀번호 *</label>
                        <input type="password" name="pwd" class="form-control" placeholder="비밀번호 입력" required>
                        <c:if test="${not empty pwError}">
                            <span style="color:red; font-size:14px;">${pwError}</span>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label>비밀번호 확인 *</label>
                        <input type="password" name="pwd2" class="form-control" placeholder="비밀번호 재입력" required>
                    </div>

                    <div class="form-group">
                        <label>이름 *</label>
                        <input type="text" name="name" class="form-control" placeholder="이름 입력"
                             value="${customerVO.name != null ? customerVO.name : ''}" required>
                    </div>

                    <div class="form-group">
                        <label>전화번호 *</label>
                        <input type="text" name="phone" class="form-control" placeholder="전화번호 입력"
                           value="${customerVO.phone != null ? customerVO.phone : ''}" 
                           maxlength="11" pattern="\d{11}" required>
                   <small class="form-text text-muted">(11자리 숫자로만 입력 가능합니다.)</small>
                         
                    </div>

                    <div class="form-group">
                        <label>이메일</label>
                        <input type="email" name="email" class="form-control" placeholder="이메일 입력"
                            value="${customerVO.email != null ? customerVO.email : ''}">
                    </div>

                    <div class="form-group">
                        <label>주소</label>
                        <input type="text" name="addr" class="form-control" placeholder="주소 입력"
                            value="${customerVO.addr != null ? customerVO.addr : ''}">
                    </div>

                    <div class="form-group">
                       <label>이용약관</label>
                        <div class="border p-3 mb-2" style="height: 100px; overflow-y: auto; background:#f8f8f8;">
                            [이용약관 예시]<br>
                            회원가입 시 동의가 필요한 약관 내용이 들어갑니다.
                        </div>
                        <input type="checkbox" required> 동의합니다.
                    </div>

                    <button type="submit" class="btn btn-primary btn-block py-2 mt-3">가입하기</button>
                    <button type="button" onclick="location.href='login'" class="btn btn-outline-primary btn-block py-2 mt-2">취소 (로그인으로)</button>
                </form>
            </div>

            <!-- 관리자 회원가입 폼 -->
			<div class="tab-pane fade ${user_type == 'admin' ? 'show active' : ''}" id="adminForm" role="tabpanel">
                <form action="registerAction" method="post">
                    <input type="hidden" name="user_type" value="admin">
                    <input type="hidden" name="role" value="1">


                    <div class="form-group">
                        <label>아이디 *</label>
                        <input type="text" name="customer_id" class="form-control" placeholder="아이디 입력"
                             value="${customerVO.customer_id != null ? customerVO.customer_id : ''}" required>
                    </div>

                    <div class="form-group">
                        <label>비밀번호 *</label>
                        <input type="password" name="pwd" class="form-control" placeholder="비밀번호 입력" required>
                    </div>

                    <div class="form-group">
                        <label>비밀번호 확인 *</label>
                        <input type="password" name="pwd2" class="form-control" placeholder="비밀번호 재입력" required>
                        <c:if test="${not empty pwError}">
                            <span style="color:red; font-size:14px;">${pwError}</span>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label>이름 *</label>
                        <input type="text" name="name" class="form-control" placeholder="이름 입력"
                            value="${customerVO.name != null ? customerVO.name : ''}" required>
                    </div>

                    <div class="form-group">
                        <label>사업자번호 *</label>
                        <input type="text" name="admin_bnum" class="form-control" 
                        		placeholder="숫자10자리 입력"
                            	value="${customerVO.admin_bnum != null ? customerVO.admin_bnum : ''}"
                            	maxlength="10" pattern="\d{10}" required>
                       <small class="form-text text-muted">숫자 10자리만 입력 가능합니다.</small>
                    </div>

                    <div class="form-group">
                        <label>전화번호 *</label>
                        <input type="text" name="phone" class="form-control" placeholder="전화번호 입력"
                            value="${customerVO.phone != null ? customerVO.phone : ''}" 
                             maxlength="11" pattern="\d{11}" required>
                        <small class="form-text text-muted">(11자리 숫자로만 입력 가능합니다.)</small>
                    </div>
                    
                    <div class="form-group">
                        <label>이용약관</label>
                        <div class="border p-3 mb-2" style="height: 100px; overflow-y: auto; background:#f8f8f8;">
                            [이용약관 예시]<br>
                            회원가입 시 동의가 필요한 약관 내용이 들어갑니다.
                        </div>
                        <input type="checkbox" required> 동의합니다.
                    </div>
                   <button type="submit" class="btn btn-primary btn-block py-2 mt-3">가입하기</button>
                    <button type="button" onclick="location.href='login'" class="btn btn-outline-primary btn-block py-2 mt-2">취소 (로그인으로)</button>
                </form>
            </div>
        </div>

    </div>
</div>


<!-- Footer 동일하게 유지 -->

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>

</body>
</html>