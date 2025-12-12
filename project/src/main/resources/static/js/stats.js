$(function() {
    
    // ---------------------------
    // Chart.js DataLabels 플러그인 등록
    // ---------------------------
    if (window.Chart && window.ChartDataLabels) {
        Chart.register(ChartDataLabels);
    }

    // ---------------------------
    // 안전하게 차트 생성
    // ---------------------------
    const createChart = (canvasId, chartConfig, name) => {
        const $canvas = $('#' + canvasId);
        if (!$canvas.length) return null;

        chartConfig.options = chartConfig.options || {};
        chartConfig.options.responsive = true;
        chartConfig.options.maintainAspectRatio = false;

        // 기존 차트 삭제
        if ($canvas[0]._chartInstance) {
            try { $canvas[0]._chartInstance.destroy(); } catch (e) { console.warn('차트 삭제 실패', e); }
        }

        try {
            const chart = new Chart($canvas[0], chartConfig);
            $canvas[0]._chartInstance = chart;
            console.log('[차트 생성 성공]', name);
            return chart;
        } catch (err) {
            console.error('차트 생성 실패:', canvasId, err);
            return null;
        }
    };

    // ---------------------------
    // 하단 차트 높이 동기화
    // ---------------------------
    const equalizeBottomCharts = () => {
        const $stockWrap = $('#stockChartWrap');
        const $visitorsWrap = $('#visitorsChartWrap');
        if (!$stockWrap.length || !$visitorsWrap.length) return;

        $stockWrap.css('height', '');
        $visitorsWrap.css('height', '');
        const targetHeight = Math.max($stockWrap.height(), $visitorsWrap.height(), 220);
        $stockWrap.height(targetHeight);
        $visitorsWrap.height(targetHeight);
    };

    // ---------------------------
    // 1. 매출 흐름표 (라인 차트) - DB 연동
    // ---------------------------
    $.ajax({
        url: '/api/stats/daily-sales',
        method: 'GET',
        success: function(data) {
            console.log('매출 데이터:', data);
            
            var labels = data.map(item => item.LABEL || item.label);
            var values = data.map(item => item.TOTAL || item.total || 0);
            
            createChart('salesChart', {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: '일별 매출',
                        data: values,
                        borderColor: 'rgba(30,80,200,1)',
                        backgroundColor: 'rgba(30,80,200,0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.35
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
					maintainAspectRatio: false,
                    aspectRatio: 1.6,
                    plugins: {
                        legend: { display: true },
                        datalabels: { display: false }
                    },
                    scales: {
                        x: { grid: { display: false } },
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return value.toLocaleString() + '원';
                                }
                            }
                        }
                    }
                }
            }, '매출 흐름표');
        },
        error: function(err) {
            console.error('매출 데이터 로드 실패:', err);
            $('#status-salesChart').text('데이터 로드 실패').css('color', 'red');
        }
    });

    // ---------------------------
    // 2. 카테고리별 매출 (도넛 차트) - DB 연동
    // ---------------------------
    $.ajax({
        url: '/api/stats/category-sales',
        method: 'GET',
        success: function(data) {
            console.log('카테고리 데이터:', data);
            
            var labels = data.map(item => item.LABEL || item.label);
            var values = data.map(item => item.TOTAL || item.total || 0);
            var colors = ['rgba(54,162,235,0.9)', 'rgba(255,99,132,0.9)', 'rgba(255,205,86,0.9)', 'rgba(75,192,192,0.9)', 'rgba(153,102,255,0.9)', 'rgba(255,159,64,0.9)'];
            
            createChart('categoryChart', {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: values,
                        backgroundColor: colors.slice(0, labels.length)
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { position: 'right' },
                        datalabels: { display: false }
                    }
                }
            }, '카테고리별 매출');
        },
        error: function(err) {
            console.error('카테고리 데이터 로드 실패:', err);
            $('#status-categoryChart').text('데이터 로드 실패').css('color', 'red');
        }
    });

    // ---------------------------
    // 3. 수입/지출 (바 차트) - DB 연동
    // ---------------------------
    $.ajax({
        url: '/api/stats/income-expense',
        method: 'GET',
        success: function(data) {
            console.log('수입/지출 데이터:', data);
            
            var labels = data.map(item => item.LABEL || item.label);
            var income = data.map(item => item.INCOME || item.income || 0);
            var expense = data.map(item => item.EXPENSE || item.expense || 0);
            
            createChart('stockChart', {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: '수입 (판매)',
                            data: income,
                            backgroundColor: 'rgba(54,162,235,0.7)'
                        },
                        {
                            label: '지출 (입고)',
                            data: expense,
                            backgroundColor: 'rgba(255,99,132,0.7)'
                        }
                    ]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { position: 'top' },
                        datalabels: { display: false }
                    },
                    scales: {
                        x: { stacked: false },
                        y: {
                            stacked: false,
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return value.toLocaleString() + '원';
                                }
                            }
                        }
                    }
                }
            }, '수입/지출 차트');
        },
        error: function(err) {
            console.error('수입/지출 데이터 로드 실패:', err);
            $('#status-stockChart').text('데이터 로드 실패').css('color', 'red');
        }
    });

    // ---------------------------
    // 4. 주문건수 (라인 차트) - DB 연동
    // ---------------------------
    $.ajax({
        url: '/api/stats/daily-orders',
        method: 'GET',
        success: function(data) {
            console.log('주문건수 데이터:', data);
            
            var labels = data.map(item => item.LABEL || item.label);
            var orders = data.map(item => item.ORDERS || item.orders || 0);
            
            createChart('visitorsChart', {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: '주문건수',
                        data: orders,
                        borderColor: 'rgba(255,159,64,1)',
                        backgroundColor: 'rgba(255,159,64,0.2)',
                        fill: true,
                        tension: 0.3
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { position: 'top' },
                        datalabels: { display: false }
                    },
                    scales: {
                        x: { ticks: { color: '#666' } },
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1,
                                color: '#666'
                            }
                        }
                    }
                }
            }, '주문건수 차트');
        },
        error: function(err) {
            console.error('주문건수 데이터 로드 실패:', err);
            $('#status-visitorsChart').text('데이터 로드 실패').css('color', 'red');
        }
    });

    // ---------------------------
    // 초기 높이 동기화
    // ---------------------------
    setTimeout(function() {
        equalizeBottomCharts();
    }, 500);

    // 리사이즈 시 높이 재조정
    $(window).on('resize', function() {
        setTimeout(equalizeBottomCharts, 150);
    });

});