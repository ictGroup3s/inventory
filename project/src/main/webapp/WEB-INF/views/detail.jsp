<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>상세정보</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="Free HTML Templates" name="keywords">
<meta content="Free HTML Templates" name="description">

<!-- Favicon -->
<link href="img/favicon.ico" rel="icon">

<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

<!-- Bootstrap -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">

<!-- Owl Carousel -->
<link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
<link href="lib/owlcarousel/assets/owl.theme.default.min.css" rel="stylesheet">

<!-- Custom CSS -->
<link href="css/style.css" rel="stylesheet">

<style>
/* 상품 카드 */
.product-item {
  max-width: 260px;
  margin: 0 auto;
}
.product-item img {
  width: 100%;
  display: block;
}
.owl-carousel .owl-nav button.owl-prev,
.owl-carousel .owl-nav button.owl-next {
  position: absolute;
  top: 35%;
  background: #fff;
  border-radius: 50%;
  padding: 5px 10px;
}
.owl-carousel .owl-nav button.owl-prev {
  left: -25px;
}
.owl-carousel .owl-nav button.owl-next {
  right: -25px;
}

/* Footer 고정 */
html, body {
    height: 100%;
}
body {
    display: flex;
    flex-direction: column;
}
.content {
    flex: 1 0 auto;
}
.footer {
    flex-shrink: 0;
}
</style>

</head>
<body>

<div class="content">
  <!-- ================= 로고 + 검색 + 장바구니 ================= -->
  <div class="row align-items-center py-3 px-xl-5">
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
            <span class="input-group-text bg-transparent text-primary"><i class="fa fa-search"></i></span>
          </div>
        </div>
      </form>
    </div>
    <div class="col-lg-3 col-6 text-right">
      <a href="#" class="btn border"><i class="fas fa-heart text-primary"></i> <span class="badge">0</span></a>
      <a href="cart" class="btn border"><i class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span></a>
    </div>
  </div>

  <!-- ================= Sidebar + Navbar + Shop Detail ================= -->
  <div class="container-fluid px-xl-5">
    <div class="row">
      <!-- Sidebar -->
      <div class="col-lg-2 col-md-12 d-none d-lg-block">
        <nav class="category-sidebar">
          <h6 class="p-3">상품 카테고리</h6>
          <ul class="nav flex-column">
            <li class="nav-item"><a href="selectall" class="nav-link">전체상품</a></li>
            <li class="nav-item"><a href="selectGui" class="nav-link">구이 ．찜 ．볶음</a></li>
            <li class="nav-item"><a href="selectSoup" class="nav-link">국 ．밥 ．면</a></li>
            <li class="nav-item"><a href="selectDiet" class="nav-link">식단관리</a></li>
            <li class="nav-item"><a href="selectBunsik" class="nav-link">분식．간식</a></li>
            <li class="nav-item"><a href="selectBanchan" class="nav-link">반찬 ．소스</a></li>
            <li class="nav-item"><a href="selectRecipe" class="nav-link">레시피</a></li>
          </ul>
        </nav>
      </div>

      <!-- Main Content -->
      <div class="col-lg-10 col-md-12">
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg bg-light navbar-light py-3 py-lg-0 px-0">
          <a href="/" class="text-decoration-none d-block d-lg-none">
            <img src="img/logo.png" class="logo" />
          </a>
          <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse justify-content-between" id="navbarCollapse">
            <div class="navbar-nav ml-auto py-0">
              <a href="login" class="nav-item nav-link">로그인</a>
              <a href="register" class="nav-item nav-link">회원가입</a>
              <a href="board" class="nav-item nav-link">고객센터</a>
            </div>
          </div>
        </nav>

        <!-- Shop Detail -->
        <div class="container py-5">
          <div class="d-flex flex-wrap align-items-center">
            <div class="p-2 flex-shrink-0">
              <img src="img/fish.png" alt="고등어구이" class="img-fluid" style="max-width: 300px;">
            </div>
            <div class="p-2 flex-grow-1">
              <h3 class="font-weight-semi-bold">고등어구이</h3>
              <div class="d-flex mb-2 align-items-center">
                <div class="text-primary mr-2">
                  <small class="fas fa-star"></small> <small class="fas fa-star"></small>
                  <small class="fas fa-star"></small> <small class="fas fa-star-half-alt"></small>
                  <small class="far fa-star"></small>
                </div>
                <small class="pt-1">(50 Reviews)</small>
              </div>
              <h4 class="font-weight-semi-bold mb-2">8,000원</h4>
              <p class="mb-4">전자레인지 또는 후라이팬 조리.<br>전자레인지 30초, 후라이팬 조리 10~15분.</p>
              <div class="d-flex align-items-center mb-4 pt-2">
                <div class="input-group quantity mr-3" style="width: 130px;">
                  <div class="input-group-btn">
                    <button class="btn btn-primary btn-minus"><i class="fa fa-minus"></i></button>
                  </div>
                  <input type="text" class="form-control bg-secondary text-center" value="1">
                  <div class="input-group-btn">
                    <button class="btn btn-primary btn-plus"><i class="fa fa-plus"></i></button>
                  </div>
                </div>
                <button class="btn btn-primary px-3"><i class="fa fa-shopping-cart mr-1"></i> 장바구니 담기</button>
              </div>
            </div>
          </div>

          <!-- Tab Section -->
          <div class="row px-xl-5 mt-5">
            <div class="col">
              <div class="nav nav-tabs justify-content-center border-secondary mb-4">
                <a class="nav-item nav-link active" data-toggle="tab" href="#tab-pane-1">Description</a>
                <a class="nav-item nav-link" data-toggle="tab" href="#tab-pane-2">Information</a>
                <a class="nav-item nav-link" data-toggle="tab" href="#tab-pane-3">Reviews (0)</a>
              </div>
              <div class="tab-content">
                <div class="tab-pane fade show active" id="tab-pane-1">
                  <h4 class="mb-3">Product Description</h4>
                  <p>Eos no lorem eirmod diam diam, eos elitr et gubergren diam sea...</p>
                </div>
                <div class="tab-pane fade" id="tab-pane-2">
                  <h4 class="mb-3">Additional Information</h4>
                  <p>Eos no lorem eirmod diam diam, eos elitr et gubergren diam sea...</p>
                </div>
                <div class="tab-pane fade" id="tab-pane-3">
                  <h4 class="mb-4">1 review for "Colorful Stylish Shirt"</h4>
                  <p>Diam amet duo labore stet elitr ea clita ipsum...</p>
                </div>
              </div>
            </div>
          </div>
        </div> <!-- Shop Detail End -->

        <!-- ================= Products 추천 섹션 ================= -->
        <div class="container-fluid py-5">
          <div class="text-center mb-4">
            <h2 class="section-title px-5"><span class="px-2">You May Also Like</span></h2>
          </div>
          <div class="row px-xl-5">
            <div class="col">
              <div class="owl-carousel related-carousel owl-theme">
                <!-- 반복 카드 -->
                <div class="card product-item border-0">
                  <div class="card-header product-img position-relative overflow-hidden bg-transparent border p-0">
                    <img class="img-fluid w-100" src="img/product-1.jpg" alt="">
                  </div>
                  <div class="card-body border-left border-right text-center p-0 pt-4 pb-3">
                    <h6 class="text-truncate mb-3">Colorful Stylish Shirt</h6>
                    <div class="d-flex justify-content-center">
                      <h6>$123.00</h6>
                      <h6 class="text-muted ml-2"><del>$123.00</del></h6>
                    </div>
                  </div>
                  <div class="card-footer d-flex justify-content-between bg-light border">
                    <a href="" class="btn btn-sm text-dark p-0"><i class="fas fa-eye text-primary mr-1"></i>View Detail</a>
                    <a href="" class="btn btn-sm text-dark p-0"><i class="fas fa-shopping-cart text-primary mr-1"></i>Add To Cart</a>
                  </div>
                </div>
                <!-- 추가 상품 카드도 동일 구조 반복 (product-2.jpg ~ product-5.jpg) -->
              </div>
            </div>
          </div>
        </div>
        <!-- Products End -->

      </div>
    </div>
  </div>
