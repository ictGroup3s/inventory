<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

</head>
<body>

<!-- Topbar -->
<div class="row align-items-center py-3 px-xl-5 bg-light">
    <div class="col-lg-3 d-none d-lg-block">
        <a href="/" class="text-decoration-none">
            <img src="img/logo.png" class="logo" />
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
        <a href="#" class="btn border"><i class="fas fa-heart text-primary"></i> <span class="badge">0</span></a>
        <a href="cart" class="btn border"><i class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span></a>
    </div>
</div>

<!-- Main Layout -->
<div class="container-fluid">
    <div class="row">

        <!-- Sidebar -->
        <nav class="col-lg-2 d-lg-block bg-light sidebar admin-sidebar">
            <h6 class="p-3">관리자 페이지</h6>
            <ul class="nav flex-column">
                <li class="nav-item"><a href="dashboard" class="nav-link">대쉬보드</a></li>
                <li class="nav-item"><a href="item" class="nav-link">상품관리</a></li>
                <li class="nav-item"><a href="stock" class="nav-link">입고/재고관리</a></li>
                <li class="nav-item"><a href="order" class="nav-link">주문관리</a></li>
                <li class="nav-item"><a href="stats" class="nav-link">통계</a></li>
                <li class="nav-item"><a href="board" class="nav-link active">공지사항</a></li>
                <li class="nav-item"><a href="mlist" class="nav-link">고객관리</a></li>
            </ul>
        </nav>

        <!-- Content -->
        <div class="col-lg-10 dashboard-content">

            <h3 class="mb-4">공지사항 게시판</h3>

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

                        <!-- 예시 데이터 (DB 연결 시 반복문으로 변경 가능) -->
                        <tr>
                            <td>3</td>
                            <td><a href="boardDetail?id=3">설 연휴 배송 안내</a></td>
                            <td>관리자</td>
                            <td>2025-01-15</td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td><a href="boardDetail?id=2">사이트 점검 예정 공지</a></td>
                            <td>관리자</td>
                            <td>2025-01-10</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td><a href="boardDetail?id=1">신년 이벤트 안내</a></td>
                            <td>관리자</td>
                            <td>2025-01-01</td>
                        </tr>

                    </tbody>
                </table>
            </div>

            <div class="text-right mb-3">
                <a href="boardWrite" class="btn btn-primary">글쓰기</a>
            </div>

        </div>
    </div>
</div>

<!-- Footer (고객관리.jsp와 동일) -->
<div class="container-fluid bg-secondary text-dark mt-5 pt-5">
    <div class="row px-xl-5 pt-5">
        <div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
            <a href="#" class="text-decoration-none">
                <h1 class="mb-4 display-5 font-weight-semi-bold">
                    <span class="text-primary font-weight-bold border border-white px-3 mr-1">E</span>Shopper
                </h1>
            </a>
            <p>Dolore erat dolor sit lorem vero amet. Sed sit lorem magna, ipsum no sit erat lorem et magna ipsum dolore amet erat.</p>
            <p class="mb-2"><i class="fa fa-map-marker-alt text-primary mr-3"></i>123 Street, New York, USA</p>
            <p class="mb-2"><i class="fa fa-envelope text-primary mr-3"></i>info@example.com</p>
            <p class="mb-0"><i class="fa fa-phone-alt text-primary mr-3"></i>+012 345 67890</p>
        </div>
        <div class="col-lg-8 col-md-12">
            <div class="row">
                <div class="col-md-4 mb-5">
                    <h5 class="font-weight-bold text-dark mb-4">Quick Links</h5>
                    <div class="d-flex flex-column justify-content-start">
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Home</a>
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Our Shop</a>
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shop Detail</a>
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shopping Cart</a>
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Checkout</a>
                        <a class="text-dark" href="#"><i class="fa fa-angle-right mr-2"></i>Contact Us</a>
                    </div>
                </div>
                <div class="col-md-4 mb-5">
                    <h5 class="font-weight-bold text-dark mb-4">Quick Links</h5>
                    <div class="d-flex flex-column justify-content-start">
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Home</a>
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Our Shop</a>
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shop Detail</a>
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shopping Cart</a>
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Checkout</a>
                        <a class="text-dark" href="#"><i class="fa fa-angle-right mr-2"></i>Contact Us</a>
                    </div>
                </div>
                <div class="col-md-4 mb-5">
                    <h5 class="font-weight-bold text-dark mb-4">Newsletter</h5>
                    <form action="">
                        <input type="text" class="form-control mb-2" placeholder="Your Name" required>
                        <input type="email" class="form-control mb-2" placeholder="Your Email" required>
                        <button class="btn btn-primary btn-block" type="submit">Subscribe</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
<script src="lib/owlcarousel/owl.carousel.min.js"></script>
<script src="js/main.js"></script>

</body>
</html>
