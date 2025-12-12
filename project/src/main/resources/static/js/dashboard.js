/**
 * 
 */

$(function() {
    
    // 숫자 포맷 (1000 → 1,000)
    function formatNumber(num) {
        return num ? num.toLocaleString() : '0';
    }

    // ---------------------------
    // 1. 대시보드 요약 정보 로드
    // ---------------------------
    $.ajax({
        url: '/api/dashboard/summary',
        method: 'GET',
        success: function(data) {
            console.log('요약 데이터:', data);
            
            $('#newMembers').text(formatNumber(data.NEW_MEMBERS || data.new_members || 0));
            $('#todayOrders').text(formatNumber(data.TODAY_ORDERS || data.today_orders || 0));
            $('#todaySales').text(formatNumber(data.TODAY_SALES || data.today_sales || 0));
            $('#monthSales').text(formatNumber(data.MONTH_SALES || data.month_sales || 0));
            $('#totalOrders').text(formatNumber(data.TOTAL_ORDERS || data.total_orders || 0));
            $('#totalSales').text(formatNumber(data.TOTAL_SALES || data.total_sales || 0));
        },
        error: function(err) {
            console.error('요약 데이터 로드 실패:', err);
        }
    });

    // ---------------------------
    // 2. 최근 주문 목록 로드
    // ---------------------------
    $.ajax({
        url: '/api/dashboard/recent-orders',
        method: 'GET',
        success: function(data) {
            console.log('최근 주문:', data);
            
            var html = '';
            data.forEach(function(order) {
                html += '<tr>';
                html += '<td>' + (order.CUSTOMER_NAME || order.customer_name || '-') + '</td>';
                html += '<td>' + (order.ITEM_NAME || order.item_name || '-') + '</td>';
                html += '<td>' + (order.QTY || order.qty || 0) + '</td>';
                html += '<td>₩' + formatNumber(order.AMOUNT || order.amount || 0) + '</td>';
                html += '</tr>';
            });
            
            $('#recentOrdersBody').html(html);
        },
        error: function(err) {
            console.error('최근 주문 로드 실패:', err);
        }
    });

    // ---------------------------
    // 3. 매출 흐름표 (라인 차트)
    // ---------------------------
    $.ajax({
        url: '/api/dashboard/daily-sales',
        method: 'GET',
        success: function(data) {
            console.log('매출 데이터:', data);
            
            var labels = data.map(item => item.LABEL || item.label);
            var sales = data.map(item => item.SALES || item.sales || 0);
            var expense = data.map(item => item.EXPENSE || item.expense || 0);
            
            var ctx = document.getElementById('salesChart').getContext('2d');
            
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: '매출',
                            data: sales,
                            borderColor: 'rgba(30, 80, 200, 1)',
                            borderWidth: 3,
                            pointRadius: 0,
                            tension: 0.35,
                            fill: false
                        },
                        {
                            label: '지출',
                            data: expense,
                            borderColor: 'rgba(230, 100, 120, 0.95)',
                            borderWidth: 2,
                            pointRadius: 0,
                            tension: 0.35,
                            fill: false
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: true, position: 'top' }
                    },
                    scales: {
                        x: { grid: { display: false } },
                        y: {
                            grid: { color: 'rgba(0,0,0,0.06)' },
                            ticks: {
                                callback: function(value) {
                                    return value.toLocaleString() + '원';
                                }
                            }
                        }
                    }
                }
            });
        },
        error: function(err) {
            console.error('매출 데이터 로드 실패:', err);
        }
    });

    // ---------------------------
    // 4. 수입/지출 (바 차트)
    // ---------------------------
    $.ajax({
        url: '/api/dashboard/income-expense',
        method: 'GET',
        success: function(data) {
            console.log('수입/지출 데이터:', data);
            
            var labels = data.map(item => item.LABEL || item.label);
            var income = data.map(item => item.INCOME || item.income || 0);
            var expense = data.map(item => item.EXPENSE || item.expense || 0);
            
            var ctx = document.getElementById('stockChart').getContext('2d');
            
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: '수입',
                            data: income,
                            backgroundColor: 'rgba(54, 162, 235, 0.85)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        },
                        {
                            label: '지출',
                            data: expense,
                            backgroundColor: 'rgba(255, 99, 132, 0.85)',
                            borderColor: 'rgba(255, 99, 132, 1)',
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'top' }
                    },
                    scales: {
                        x: { grid: { display: false } },
                        y: {
                            grid: { color: 'rgba(0,0,0,0.06)' },
                            ticks: {
                                callback: function(value) {
                                    return value.toLocaleString() + '원';
                                }
                            }
                        }
                    }
                }
            });
        },
        error: function(err) {
            console.error('수입/지출 데이터 로드 실패:', err);
        }
    });

});