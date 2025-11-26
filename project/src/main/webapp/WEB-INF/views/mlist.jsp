<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>고객관리</title>
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
                <li class="nav-item"><a href="mlist" class="nav-link active">고객관리</a></li>
            </ul>
        </nav>

        <!-- Content -->
        <div class="col-lg-10 dashboard-content">
            <h3 class="mb-4">고객관리</h3>

            <h4>우수고객 (VIP)</h4>
<div class="table-responsive mb-4">
    <table class="table table-bordered text-center">
        <thead class="thead-light">
            <tr>
                <th>고객번호</th>
                <th>고객명</th>
                <th>주소</th>
                <th>총 구매금액</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>096</td>
                <td>김철수</td>
                <td>서울 강남구</td>
                <td>2,500,000원</td>
            </tr>
            <tr>
                <td>078</td>
                <td>이영희</td>
                <td>서울 송파구</td>
                <td>1,980,000원</td>
            </tr>
            <tr>
                <td>011</td>
                <td>박민수</td>
                <td>경기 수원시</td>
                <td>1,500,000원</td>
            </tr>
        </tbody>
    </table>
</div>

<h4>휴면고객</h4>
<div class="table-responsive mb-4">
    <table class="table table-bordered text-center">
        <thead class="thead-light">
            <tr>
                <th>고객번호</th>
                <th>고객명</th>
                <th>주소</th>
                <th>총 구매금액</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>001</td>
                <td>최지훈</td>
                <td>서울 마포구</td>
                <td>120,000원</td>
            </tr>
            <tr>
                <td>002</td>
                <td>정수민</td>
                <td>인천 부평구</td>
                <td>85,000원</td>
            </tr>
            <tr>
                <td>003</td>
                <td>한예진</td>
                <td>대전 서구</td>
                <td>60,000원</td>
            </tr>
        </tbody>
    </table>
</div>

        </div>
    </div>
</div>

<!-- Footer (기존 그대로) -->
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

