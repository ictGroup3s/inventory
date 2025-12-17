/**
 * 
 */

$(function() {

	var currentOrderNo = null;

	// 숫자 포맷
	function formatNumber(num) {
		return num ? num.toLocaleString() : '0';
	}

	// 전화번호 포맷
	function formatPhone(phone) {
		if (!phone) return '-';
		var str = phone.toString();
		if (str.length === 11) {
			return str.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
		}
		return str;
	}

	// 주문 목록 로드
	function loadOrders(params) {
		$.ajax({
			url: '/api/admin/orders',
			method: 'GET',
			data: params || {},
			success: function(data) {
				console.log('주문 목록:', data);
				renderOrderTable(data);
			},
			error: function(err) {
				console.error('주문 목록 로드 실패:', err);
			}
		});
	}

	// 테이블 렌더링
	function renderOrderTable(orders) {
		var html = '';

		if (orders.length === 0) {
			html = '<tr><td colspan="7" class="text-center">주문 내역이 없습니다.</td></tr>';
		} else {
			orders.forEach(function(order) {
				var status = order.ORDER_STATUS || order.order_status || '-';
				var itemNames = order.ITEM_NAMES || order.item_names || '-';

				// 상품명 줄이기 (2개만 표시)
				var itemsArray = itemNames.split(', ');
				var displayItems = '';
				if (itemsArray.length <= 2) {
					displayItems = itemNames;
				} else {
					displayItems = itemsArray.slice(0, 2).join(', ') + ' 외 ' + (itemsArray.length - 2) + '건';
				}

				html += '<tr>';
				html += '<td>' + (order.ORDER_NO || order.order_no) + '</td>';
				html += '<td>' + (order.ORDER_NAME || order.order_name || '-') + '</td>';
				html += '<td class="item-cell text-left" title="' + itemNames + '">' + displayItems + '</td>';
				html += '<td>₩' + formatNumber(order.TOTAL_AMOUNT || order.total_amount) + '</td>';
				html += '<td class="order-date" title="' + (order.ORDER_DATE || order.order_date || '-') + '">' + (order.ORDER_DATE || order.order_date || '-') + '</td>';
				html += '<td style="width: 120px;"><div style="display: flex; justify-content: center; flex-direction: row; white-space: nowrap; "><span class="status-badge status-' + status + '">' + status + '</span></div></td>';
				html += '<td><button class="btn btn-sm btn-info btn-detail" data-order-no="' + (order.ORDER_NO || order.order_no) + '">상세</button></td>';
				html += '</tr>';
			});
		}

		$('#orderTableBody').html(html);
	}


	// 주문 상세 조회
	function loadOrderDetail(orderNo) {
		$.ajax({
			url: '/api/admin/orders/' + orderNo,
			method: 'GET',
			success: function(data) {
				console.log('주문 상세:', data);
				showOrderModal(data);
			},
			error: function(err) {
				console.error('주문 상세 로드 실패:', err);
				alert('주문 정보를 불러오는데 실패했습니다.');
			}
		});
	}

	// 모달에 데이터 표시
	function showOrderModal(data) {
		var order = data.order;
		var items = data.items;

		currentOrderNo = order.ORDER_NO || order.order_no;

		// 기본 정보
		$('#modalOrderNo').text(order.ORDER_NO || order.order_no);
		$('#modalOrderDate').text(order.ORDER_DATE || order.order_date);
		$('#modalPayment').text(order.PAYMENT || order.payment || '-');
		$('#modalCustomerId').text(order.CUSTOMER_ID || order.customer_id);
		$('#modalTotalAmount').text(formatNumber(order.TOTAL_AMOUNT || order.total_amount));

		// 배송 정보
		$('#modalOrderName').val(order.ORDER_NAME || order.order_name || '');
		$('#modalOrderPhone').val(formatPhone(order.ORDER_PHONE || order.order_phone));
		$('#modalOrderAddr').val(order.ORDER_ADDR || order.order_addr || '');

		// 상태 및 운송장
		var orderStatus = order.ORDER_STATUS || order.order_status || '결제완료';
		$('#modalStatus').val(orderStatus);
		$('#modalStatus').data('original', orderStatus);
		$('#modalTracking').val(order.TRACKING || order.tracking || '');

		// 주문 상품 목록
		var itemsHtml = '';
		items.forEach(function(item) {
			var price = item.ITEM_PRICE || item.item_price || 0;
			var cnt = item.ITEM_CNT || item.item_cnt || 0;
			var amount = item.AMOUNT || item.amount || (price * cnt);
			var detailNo = item.DETAIL_NO || item.detail_no;
			var detailStatus = item.DETAIL_STATUS || item.detail_status || '정상';
			var statusDate = item.STATUS_DATE || item.status_date || '';

			itemsHtml += '<tr data-detail-no="' + detailNo + '">';
			itemsHtml += '<td>' + (item.ITEM_NAME || item.item_name || '-') + '</td>';
			itemsHtml += '<td>' + cnt + '</td>';
			itemsHtml += '<td>₩' + formatNumber(price) + '</td>';
			itemsHtml += '<td>₩' + formatNumber(amount) + '</td>';
			itemsHtml += '<td class="detail-status-' + detailStatus + '">' + detailStatus;
			if (statusDate) {
				itemsHtml += '<br><small>(' + statusDate + ')</small>';
			}
			itemsHtml += '</td>';
			itemsHtml += '<td>';
			if (detailStatus === '정상') {
				itemsHtml += '<select class="form-control form-control-sm detail-status-select" data-detail-no="' + detailNo + '" data-item-no="' + (item.ITEM_NO || item.item_no) + '" data-item-cnt="' + cnt + '">';
				itemsHtml += '<option value="">변경</option>';
				itemsHtml += '<option value="취소">취소</option>';
				itemsHtml += '<option value="반품">반품</option>';
				itemsHtml += '<option value="교환">교환</option>';
				itemsHtml += '</select>';
			} else {
				itemsHtml += '<button class="btn btn-sm btn-outline-secondary btn-restore" data-detail-no="' + detailNo + '" data-item-no="' + (item.ITEM_NO || item.item_no) + '" data-item-cnt="' + cnt + '">복구</button>';
			}
			itemsHtml += '</td>';
			itemsHtml += '</tr>';
		});
		$('#modalOrderItems').html(itemsHtml);

		// 모달 열기
		$('#orderModal').modal('show');
	}

	// 저장 버튼
	$('#saveOrderBtn').on('click', function() {
		var status = $('#modalStatus').val();
		var tracking = $('#modalTracking').val();
		var orderName = $('#modalOrderName').val();
		var orderPhone = $('#modalOrderPhone').val().replace(/-/g, '');
		var orderAddr = $('#modalOrderAddr').val();
		var originalStatus = $('#modalStatus').data('original');

		// 취소로 변경하는 경우 확인
		if (status === '취소' && originalStatus !== '취소') {
			if (!confirm('주문을 취소하시겠습니까?\n취소 시 재고가 복구됩니다.')) {
				return;
			}
		}

		// 취소에서 다른 상태로 변경하는 경우 확인
		if (originalStatus === '취소' && status !== '취소') {
			if (!confirm('취소된 주문을 다시 활성화하시겠습니까?\n재고가 차감됩니다.')) {
				return;
			}
		}

		$.ajax({
			url: '/api/admin/orders/' + currentOrderNo,
			method: 'PUT',
			contentType: 'application/json',
			data: JSON.stringify({
				order_status: status,
				tracking: tracking,
				order_name: orderName,
				order_phone: orderPhone,
				order_addr: orderAddr,
				original_status: originalStatus
			}),
			success: function(res) {
				alert('저장되었습니다.');
				$('#orderModal').modal('hide');
				loadOrders();
			},
			error: function(err) {
				console.error('저장 실패:', err);
				alert('저장에 실패했습니다.');
			}
		});
	});
	// 상세보기 버튼 클릭
	$(document).on('click', '.btn-detail', function() {
		var orderNo = $(this).data('order-no');
		loadOrderDetail(orderNo);
	});

	// 검색
	$('#searchForm').on('submit', function(e) {
		e.preventDefault();
		var params = {
			orderNo: $('#searchOrderNo').val(),
			customerName: $('#searchCustomer').val(),
			status: $('#searchStatus').val(),
			startDate: $('#searchStartDate').val(),
			endDate: $('#searchEndDate').val()
		};
		console.log('검색 파라미터:', params);
		loadOrders(params);
	});

	// 초기화
	$('#resetBtn').on('click', function() {
		$('#searchOrderNo').val('');
		$('#searchCustomer').val('');
		$('#searchStatus').val('');
		$('#searchStartDate').val('');
		$('#searchEndDate').val('');
		loadOrders();
	});

	// 초기화
	$('#resetBtn').on('click', function() {
		$('#searchOrderNo').val('');
		$('#searchCustomer').val('');
		$('#searchStatus').val('');
		loadOrders();
	});

	// 초기 로드
	loadOrders();

	// 배송정보 수정 모드 토글
	var isEditingShipping = false;

	$('#editShippingBtn').on('click', function() {
		isEditingShipping = !isEditingShipping;

		if (isEditingShipping) {
			// 수정 모드 ON
			$('.shipping-input').prop('readonly', false);
			$('.shipping-input').css('background-color', '#fff');
			$(this).html('<i class="fas fa-times"></i> 취소');
			$(this).removeClass('btn-outline-secondary').addClass('btn-outline-danger');
		} else {
			// 수정 모드 OFF
			$('.shipping-input').prop('readonly', true);
			$('.shipping-input').css('background-color', '#e9ecef');
			$(this).html('<i class="fas fa-edit"></i> 수정');
			$(this).removeClass('btn-outline-danger').addClass('btn-outline-secondary');
		}
	});

	// 모달 닫힐 때 수정 모드 초기화
	$('#orderModal').on('hidden.bs.modal', function() {
		isEditingShipping = false;
		$('.shipping-input').prop('readonly', true);
		$('.shipping-input').css('background-color', '#e9ecef');
		$('#editShippingBtn').html('<i class="fas fa-edit"></i> 수정');
		$('#editShippingBtn').removeClass('btn-outline-danger').addClass('btn-outline-secondary');
	});

	// 상품별 상태 변경
	$(document).on('change', '.detail-status-select', function() {
		var newStatus = $(this).val();
		if (!newStatus) return;

		var detailNo = $(this).data('detail-no');
		var itemNo = $(this).data('item-no');
		var itemCnt = $(this).data('item-cnt');

		if (!confirm('해당 상품을 ' + newStatus + ' 처리하시겠습니까?\n재고가 복구됩니다.')) {
			$(this).val('');
			return;
		}

		$.ajax({
			url: '/api/admin/orders/detail/' + detailNo + '/status',
			method: 'PUT',
			contentType: 'application/json',
			data: JSON.stringify({
				detail_status: newStatus,
				item_no: itemNo,
				item_cnt: itemCnt
			}),
			success: function(res) {
				if (res.success) {
					console.log('응답: ', res);
					alert(newStatus + ' 처리되었습니다.');
					loadOrderDetail(currentOrderNo);
					loadOrders();
				} else {
					alert(res.message || '처리에 실패했습니다.');
				}
			},
			error: function(err) {
				console.error('상태 변경 실패:', err);
				console.error('응답 내용:', err.responseText);
				alert('처리에 실패했습니다.');
			}
		});
	});

	// 상품 복구
	$(document).on('click', '.btn-restore', function() {
		var detailNo = $(this).data('detail-no');
		var itemNo = $(this).data('item-no');
		var itemCnt = $(this).data('item-cnt');

		if (!confirm('해당 상품을 정상으로 복구하시겠습니까?\n재고가 차감됩니다.')) {
			return;
		}

		$.ajax({
			url: '/api/admin/orders/detail/' + detailNo + '/restore',
			method: 'PUT',
			contentType: 'application/json',
			data: JSON.stringify({
				item_no: itemNo,
				item_cnt: itemCnt
			}),
			success: function(res) {
				console.log('응답:', res);
				alert('복구되었습니다.');
				loadOrderDetail(currentOrderNo);
				loadOrders();
			},
			error: function(err) {
				console.error('복구 실패:', err);
				console.error('응답 내용:', err.responseText);
				alert('복구에 실패했습니다.');
			}
		});
	});

});