</div> <!-- content end -->

<!-- ================= Footer ================= -->
<div class="container-fluid bg-secondary text-dark mt-5 pt-5 footer">
  <div class="row px-xl-5 pt-5">
    <div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
      <a href="" class="text-decoration-none">
        <h1 class="mb-4 display-5 font-weight-semi-bold">
          <span class="text-primary font-weight-bold border border-white px-3 mr-1">E</span>Shopper
        </h1>
      </a>
      <p>Dolore erat dolor sit lorem vero amet...</p>
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
            <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shop</a>
            <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shop Detail</a>
          </div>
        </div>
        <div class="col-md-4 mb-5">
          <h5 class="font-weight-bold text-dark mb-4">Quick Links</h5>
          <div class="d-flex flex-column justify-content-start">
            <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Cart</a>
            <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Checkout</a>
            <a class="text-dark" href="#"><i class="fa fa-angle-right mr-2"></i>Contact</a>
          </div>
        </div>
        <div class="col-md-4 mb-5">
          <h5 class="font-weight-bold text-dark mb-4">Newsletter</h5>
          <form>
            <div class="form-group">
              <input type="text" class="form-control border-0 py-4" placeholder="Your Name" required>
            </div>
            <div class="form-group">
              <input type="email" class="form-control border-0 py-4" placeholder="Your Email" required>
            </div>
            <div>
              <button class="btn btn-primary btn-block border-0 py-3" type="submit">Subscribe Now</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
  <div class="row border-top border-light mx-xl-5 py-4">
    <div class="col-md-6 px-xl-0">
      <p class="mb-md-0 text-center text-md-left text-dark">
        &copy; <a class="text-dark font-weight-semi-bold" href="#">Your Site Name</a>. All Rights Reserved.
      </p>
    </div>
    <div class="col-md-6 px-xl-0 text-center text-md-right">
      <img class="img-fluid" src="img/payments.png" alt="">
    </div>
  </div>
</div>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
<script src="lib/owlcarousel/owl.carousel.min.js"></script>

<script>
$(document).ready(function(){
  $(".related-carousel").owlCarousel({
    autoplay:true,
    loop:true,
    margin:15,
    nav:true,
    responsive:{
      0:{items:1},
      576:{items:2},
      768:{items:3},
      992:{items:4},
      1200:{items:5}
    }
  });
});
</script>

</body>
</html>
