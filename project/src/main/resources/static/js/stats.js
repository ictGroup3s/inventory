// stats.js (최신 통합 버전)
$(function() {

	// ---------------------------
	// Chart.js DataLabels 플러그인 등록
	// ---------------------------
	if (window.Chart && window.ChartDataLabels) {
		Chart.register(ChartDataLabels);
	}

	// ---------------------------
	// 카드 높이 자동 조정
	// ---------------------------
	$('.card.h-100').each(function() {
		const $card = $(this);
		if ($card.find('.chart-box').length) {
			$card.removeClass('h-100').css('height', 'auto');
		}
	});

	// ---------------------------
	// 디버그용: 차트 및 부모 컨테이너 크기 로그
	// ---------------------------
	const logSizes = (name, $canvas) => {
		if (!$canvas.length) return;
		const parent = $canvas.parent();
		console.log('[chart-size]', name,
			'parent', parent.width() + 'x' + parent.height(),
			'canvas(css)', $canvas.width() + 'x' + $canvas.height(),
			'canvas(pixels)', $canvas[0].width + 'x' + $canvas[0].height
		);
	};

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
			logSizes(name, $canvas);

			const $status = $('#status-' + canvasId);
			if ($status.length) $status.text('초기화 성공').css('color', 'green');
			return chart;
		} catch (err) {
			console.error('차트 생성 실패:', canvasId, err);
			const $status = $('#status-' + canvasId);
			if ($status.length) $status.text('차트 초기화 실패: ' + (err.message || err)).css('color', 'darkred');
			return null;
		}
	};

	// ---------------------------
	// 하단 두 차트 높이 동기화
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

		['stockChart', 'visitorsChart'].forEach(id => {
			const $c = $('#' + id);
			if ($c.length && $c[0]._chartInstance) {
				try { $c[0]._chartInstance.resize(); } catch (e) { console.warn('차트 리사이즈 실패', e); }
				logSizes(id, $c);
			}
		});
	};

	// ---------------------------
	// 하단 카드 높이 동기화
	// ---------------------------
	const equalizeBottomCardHeights = () => {
		const $stockCard = $('#stockChartWrap').closest('.card');
		const $visitorsCard = $('#visitorsChartWrap').closest('.card');
		if (!$stockCard.length || !$visitorsCard.length) return;

		$stockCard.css('height', '');
		$visitorsCard.css('height', '');
		const target = Math.max($stockCard.outerHeight(), $visitorsCard.outerHeight());
		$stockCard.height(target);
		$visitorsCard.height(target);
	};

	// ---------------------------
	// 차트 리사이즈 예약 (디바운스)
	// ---------------------------
	let _chartResizeTimer = null;
	const scheduleChartResize = () => {
		clearTimeout(_chartResizeTimer);
		_chartResizeTimer = setTimeout(() => {
			equalizeBottomCharts();
			equalizeBottomCardHeights();
			['salesChart', 'stockChart', 'visitorsChart', 'categoryChart'].forEach(id => {
				const $c = $('#' + id);
				if ($c.length && $c[0]._chartInstance) {
					try { $c[0]._chartInstance.resize(); } catch (e) { console.warn('차트 리사이즈 실패', e); }
					logSizes(id, $c);
				}
			});
		}, 150);
	};
	$(window).on('resize', scheduleChartResize);

	// ---------------------------
	// 샘플 데이터
	// ---------------------------
	const sampleSalesData = [1820, 1750, 1630, 1660, 2080, 2350, 2630];
	const sampleExpenseData = [710, 640, 690, 720, 790, 880, 940];

	const sampleStockData = {
		labels: ['1월', '2월', '3월', '4월', '5월', '6월'],
		income: [1200, 1500, 1400, 1700, 1600, 1800],
		expense: [800, 900, 850, 950, 900, 1000]
	};

	const sampleVisitorsData = {
		labels: ['월1', '월2', '월3', '월4', '월5', '월6'],
		visitors: [3200, 3500, 3000, 3600, 3800, 4000],
		orders: [220, 250, 200, 260, 280, 300]
	};

	const sampleCategoryData = [
		{ category: '분류1', sales: 5200 },
		{ category: '분류2', sales: 3400 },
		{ category: '분류3', sales: 2800 },
		{ category: '분류4', sales: 1900 },
		{ category: '기타', sales: 700 }
	];

	const categoryColors = ['rgba(54,162,235,0.9)', 'rgba(255,99,132,0.9)', 'rgba(255,205,86,0.9)', 'rgba(75,192,192,0.9)', 'rgba(153,102,255,0.9)'];

	// ---------------------------
	// 차트 생성
	// ---------------------------
	createChart('salesChart', {
		type: 'line',
		data: {
			labels: ['5월', '6월', '7월', '8월', '9월', '10월', '11월'],
			datasets: [
				{
					label: '매출 총액',
					data: sampleSalesData,
					borderColor: 'rgba(30,80,200,1)',
					borderWidth: 3,
					pointRadius: 0,
					tension: 0.35,
					fill: false,
					cubicInterpolationMode: 'monotone'
				},
				{
					label: '지출 총액',
					data: sampleExpenseData,
					borderColor: 'rgba(230,100,120,0.95)',
					borderWidth: 2,
					pointRadius: 0,
					tension: 0.35,
					fill: false,
					cubicInterpolationMode: 'monotone'
				}
			]
		},
		options: {
			responsive: true,
			maintainAspectRatio: true,
			aspectRatio: 1.6,
			plugins: { legend: { display: false }, tooltip: { mode: 'index', intersect: false }, datalabels: { display: false } },
			scales: {
				x: { grid: { display: false }, ticks: { color: '#666', padding: 6 } },
				y: { grid: { color: 'rgba(0,0,0,0.06)', drawBorder: false }, ticks: { color: '#666' } }
			}
		}
	}, '매출 차트');

	createChart('stockChart', {
		type: 'bar',
		data: {
			labels: sampleStockData.labels,
			datasets: [
				{ label: '수입', data: sampleStockData.income, backgroundColor: 'rgba(54,162,235,0.7)' },
				{ label: '지출', data: sampleStockData.expense, backgroundColor: 'rgba(255,99,132,0.7)' }
			]
		},
		options: { responsive: true, plugins: { legend: { position: 'top' }, tooltip: { mode: 'index', intersect: false } }, scales: { x: { stacked: false }, y: { stacked: false, beginAtZero: true } } }
	}, '수입/지출 차트');

	createChart('visitorsChart', {
		type: 'line',
		data: {
			labels: sampleVisitorsData.labels,
			datasets: [
				{ label: '방문자수', data: sampleVisitorsData.visitors, borderColor: 'rgba(75,192,192,1)', backgroundColor: 'rgba(75,192,192,0.2)', fill: true, tension: 0.3 },
				{ label: '주문건수', data: sampleVisitorsData.orders, borderColor: 'rgba(255,159,64,1)', backgroundColor: 'rgba(255,159,64,0.2)', fill: true, tension: 0.3 }
			]
		},
		options: { responsive: true, plugins: { legend: { position: 'top' }, tooltip: { mode: 'index', intersect: false } }, scales: { x: { ticks: { color: '#666' } }, y: { ticks: { color: '#666', beginAtZero: true } } } }
	}, '방문자수/주문건수 차트');

	createChart('categoryChart', {
		type: 'doughnut',
		data: {
			labels: sampleCategoryData.map(d => d.category),
			datasets: [{
				data: sampleCategoryData.map(d => d.sales),
				backgroundColor: categoryColors.slice(0, sampleCategoryData.length)
			}]
		},
		options: { responsive: true, plugins: { legend: { position: 'right' }, tooltip: { mode: 'index', intersect: false } } }
	}, '카테고리별 매출');

	// ---------------------------
	// 초기 하단 카드 높이 동기화
	// ---------------------------
	setTimeout(() => {
		scheduleChartResize();
		equalizeBottomCharts();
		equalizeBottomCardHeights();
	}, 500);

});
