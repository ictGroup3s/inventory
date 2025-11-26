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

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
<script src="lib/owlcarousel/owl.carousel.min.js"></script>

<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>

<!-- Chart.js (single include) -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- Chart.js DataLabels plugin (optional, used for percent labels) -->
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>

<script src="js/main.js"></script>

<script>
  // Register DataLabels plugin if present
  if (window.Chart && window.ChartDataLabels) {
    Chart.register(ChartDataLabels);
  }

  // Create charts after DOM is ready to ensure canvas elements exist
  document.addEventListener('DOMContentLoaded', function() {
    // Defensive: remove 'h-100' from cards that contain charts to prevent forced full-height stretching
    try {
      document.querySelectorAll('.card.h-100').forEach(function(card){
        if (card.querySelector('.chart-box')) {
          card.classList.remove('h-100');
          // ensure card doesn't get forced to full height
          card.style.height = 'auto';
        }
      });
    } catch(e){ console.warn('card adjust failed', e); }
    
    // Debug helper: log sizes of chart containers and canvases (visible in console)
    function logSizes(name, canvas){
      if (!canvas) return;
      const parent = canvas.parentElement;
      console.log('[chart-size]', name, 'parent', parent.clientWidth+'x'+parent.clientHeight, 'canvas(css)', canvas.clientWidth+'x'+canvas.clientHeight, 'canvas(pixels)', canvas.width+'x'+canvas.height);
    }
    
    // Window resize logger to observe growth behavior
    let _resizeLogTimer = null;
    window.addEventListener('resize', function(){
      if (_resizeLogTimer) clearTimeout(_resizeLogTimer);
      _resizeLogTimer = setTimeout(function(){
        ['salesChart','stockChart','visitorsChart','categoryChart'].forEach(function(id){
          const c = document.getElementById(id);
          if (c) logSizes(id, c);
        });
      }, 200);
    });

     // Helper: safe create chart with try/catch
     function safeCreate(createFn, name) {
      try {
        createFn();
        console.log(name + ' initialized');
      } catch (e) {
        console.error('Error initializing ' + name, e);
      }
    }

    // Helper: create a responsive Chart and keep a reference on the canvas element
    function createChart(canvasId, chartConfig, name) {
      try {
        const canvas = document.getElementById(canvasId);
        if (!canvas) return null;
        // ensure options exist
        chartConfig.options = chartConfig.options || {};
        // let Chart.js handle sizing responsively but allow CSS height
        chartConfig.options.responsive = true;
        chartConfig.options.maintainAspectRatio = false; // we'll control container height via CSS/JS

        if (canvas._chartInstance) {
          try { canvas._chartInstance.destroy(); } catch(e) { console.warn('destroy failed', e); }
        }
        // pass the canvas element (preferred) so Chart.js can size it
        const chart = new Chart(canvas, chartConfig);
        canvas._chartInstance = chart;
        logSizes(name, canvas);
        return chart;
      } catch (err) {
        console.error('createChart error for ' + canvasId, err);
        return null;
      }
    }

    // Debounced resize: recalc canvas sizes and call chart.resize()
    let _chartResizeTimer = null;
    function scheduleChartResize() {
      if (_chartResizeTimer) clearTimeout(_chartResizeTimer);
      _chartResizeTimer = setTimeout(function(){
        // Equalize container heights first, then ask charts to resize to fit
        equalizeBottomCharts();
        ['salesChart','stockChart','visitorsChart','categoryChart'].forEach(function(id){
          const c = document.getElementById(id);
          if (!c || !c._chartInstance) return;
          try { c._chartInstance.resize(); } catch(e) { console.warn('chart resize failed', e); }
          logSizes(id, c);
        });
      }, 150);
    }
    window.addEventListener('resize', scheduleChartResize);
    
    // Equalize heights for 'stockChartWrap' and 'visitorsChartWrap'
    function equalizeBottomCharts() {
      try {
        const a = document.getElementById('stockChartWrap');
        const b = document.getElementById('visitorsChartWrap');
        if (!a || !b) return;
        // reset any inline height to measure natural heights
        a.style.height = '';
        b.style.height = '';
        // measure (use computed style if clientHeight is 0)
        let ha = a.clientHeight;
        let hb = b.clientHeight;
        if (!ha || ha === 0) {
          const cs = window.getComputedStyle(a);
          ha = Math.round(parseFloat(cs && cs.height) || 0);
        }
        if (!hb || hb === 0) {
          const cs2 = window.getComputedStyle(b);
          hb = Math.round(parseFloat(cs2 && cs2.height) || 0);
        }
        const target = Math.max(ha || 0, hb || 0, 220); // ensure a reasonable minimum
        // apply pixel height to both
        a.style.height = target + 'px';
        b.style.height = target + 'px';
        // also resize canvases inside
        ['stockChart','visitorsChart'].forEach(function(id){
          const c = document.getElementById(id);
          if (!c || !c._chartInstance) return;
          try { c._chartInstance.resize(); } catch(e) { console.warn('chart resize failed', e); }
          logSizes(id, c);
        });
      } catch(e) { console.warn('equalizeBottomCharts failed', e); }
    }

    // Equalize full card heights (including headers, paragraphs) for the two bottom chart cards
    function equalizeBottomCardHeights() {
      try {
        // find the closest .card elements that contain the two chart-wraps
        const aWrap = document.getElementById('stockChartWrap');
        const bWrap = document.getElementById('visitorsChartWrap');
        if (!aWrap || !bWrap) return;
        const aCard = aWrap.closest('.card');
        const bCard = bWrap.closest('.card');
        if (!aCard || !bCard) return;

        // reset inline heights to measure natural heights
        aCard.style.height = '';
        bCard.style.height = '';

        // measure outer heights
        const ha = aCard.offsetHeight;
        const hb = bCard.offsetHeight;
        const target = Math.max(ha || 0, hb || 0);

        // apply the pixel height to both cards
        aCard.style.height = target + 'px';
        bCard.style.height = target + 'px';
      } catch (e) {
        console.warn('equalizeBottomCardHeights failed', e);
      }
    }

    // --- 매출 흐름표 (line) ---
    safeCreate(function() {
      const canvas = document.getElementById('salesChart');
      if (!canvas) return;
      const salesCtx = canvas.getContext('2d');
      
      const labels = ['5월', '6월', '7월', '8월', '9월', '10월', '11월'];
      const dataRed = [710, 640, 690, 720, 790, 880, 940];
      const dataBlue  = [1820, 1750, 1630, 1660, 2080, 2350, 2630];

      const gradBlue = salesCtx.createLinearGradient(0, 0, 0, 250);
      gradBlue.addColorStop(0, 'rgba(30, 80, 200, 1)');
      gradBlue.addColorStop(1, 'rgba(30, 80, 200, 0.8)');

      const config = {
        type: 'line',
        data: {
          labels: labels,
          datasets: [
            { label: '매출 총액', data: dataBlue, borderColor: gradBlue, borderWidth: 3, pointRadius: 0, tension: 0.35, fill: false, cubicInterpolationMode: 'monotone', datalabels: { display: false } },
            { label: '지출 총액', data: dataRed, borderColor: 'rgba(230,100,120,0.95)', borderWidth: 2, pointRadius: 0, tension: 0.35, fill: false, cubicInterpolationMode: 'monotone', datalabels: { display: false } }
          ]
        },
        options: {
          responsive: true,
          maintainAspectRatio: true,
          aspectRatio: 1.6,
          plugins: {
            legend: { display: false },
            tooltip: { mode: 'index', intersect: false },
            // Ensure datalabels are disabled for line chart (no numbers drawn inside line)
            datalabels: { display: false }
          },
          scales: {
            x: { grid: { display: false }, ticks: { color: '#666', padding: 6 } },
            y: { grid: { color: 'rgba(0,0,0,0.06)', drawBorder: false }, ticks: { color: '#666' } }
          },
           elements: { line: { borderJoinStyle: 'round' } }
         }
       };

      // create chart with explicit canvas sizing to prevent growth
      createChart('salesChart', config, 'Sales Chart');
    // equalize bottom charts after initial creation
    setTimeout(equalizeBottomCharts, 250);
    }, 'Sales Chart');

    // --- 수입/지출 (bar) ---
    safeCreate(function() {
      const canvas = document.getElementById('stockChart');
      if (!canvas) return;
      const stockCtx = canvas.getContext('2d');

      const stockLabels = ['5월', '6월', '7월', '8월', '9월', '10월', '11월'];
      const incomeData =  [1200, 1500, 1100, 1400, 1700, 1600, 1900];
      const expenseData = [ 800,  700,  900, 1000,  850, 1200, 1100];

      const stockConfig = {
        type: 'bar',
        data: { labels: stockLabels, datasets: [ { label: '수입', data: incomeData, backgroundColor: 'rgba(54,162,235,0.85)', borderColor: 'rgba(54,162,235,1)', borderWidth: 1 }, { label: '지출', data: expenseData, backgroundColor: 'rgba(255,99,132,0.85)', borderColor: 'rgba(255,99,132,1)', borderWidth: 1 } ] },
        options: {
          responsive: true,
          maintainAspectRatio: true,
          aspectRatio: 1.6,
          plugins: {
            legend: { display: false, position: 'top' },
            tooltip: { callbacks: { label: function(context){ return context.dataset.label + ': ' + context.raw.toLocaleString() + ' (만원)'; } } },
            // Ensure datalabels are disabled for bar chart (no numbers drawn inside bars)
            datalabels: { display: false }
          },
          scales: { x: { grid: { display: false }, ticks: { color: '#666' } }, y: { grid: { color: 'rgba(0,0,0,0.06)', drawBorder: false }, ticks: { color: '#666', callback: function(value){ return value.toLocaleString() + ' (만원)'; } } } }
        }
      };

      createChart('stockChart', stockConfig, 'Stock Chart');
    setTimeout(equalizeBottomCharts, 250);
    }, 'Stock Chart');

    // --- 방문자수 / 주문건수 (line) ---
    safeCreate(function() {
      const canvas = document.getElementById('visitorsChart');
      if (!canvas) return;
      const ctx = canvas.getContext('2d');

      const labels = ['5월', '6월', '7월', '8월', '9월', '10월', '11월'];
      // 샘플 데이터: 방문자수(명)와 주문건수(건)
      const visitors = [1200, 1500, 1100, 1400, 1700, 1600, 1900];
      const orders   = [120,  150,  110,  140,  170,  160,  190];

      const visitorsGrad = ctx.createLinearGradient(0,0,0,250);
      visitorsGrad.addColorStop(0, 'rgba(54,162,235,1)');
      visitorsGrad.addColorStop(1, 'rgba(54,162,235,0.6)');

      const visitorsConfig = {
        type: 'line',
        data: {
          labels: labels,
          datasets: [
            { label: '방문자수', data: visitors, borderColor: visitorsGrad, backgroundColor: 'rgba(54,162,235,0.1)', borderWidth: 2, pointRadius: 2, tension: 0.35, fill: true, datalabels: { display:false } },
            { label: '주문건수', data: orders, borderColor: 'rgba(75,192,192,0.9)', backgroundColor: 'rgba(75,192,192,0.08)', borderWidth: 2, pointRadius: 2, tension: 0.35, fill: true, datalabels: { display:false } }
          ]
        },
        options: {
          responsive: true,
          maintainAspectRatio: true,
          aspectRatio: 1.6,
          plugins: { legend: { position: 'top' }, tooltip: { mode: 'index', intersect: false } },
          scales: { x: { grid: { display:false } }, y: { grid: { color: 'rgba(0,0,0,0.06)' }, ticks: { color: '#666' } } }
        }
      };

      createChart('visitorsChart', visitorsConfig, 'Visitors Chart');
    setTimeout(equalizeBottomCharts, 250);
    }, 'Visitors Chart');

    // --- 분류별 매출 (doughnut) ---
    safeCreate(function() {
      const canvas = document.getElementById('categoryChart');
      if (!canvas) return;
      const catCtx = canvas.getContext('2d');

      const catLabels = ['분류1', '분류2', '분류3', '분류4', '기타'];
      const catData = [5200, 3400, 2800, 1900, 700];
      const colors = ['rgba(54,162,235,0.9)','rgba(255,99,132,0.9)','rgba(255,205,86,0.9)','rgba(75,192,192,0.9)','rgba(153,102,255,0.9)'];

      const categoryConfig = {
        type: 'doughnut',
        data: { labels: catLabels, datasets: [{ data: catData, backgroundColor: colors, hoverOffset: 8 }] },
        options: {
          responsive: true,
          maintainAspectRatio: true,
          aspectRatio: 1.6,
          cutout: '20%',
          plugins: {
            legend: { position: 'right', labels: { boxWidth: 12, padding: 12 } },
            datalabels: {
              color: '#ffffff', anchor: 'center', align: 'center',
              formatter: function(value, context) {
                const data = context.chart.data.datasets[0].data;
                const total = data.reduce((a, b) => a + b, 0);
                if (total === 0) return '0%';
                const percent = (value / total * 100);
                const display = percent >= 1 ? Math.round(percent) : percent.toFixed(1);
                return display + '%';
              },
              font: { weight: '600', size: 12 }
            },
            tooltip: { callbacks: { label: function(context){ const label = context.label || ''; const value = context.raw; const total = context.chart.data.datasets[0].data.reduce((a,b)=>a+b,0); const percent = ((value / total) * 100).toFixed(1); return label + ': ' + value.toLocaleString() + ' (만원) — ' + percent + '%'; } } }
          }
        }
      };

      createChart('categoryChart', categoryConfig, 'Category Chart');
    setTimeout(equalizeBottomCharts, 250);
    }, 'Category Chart');

    // Ensure equal heights on initial load (after charts have been initialized)
    setTimeout(function(){ scheduleChartResize(); equalizeBottomCharts(); equalizeBottomCardHeights(); }, 500);
    // Also call card-equalization on resize (debounced via scheduleChartResize)
    // scheduleChartResize already calls equalizeBottomCharts() and resizes charts; call card equalization too
    const _origSchedule = scheduleChartResize;
    scheduleChartResize = function() {
      if (window._user_schedule_timer) clearTimeout(window._user_schedule_timer);
      window._user_schedule_timer = setTimeout(function(){
        equalizeBottomCharts();
        equalizeBottomCardHeights();
        ['salesChart','stockChart','visitorsChart','categoryChart'].forEach(function(id){
          const c = document.getElementById(id);
          if (!c || !c._chartInstance) return;
          try { c._chartInstance.resize(); } catch(e) { console.warn('chart resize failed', e); }
          logSizes(id, c);
        });
      }, 150);
    };
    window.addEventListener('resize', scheduleChartResize);
    
    // --- Dev helper buttons (visible on page) ---
    // Removed: development-only floating debug buttons ("차트 재로딩", "차트 동기화").
    // These buttons injected a fixed-position container and are not needed in production.
    
    // Initialize DataTable after DOM is ready (also inside existing DOMContentLoaded)
    try {
        if (window.jQuery && $.fn.dataTable) {
            $('#monthlyTable').DataTable({
                paging: true,
                searching: true,
                ordering: true,
                // newest-first: year(desc), month(desc)
                order: [[0, 'desc'], [1, 'desc']],
                dom: 'Bfrtip',
                buttons: [ 'csv', 'excel' ]
            });
            console.log('DataTable initialized');
        }
    } catch (e) { console.error('DataTable init error', e); }

    // Category-by-month: selectors + fetch/update logic
    (function(){
      // fallback sample data (keyed by 'YYYY-M' or 'default')
      const fallbackCategoryData = {
        'default': [
          { category: '분류1', sales: 5200, note: '샘플' },
          { category: '분류2', sales: 3400, note: '샘플' },
          { category: '분류3', sales: 2800, note: '샘플' },
          { category: '분류4', sales: 1900, note: '샘플' },
          { category: '기타',  sales: 700,  note: '샘플' }
        ]
        // you may add entries like '2025-11': [ ... ] for month-specific samples
      };

      // populate year/month selects (last 4 years)
      function populateYearMonthSelectors(){
        const ySel = document.getElementById('categoryYear');
        const mSel = document.getElementById('categoryMonth');
        if(!ySel || !mSel) return;
        const now = new Date();
        const curYear = now.getFullYear();
        ySel.innerHTML = '';
        for(let y=curYear; y>=curYear-3; y--){
          const opt = document.createElement('option'); opt.value = y; opt.text = y + '년';
          ySel.appendChild(opt);
        }
        mSel.innerHTML = '';
        for(let m=1; m<=12; m++){
          const opt = document.createElement('option'); opt.value = m; opt.text = m + '월';
          mSel.appendChild(opt);
        }
        // select current month
        ySel.value = curYear;
        mSel.value = now.getMonth()+1;
      }

      async function fetchCategoryData(year, month){
        // try backend API first (assumption: /api/category-sales?year=YYYY&month=MM returns JSON array)
        try{
          const url = '/api/category-sales?year=' + encodeURIComponent(year) + '&month=' + encodeURIComponent(month);
          const res = await fetch(url, { credentials: 'same-origin' });
          if(!res.ok) throw new Error('no-api');
          const json = await res.json();
          // expect array of {category, sales, note}
          return json;
        }catch(e){
          console.warn('Category API unavailable or failed, using fallback sample data', e);
          const key = year + '-' + month;
          return fallbackCategoryData[key] || fallbackCategoryData['default'];
        }
      }

      function renderCategoryTable(items){
        const tbody = document.querySelector('#categorySalesTable tbody');
        if(!tbody) return;
        const total = items.reduce((s,i)=>s + (Number(i.sales) || 0), 0);
        tbody.innerHTML = items.map(function(i){
          const pct = total ? ((Number(i.sales) || 0) / total * 100).toFixed(1) + '%' : '0%';
          return '<tr>' +
            '<td>' + (i.category || '') + '</td>' +
            '<td>' + (i.sales != null ? (Number(i.sales).toLocaleString()) : '') + '</td>' +
            '<td>' + pct + '</td>' +
            '<td>' + (i.note || '') + '</td>' +
            '</tr>';
        }).join('');
      }

      // small palette reuse (keeps same colors as initial doughnut creation)
      const _categoryColors = ['rgba(54,162,235,0.9)','rgba(255,99,132,0.9)','rgba(255,205,86,0.9)','rgba(75,192,192,0.9)','rgba(153,102,255,0.9)'];

      function renderCategoryChart(items){
        const labels = items.map(i=>i.category || '');
        const data = items.map(i=>Number(i.sales) || 0);
        const canvas = document.getElementById('categoryChart');
        if(!canvas) return;
        const chart = canvas._chartInstance;
        if(chart){
          chart.data.labels = labels;
          if(chart.data.datasets && chart.data.datasets[0]){
            chart.data.datasets[0].data = data;
            // adjust colors to match labels length
            chart.data.datasets[0].backgroundColor = _categoryColors.slice(0, labels.length);
          } else {
            chart.data.datasets = [{ data: data, backgroundColor: _categoryColors.slice(0, labels.length) }];
          }
          try{ chart.update(); }catch(e){ console.warn('chart update failed', e); }
        } else {
          // create a new doughnut chart if missing
          const cfg = {
            type: 'doughnut',
            data: { labels: labels, datasets: [{ data: data, backgroundColor: _categoryColors.slice(0, labels.length), hoverOffset: 8 }] },
            options: {
              responsive: true,
              maintainAspectRatio: true,
              aspectRatio: 1.6,
              cutout: '20%',
              plugins: {
                legend: { position: 'right', labels: { boxWidth: 12, padding: 12 } },
                datalabels: {
                  color: '#ffffff', anchor: 'center', align: 'center',
                  formatter: function(value, context) {
                    const data = context.chart.data.datasets[0].data;
                    const total = data.reduce((a, b) => a + b, 0);
                    if (total === 0) return '0%';
                    const percent = (value / total * 100);
                    const display = percent >= 1 ? Math.round(percent) : percent.toFixed(1);
                    return display + '%';
                  },
                  font: { weight: '600', size: 12 }
                }
              }
            }
          };
          createChart('categoryChart', cfg, 'Category Chart (dynamic)');
        }
      }

      // perform a full update cycle for selected year/month
      async function updateCategoryView(year, month){
        const status = document.getElementById('categoryStatus');
        const btn = document.getElementById('categoryFilterBtn');
        if(status) status.textContent = '조회중...';
        if(btn) btn.disabled = true;
        try{
          const items = await fetchCategoryData(year, month);
          // ensure numeric sales and compute percent in render
          renderCategoryTable(items);
          renderCategoryChart(items);
          if(status) status.textContent = '마지막 조회: ' + year + '년 ' + month + '월';
        }catch(e){
          if(status) status.textContent = '조회 실패';
          console.error('updateCategoryView error', e);
        }finally{
          if(btn) btn.disabled = false;
        }
      }

      // wire actions
      document.getElementById('categoryFilterBtn') && document.getElementById('categoryFilterBtn').addEventListener('click', function(e){
        const y = document.getElementById('categoryYear').value;
        const m = document.getElementById('categoryMonth').value;
        updateCategoryView(y, m);
      });

      // init selectors then trigger initial load (current year/month)
      populateYearMonthSelectors();
      try{
        const y0 = document.getElementById('categoryYear').value;
        const m0 = document.getElementById('categoryMonth').value;
        if(y0 && m0) updateCategoryView(y0, m0);
      }catch(e){ console.warn('init category selectors failed', e); }
    })();

    // Initialize the new tables if present
    try {
      if (window.jQuery && $.fn.dataTable) {
        if ($('#dailyTable').length) {
          $('#dailyTable').DataTable({ paging:true, searching:true, order:[[0,'desc']], dom:'Bfrtip', buttons:['csv','excel'] });
        }
        if ($('#monthlyMetricsTable').length) {
          // newest-first on year/month
          $('#monthlyMetricsTable').DataTable({ paging:true, searching:true, order:[[0,'desc'],[1,'desc']], dom:'Bfrtip', buttons:['csv','excel'] });
        }
      }
    } catch(e) { console.error('init other tables', e); }
  });
