$(function() {

    // ---------------------------
    // Chart.js DataLabels 플러그인 등록
    // ---------------------------
    if (window.Chart && window.ChartDataLabels) {
        Chart.register(ChartDataLabels);
    }

    // ---------------------------
    // 통일된 색상 테마 (퍼플 계열)
    // ---------------------------
    const colors = {
        primary: 'rgba(138, 43, 226, 1)',
        primaryLight: 'rgba(138, 43, 226, 0.7)',
        primaryBg: 'rgba(138, 43, 226, 0.2)',
        secondary: 'rgba(255, 105, 180, 1)',
        secondaryLight: 'rgba(255, 105, 180, 0.7)',
        secondaryBg: 'rgba(255, 105, 180, 0.2)',
        accent1: 'rgba(147, 112, 219, 1)',
        accent2: 'rgba(218, 112, 214, 1)',
        accent3: 'rgba(186, 85, 211, 1)',
        accent4: 'rgba(221, 160, 221, 1)',
        accent5: 'rgba(238, 130, 238, 1)',
        accent6: 'rgba(255, 182, 193, 1)',
        text: '#666',
        grid: 'rgba(138, 43, 226, 0.1)'
    };

    const doughnutColors = [
        colors.primary,
        colors.secondary,
        colors.accent1,
        colors.accent2,
        colors.accent3,
        colors.accent4
    ];

    // ---------------------------
    // 안전하게 차트 생성
    // ---------------------------
    const createChart = (canvasId, chartConfig, name) => {
        const $canvas = $('#' + canvasId);
        if (!$canvas.length) return null;

        chartConfig.options = chartConfig.options || {};
        chartConfig.options.responsive = true;
        chartConfig.options.maintainAspectRatio = false;

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
    // 1. 월별 매출 + 주문건수 (복합 차트)
    // ---------------------------
    $.ajax({
        url: '/api/stats/monthly-sales-orders',
        method: 'GET',
        success: function(data) {
            console.log('월별 매출/주문 데이터:', data);

            var labels = data.map(item => item.LABEL || item.label);
            var sales = data.map(item => item.SALES || item.sales || 0);
            var orders = data.map(item => item.ORDERS || item.orders || 0);

            var ctx = document.getElementById('salesChart').getContext('2d');

            var salesGradient = ctx.createLinearGradient(0, 0, 0, 300);
            salesGradient.addColorStop(0, 'rgba(138, 43, 226, 0.8)');
            salesGradient.addColorStop(1, 'rgba(138, 43, 226, 0.1)');

            createChart('salesChart', {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: '매출',
                            data: sales,
                            backgroundColor: salesGradient,
                            borderColor: colors.primary,
                            borderWidth: 2,
                            borderRadius: 8,
                            yAxisID: 'y',
                            order: 2
                        },
                        {
                            label: '주문건수',
                            data: orders,
                            type: 'line',
                            borderColor: colors.secondary,
                            backgroundColor: colors.secondaryBg,
                            borderWidth: 3,
                            fill: true,
                            tension: 0.4,
                            pointRadius: 5,
                            pointBackgroundColor: '#fff',
                            pointBorderColor: colors.secondary,
                            pointBorderWidth: 2,
                            pointHoverRadius: 7,
                            yAxisID: 'y1',
                            order: 1
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: {
                        mode: 'index',
                        intersect: false
                    },
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                usePointStyle: true,
                                pointStyle: 'circle',
                                padding: 20,
                                font: { size: 12, weight: 'bold' },
                                color: colors.text
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(138, 43, 226, 0.9)',
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            padding: 12,
                            cornerRadius: 10
                        },
                        datalabels: { display: false }
                    },
                    scales: {
                        x: {
                            grid: { display: false },
                            ticks: {
                                font: { size: 11, weight: '600' },
                                color: colors.text
                            }
                        },
                        y: {
                            type: 'linear',
                            position: 'left',
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: '💰 매출',
                                font: { size: 12, weight: 'bold' },
                                color: colors.primary
                            },
                            ticks: {
                                color: colors.primary,
                                font: { weight: '600' },
                                callback: function(value) {
                                    if (value >= 10000) {
                                        return (value / 10000).toFixed(0) + '만';
                                    }
                                    return value.toLocaleString();
                                }
                            },
                            grid: { color: colors.grid }
                        },
                        y1: {
                            type: 'linear',
                            position: 'right',
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: '📦 주문',
                                font: { size: 12, weight: 'bold' },
                                color: colors.secondary
                            },
                            ticks: {
                                color: colors.secondary,
                                font: { weight: '600' },
                                stepSize: 1
                            },
                            grid: { drawOnChartArea: false }
                        }
                    }
                }
            }, '월별 매출/주문건수');
        },
        error: function(err) {
            console.error('월별 데이터 로드 실패:', err);
            $('#status-salesChart').text('데이터 로드 실패').css('color', 'red');
        }
    });

    // ---------------------------
    // 2. 카테고리별 매출 (도넛 차트)
    // ---------------------------
    $.ajax({
        url: '/api/stats/category-sales',
        method: 'GET',
        success: function(data) {
            console.log('카테고리 데이터:', data);

            var labels = data.map(item => item.LABEL || item.label);
            var values = data.map(item => item.TOTAL || item.total || 0);

            createChart('categoryChart', {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: values,
                        backgroundColor: doughnutColors.slice(0, labels.length),
                        borderColor: '#fff',
                        borderWidth: 3,
                        hoverBorderWidth: 4,
                        hoverOffset: 10
                    }]
                },
                options: {
                    responsive: true,
                    cutout: '60%',
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: {
                                usePointStyle: true,
                                pointStyle: 'circle',
                                padding: 15,
                                font: { size: 11, weight: '600' },
                                color: colors.text
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(138, 43, 226, 0.9)',
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            padding: 12,
                            cornerRadius: 10
                        },
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
    // 3. 수입/지출 (바 차트)
    // ---------------------------
    $.ajax({
        url: '/api/stats/income-expense',
        method: 'GET',
        success: function(data) {
            console.log('수입/지출 데이터:', data);

            var labels = data.map(item => item.LABEL || item.label);
            var income = data.map(item => item.INCOME || item.income || 0);
            var expense = data.map(item => item.EXPENSE || item.expense || 0);

            var ctx = document.getElementById('stockChart').getContext('2d');

            var incomeGradient = ctx.createLinearGradient(0, 0, 0, 300);
            incomeGradient.addColorStop(0, 'rgba(138, 43, 226, 0.9)');
            incomeGradient.addColorStop(1, 'rgba(138, 43, 226, 0.3)');

            var expenseGradient = ctx.createLinearGradient(0, 0, 0, 300);
            expenseGradient.addColorStop(0, 'rgba(255, 105, 180, 0.9)');
            expenseGradient.addColorStop(1, 'rgba(255, 105, 180, 0.3)');

            createChart('stockChart', {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: '수입 (판매)',
                            data: income,
                            backgroundColor: incomeGradient,
                            borderColor: colors.primary,
                            borderWidth: 2,
                            borderRadius: 6
                        },
                        {
                            label: '지출 (입고)',
                            data: expense,
                            backgroundColor: expenseGradient,
                            borderColor: colors.secondary,
                            borderWidth: 2,
                            borderRadius: 6
                        }
                    ]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                usePointStyle: true,
                                pointStyle: 'circle',
                                padding: 20,
                                font: { size: 12, weight: 'bold' },
                                color: colors.text
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(138, 43, 226, 0.9)',
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            padding: 12,
                            cornerRadius: 10
                        },
                        datalabels: { display: false }
                    },
                    scales: {
                        x: {
                            grid: { display: false },
                            ticks: {
                                font: { size: 11, weight: '600' },
                                color: colors.text
                            }
                        },
                        y: {
                            beginAtZero: true,
                            grid: { color: colors.grid },
                            ticks: {
                                color: colors.text,
                                font: { weight: '600' },
                                callback: function(value) {
                                    if (value >= 10000) {
                                        return (value / 10000).toFixed(0) + '만';
                                    }
                                    return value.toLocaleString();
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
    // 4. 일별 매출 + 주문건수 (라인 차트)
    // ---------------------------
    $.ajax({
        url: '/api/stats/daily-orders',
        method: 'GET',
        success: function(data) {
            console.log('일별 매출/주문 데이터:', data);

            var labels = data.map(item => item.LABEL || item.label);
            var sales = data.map(item => item.SALES || item.sales || 0);
            var orders = data.map(item => item.ORDERS || item.orders || 0);

            var ctx = document.getElementById('visitorsChart').getContext('2d');

            var salesGradient = ctx.createLinearGradient(0, 0, 0, 300);
            salesGradient.addColorStop(0, 'rgba(138, 43, 226, 0.6)');
            salesGradient.addColorStop(1, 'rgba(138, 43, 226, 0.05)');

            var ordersGradient = ctx.createLinearGradient(0, 0, 0, 300);
            ordersGradient.addColorStop(0, 'rgba(255, 105, 180, 0.6)');
            ordersGradient.addColorStop(1, 'rgba(255, 105, 180, 0.05)');

            createChart('visitorsChart', {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: '매출',
                            data: sales,
                            borderColor: colors.primary,
                            backgroundColor: salesGradient,
                            fill: true,
                            tension: 0.4,
                            borderWidth: 3,
                            pointRadius: 6,
                            pointBackgroundColor: '#fff',
                            pointBorderColor: colors.primary,
                            pointBorderWidth: 3,
                            pointHoverRadius: 9,
                            pointHoverBackgroundColor: colors.primary,
                            yAxisID: 'y'
                        },
                        {
                            label: '주문건수',
                            data: orders,
                            borderColor: colors.secondary,
                            backgroundColor: ordersGradient,
                            fill: true,
                            tension: 0.4,
                            borderWidth: 3,
                            pointRadius: 6,
                            pointBackgroundColor: '#fff',
                            pointBorderColor: colors.secondary,
                            pointBorderWidth: 3,
                            pointHoverRadius: 9,
                            pointHoverBackgroundColor: colors.secondary,
                            yAxisID: 'y1'
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: {
                        mode: 'index',
                        intersect: false
                    },
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                usePointStyle: true,
                                pointStyle: 'circle',
                                padding: 20,
                                font: { size: 12, weight: 'bold' },
                                color: colors.text
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(138, 43, 226, 0.9)',
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            padding: 12,
                            cornerRadius: 10,
                            displayColors: true
                        },
                        datalabels: { display: false }
                    },
                    scales: {
                        x: {
                            grid: { display: false },
                            ticks: {
                                font: { size: 11, weight: '600' },
                                color: colors.text
                            }
                        },
                        y: {
                            type: 'linear',
                            position: 'left',
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: '💰 매출',
                                font: { size: 12, weight: 'bold' },
                                color: colors.primary
                            },
                            ticks: {
                                color: colors.primary,
                                font: { weight: '600' },
                                callback: function(value) {
                                    if (value >= 10000) {
                                        return (value / 10000).toFixed(0) + '만';
                                    }
                                    return value.toLocaleString();
                                }
                            },
                            grid: { color: colors.grid }
                        },
                        y1: {
                            type: 'linear',
                            position: 'right',
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: '📦 주문',
                                font: { size: 12, weight: 'bold' },
                                color: colors.secondary
                            },
                            ticks: {
                                color: colors.secondary,
                                font: { weight: '600' },
                                stepSize: 1
                            },
                            grid: { drawOnChartArea: false }
                        }
                    }
                }
            }, '일별 매출/주문건수');
        },
        error: function(err) {
            console.error('일별 데이터 로드 실패:', err);
            $('#status-visitorsChart').text('데이터 로드 실패').css('color', 'red');
        }
    });

    // ---------------------------
    // 초기 높이 동기화
    // ---------------------------
    setTimeout(function() {
        equalizeBottomCharts();
    }, 500);

    $(window).on('resize', function() {
        setTimeout(equalizeBottomCharts, 150);
    });

    // ---------------------------
    // 연도 선택 시 데이터 새로 불러오기
    // ---------------------------
    $('#yearSelect').on('change', function() {
        const year = $(this).val();

        $.ajax({
            url: '/api/stats/monthly',
            method: 'GET',
            data: { year: year },
            success: function(data) {
                console.log('월별 데이터:', data);

                const $tbody = $('#monthlyTableBody');
                $tbody.empty();

                data.forEach(function(r) {
                    const profit = r.PROFIT || 0;
                    const profitClass = profit >= 0 ? 'positive' : 'negative';
                    const profitRate = r.PROFITRATE || 0;

                    let statusBadge = '';
                    if (profitRate >= 50) {
                        statusBadge = '<span class="status-badge good">우수</span>';
                    } else if (profitRate >= 20) {
                        statusBadge = '<span class="status-badge warning">보통</span>';
                    }

                    $tbody.append(
                        '<tr class="monthly-row-' + profitClass + '">' +
                        '<td>' + r.YEAR + '</td>' +
                        '<td>' + parseInt(r.MONTH) + '월</td>' +
                        '<td class="num-cell">' + Number(r.SALES).toLocaleString() + '</td>' +
                        '<td class="num-cell">' + Number(r.EXPENSES).toLocaleString() + '</td>' +
                        '<td class="num-cell ' + profitClass + '">' + Number(profit).toLocaleString() + '</td>' +
                        '<td class="num-cell">' + profitRate + '%</td>' +
                        '<td>' + statusBadge + '</td>' +
                        '</tr>'
                    );
                });
            },
            error: function(err) {
                console.error('데이터 로드 실패:', err);
            }
        });
    });

    // 페이지 로드 시 초기 데이터도 스타일 적용
    $('#monthlyTableBody tr').each(function() {
        const $row = $(this);
        const profitText = $row.find('td:eq(4)').text();
        const profit = parseFloat(profitText) || 0;

        if (profit >= 0) {
            $row.addClass('monthly-row-positive');
        } else {
            $row.addClass('monthly-row-negative');
        }
    });

    // ---------------------------
    // 분류별 매출 정보 테이블 (연/월 선택)
    // ---------------------------
    function initCategoryFilter() {
        const currentYear = new Date().getFullYear();
        const currentMonth = new Date().getMonth() + 1;

        for (let y = currentYear; y >= currentYear - 2; y--) {
            $('#categoryYear').append('<option value="' + y + '">' + y + '년</option>');
        }

        for (let m = 1; m <= 12; m++) {
            const monthStr = m < 10 ? '0' + m : '' + m;
            $('#categoryMonth').append('<option value="' + monthStr + '">' + m + '월</option>');
        }

        $('#categoryYear').val(currentYear);
        $('#categoryMonth').val(currentMonth < 10 ? '0' + currentMonth : '' + currentMonth);

        loadCategorySales();
    }

    function loadCategorySales() {
        const year = $('#categoryYear').val();
        const month = $('#categoryMonth').val();

        $('#categoryStatus').text('로딩중...');

        $.ajax({
            url: '/api/stats/category-by-month',
            method: 'GET',
            data: { year: year, month: month },
            success: function(data) {
                console.log('분류별 매출 데이터:', data);

                const $tbody = $('#categorySalesTable tbody');
                $tbody.empty();

                if (data.length === 0) {
                    $tbody.append('<tr><td colspan="4" class="text-center text-muted">데이터가 없습니다.</td></tr>');
                    $('#categoryStatus').text('');
                    return;
                }

                data.forEach(function(r) {
                    const sales = r.SALES || r.sales || 0;
                    const ratio = r.RATIO || r.ratio || 0;
                    const category = r.CATEGORY || r.category || '-';

                    const ratioBar =
                        '<div class="ratio-bar">' +
                        '<div class="bar-bg"><div class="bar-fill" style="width: ' + Math.min(ratio, 100) + '%"></div></div>' +
                        '<span class="bar-text">' + ratio + '%</span>' +
                        '</div>';

                    $tbody.append(
                        '<tr>' +
                        '<td><strong>' + category + '</strong></td>' +
                        '<td class="num-cell">' + Number(sales).toLocaleString() + '</td>' +
                        '<td>' + ratioBar + '</td>' +
                        '<td></td>' +
                        '</tr>'
                    );
                });

                $('#categoryStatus').text(year + '년 ' + parseInt(month) + '월 데이터');
            },
            error: function(err) {
                console.error('분류별 매출 로드 실패:', err);
                $('#categoryStatus').text('로드 실패').css('color', 'red');
            }
        });
    }

    initCategoryFilter();

    $('#categoryFilterBtn').on('click', function() {
        loadCategorySales();
    });

});