<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>통계</title>
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
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">
<link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

<!-- DataTables CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" />
<link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.dataTables.min.css" />

<!-- Custom Styles -->
<link rel="stylesheet" href="css/style.css">


<!-- jQuery 먼저 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- Chart.js DataLabels -->
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>

<!-- DataTables -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<!-- custom JS -->
<script src="js/stats.js"></script>


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
    <div class="row">
        <!-- Sidebar -->
        <nav id="sidebarMenu" class="col-lg-2 d-lg-block bg-light sidebar admin-sidebar collapse">
            <h6>관리자 페이지</h6>
            <ul class="nav flex-column">
                <li class="nav-item"><a href="#" class="nav-link">대쉬보드</a></li>
                <li class="nav-item"><a href="item" class="nav-link">상품관리</a></li>
                <li class="nav-item"><a href="stock" class="nav-link">입고/재고관리</a></li>
                <li class="nav-item"><a href="order" class="nav-link">주문관리</a></li>
                <li class="nav-item"><a href="#" class="nav-link">통계</a></li>
                <li class="nav-item"><a href="mlist" class="nav-link">고객관리</a></li>
            </ul>
        </nav>

        <!-- Dashboard Content -->
        <div class="col-lg-9">
            <!-- Mobile toggler for sidebar -->
            <nav class="navbar navbar-light bg-light d-lg-none">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#sidebarMenu">
                    <span class="navbar-toggler-icon"></span>
                </button>
            </nav>

            <div class="dashboard-content">            
                <!-- 상단 영역 -->
                <div class="row">
                    <div class="col-lg-6 col-md-12 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">매출 흐름표</h6>
                                <!-- Inserted Chart canvas -->
                                <div id="chartWrapSales" class="chart-box">
                                  <canvas id="salesChart"></canvas>
                                  <div id="status-salesChart" class="chart-status text-danger small mt-1" aria-live="polite"></div>
                                </div>
                            </div>
                        </div>
                    </div>                    
                
                
                    <div class="col-lg-6 col-md-12 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">매출/분류별</h6>
                                <!-- 분류별 매출액 -->
                                <div id="chartWrapCategory" class="chart-box">
                                            <canvas id="categoryChart"></canvas>
                                            <div id="status-categoryChart" class="chart-status text-danger small mt-1" aria-live="polite"></div>
                                        </div>
                            </div>
                        </div>
                    </div>                    
                
            </div>
                <!-- 하단 영역 -->
				
				                

                <div class="row"> <!-- 하단 chart row -->
                    <div class="col-lg-6 col-md-12 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">수입/지출</h6>
                                <div id="stockChartWrap" class="chart-box">
                                    <canvas id="stockChart"></canvas>
                                    <div id="status-stockChart" class="chart-status text-danger small mt-1" aria-live="polite"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 방문자수 / 주문건수 차트 -->
                    <div class="col-lg-6 col-md-12 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">방문자수 / 주문건수</h6>
                                <p class="text-muted small">기간별 방문자수와 주문건수 (샘플)</p>
                                <div id="visitorsChartWrap" class="chart-box">
                                    <canvas id="visitorsChart"></canvas>
                                    <div id="status-visitorsChart" class="chart-status text-danger small mt-1" aria-live="polite"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                 </div>
 				
 				<!-- 연도별/월별 매출·지출 상세 테이블 -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">연도별·월별 매출 / 지출 (상세)</h6>
                                <p class="text-muted small">최근 데이터 — 서버에서 제공되는 값을 보여줍니다.</p>
                                <div class="table-responsive">
                                    <table id="monthlyTable" class="table table-bordered table-sm" style="width:100%">
                                        <thead>
                                            <tr>
                                                <th>연도</th>
                                                <th>월</th>
                                                <th>매출 (만원)</th>
                                                <th>지출 (만원)</th>
                                                <th>이익 (만원)</th>
                                                <th>수익률(%)</th>
                                                <th>비고</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="r" items="${monthlyData}">
                                                <tr>
                                                    <td>${r.year}</td>
                                                    <td>${r.month}</td>
                                                    <td>${r.sales}</td>
                                                    <td>${r.expenses}</td>
                                                    <td>${r.profit}</td>
                                                    <td>${r.profitRate}</td>
                                                    <td>${r.note}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 분류별 매출 정보 테이블 (매출/분류별 카드 아래) -->
                <div class="row mb-3">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">분류별 매출 정보</h6>
                                <p class="text-muted small">단위: 만원 (샘플 데이터) — 서버 데이터로 대체 가능</p>
                                <!-- Added: Year/Month selector for monthly view -->
                                <div class="d-flex align-items-center mb-2">
                                    <div class="form-inline">
                                      <label class="mr-2 small text-muted" for="categoryYear">연도</label>
                                      <select id="categoryYear" class="form-control form-control-sm mr-3"></select>
                                      <label class="mr-2 small text-muted" for="categoryMonth">월</label>
                                      <select id="categoryMonth" class="form-control form-control-sm mr-3"></select>
                                      <button id="categoryFilterBtn" class="btn btn-sm btn-primary">조회</button>
                                      <small id="categoryStatus" class="text-muted ml-3"></small>
                                    </div>
                                </div>
                                <div class="table-responsive">
                                    <table id="categorySalesTable" class="table table-striped table-sm">
                                        <thead>
                                            <tr>
                                                <th scope="col">분류</th>
                                                <th scope="col">매출 (만원)</th>
                                                <th scope="col">비중</th>
                                                <th scope="col">비고</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>분류1</td>
                                                <td>5200</td>
                                                <td>35.4%</td>
                                                <td>비고내용</td>
                                            </tr>
                                            <tr>
                                                <td>분류2</td>
                                                <td>3400</td>
                                                <td>23.1%</td>
                                                <td>비고내용</td>
                                            </tr>
                                            <tr>
                                                <td>분류3</td>
                                                <td>2800</td>
                                                <td>19.1%</td>
                                                <td>비고내용</td>
                                            </tr>
                                            <tr>
                                                <td>분류4</td>
                                                <td>1900</td>
                                                <td>13.0%</td>
                                                <td>비고내용</td>
                                            </tr>
                                            <tr>
                                                <td>기타</td>
                                                <td>700</td>
                                                <td>4.4%</td>
                                                <td>비고내용</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            
                <!-- 방문자/주문 상세: 일간 및 월간 테이블 (분류별 매출 정보 아래) -->
                <div class="row mb-4">
                    <div class="col-lg-6 col-md-12 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">일일 방문자수 / 주문건수 (최근 7일)</h6>
                                <p class="text-muted small">날짜별 방문자 및 주문 집계</p>
                                <div class="table-responsive">
                                    <table id="dailyTable" class="table table-sm table-striped" style="width:100%">
                                        <thead>
                                            <tr><th>날짜</th><th>방문자수</th><th>주문건수</th><th>비고</th></tr>
                                        </thead>
                                        <tbody>
                                          <c:forEach var="d" items="${dailyMetrics}">
                                            <tr>
                                              <td>${d.date}</td>
                                              <td>${d.visitors}</td>
                                              <td>${d.orders}</td>
                                              <td>${d.note}</td>
                                            </tr>
                                          </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6 col-md-12 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">월별 방문자수 / 주문건수 (최근 12개월)</h6>
                                <p class="text-muted small">월별 방문자 및 주문 합계</p>
                                <div class="table-responsive">
                                    <table id="monthlyMetricsTable" class="table table-sm table-bordered" style="width:100%">
                                        <thead>
                                            <tr><th>연도</th><th>월</th><th>방문자수</th><th>주문건수</th><th>평균 주문/일</th><th>비고</th></tr>
                                        </thead>
                                        <tbody>
                                          <c:forEach var="m" items="${monthlyVisitors}">
                                            <tr>
                                              <td>${m.year}</td>
                                              <td>${m.month}</td>
                                              <td>${m.visitors}</td>
                                              <td>${m.orders}</td>
                                              <td>${m.avgPerDay}</td>
                                              <td>${m.note}</td>
                                            </tr>
                                          </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            
        </div>
    </div>
</div>

<!-- Footer (기존 Footer 사용) -->
<div class="container-fluid bg-secondary text-dark mt-5 pt-5">
    <div class="row px-xl-5 pt-5">
        <div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
            <a href="#" class="text-decoration-none">
                <h1 class="mb-4 display-5 font-weight-semi-bold">
                    <span class="text-primary font-weight-bold border border-white px-3 mr-1">E</span>Shopper
                </h1>
            </a>
            <p>Dolore erat dolor sit lorem vero amet. Sed sit lorem magna, ipsum no sit erat lorem et magna ipsum dolore amet erat.</p>
        </div>
        <div class="col-lg-8 col-md-12">
            <div class="row">
                <div class="col-md-4 mb-5">
                    <h5 class="font-weight-bold text-dark mb-4">Quick Links</h5>
                    <div class="d-flex flex-column justify-content-start">
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Home</a>
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Our Shop</a>
                    </div>
                </div>
                <div class="col-md-4 mb-5">
                    <h5 class="font-weight-bold text-dark mb-4">Quick Links</h5>
                    <div class="d-flex flex-column justify-content-start">
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shop Detail</a>
                        <a class="text-dark mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shopping Cart</a>
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




</body>
</html>