</script>

</body>
</html>

<!-- Add a small inline style to keep chart container heights consistent -->
<style>
/*  Use explicit fixed heights to prevent parent containers from growing indefinitely.
    Chart.js will respect canvas size when maintainAspectRatio is true and aspectRatio is set.
*/
.chart-box { width:100%; height:320px; max-height:60vh; }

/* On medium screens keep similar ratio but limit the max height to avoid overly tall charts */
@media (max-width: 992px) {
  .chart-box { height:300px; max-height:55vh; }
}

/* On small screens cap height to avoid using too much vertical space */
@media (max-width: 576px) {
  .chart-box { height:220px; max-height:40vh; }
}

/* Keep card bodies using flex so chart-box fills available space */
.card.h-100 > .card-body { /* keep default flow to avoid forcing equal-height stretching */ }
.row { align-items: flex-start; }
.card.h-100 { height: auto !important; }
.card.h-100 > .card-body { /* keep default flow to avoid forcing equal-height stretching */ }

/* Force canvases to fully fill their container (Chart.js respects canvas size) */
.chart-box canvas { width:100% !important; display:block; }

/* --- Table tweaks: smaller font and tighter padding for metric tables --- */
/* Make daily table more compact so date fits on one line */
#dailyTable, #monthlyMetricsTable, #monthlyTable {
  font-size: 12px; /* smaller */
}
#dailyTable td, #dailyTable th, #monthlyMetricsTable td, #monthlyMetricsTable th {
  padding: .25rem .4rem; /* tighter cell padding */
}
/* Prevent date column from wrapping in daily table and give it a fixed min width */
#dailyTable th:first-child, #dailyTable td:first-child {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  min-width: 92px; /* ensure date column has enough width */
  max-width: 120px;
}
/* If still tight on very small screens, shrink font a bit more */
@media (max-width: 768px) {
  #dailyTable { font-size: 11px; }
  #dailyTable th:first-child, #dailyTable td:first-child { min-width: 80px; }
}
@media (max-width: 576px) {
  #dailyTable, #monthlyMetricsTable, #monthlyTable { font-size: 11px; }
}
#categorySalesTable th, td {
	font-size: 12px;
}
</style>
