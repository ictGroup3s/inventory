(function($) {
	//sidebar
	$("#sidebarMenu").html($("#mainSidebar").html());

	"use strict";

	$(document).ready(function() {
		$('.bxslider').bxSlider({
			auto: false,
			touchEnabled: false,
			moveSlides: 1,
			pager: false,
			controls: true,
			pause: 2000,
			speed: 100,
			infiniteLoop: true,
			onSliderLoad: function(currentIndex){
				try{ $('.bxslider').trigger('bxslider:loaded'); }catch(e){}
			},
			minSlides: 2,      // 최소 보여줄 슬라이드
			maxSlides: 4,      // 최대 보여줄 슬라이드
			slideWidth: 250,   // 슬라이드 개별 너비
			slideMargin: 10    // 슬라이드 간격
		});

		// 상단으로 이동 버튼
		$(window).scroll(function() {
			if ($(this).scrollTop() > 100) {
				$('.back-to-top').fadeIn('slow');
			} else {
				$('.back-to-top').fadeOut('slow');
			}
		});
		$('.back-to-top').click(function() {
			$('html, body').animate({ scrollTop: 0 }, 1500, 'easeInOutExpo');
			return false;
		});


		// Vendor carousel
		$('.vendor-carousel').owlCarousel({
			loop: true,
			margin: 29,
			nav: false,
			autoplay: true,
			smartSpeed: 1000,
			responsive: {
				0: {
					items: 2
				},
				576: {
					items: 3
				},
				768: {
					items: 4
				},
				992: {
					items: 5
				},
				1200: {
					items: 6
				}
			}
		});


		// Related carousel
		$('.related-carousel').owlCarousel({
			loop: true,
			margin: 29,
			nav: false,
			autoplay: true,
			smartSpeed: 1000,
			responsive: {
				0: {
					items: 1
				},
				576: {
					items: 2
				},
				768: {
					items: 3
				},
				992: {
					items: 4
				}
			}
		});


		// Product Quantity
		$('.quantity button').on('click', function() {
			var button = $(this);
			var oldValue = button.parent().parent().find('input').val();
			if (button.hasClass('btn-plus')) {
				var newVal = parseFloat(oldValue) + 1;
			} else {
				if (oldValue > 0) {
					var newVal = parseFloat(oldValue) - 1;
				} else {
					newVal = 0;
				}
			}
			button.parent().parent().find('input').val(newVal);
		});
		//sidebar 클릭
		const currentPath = window.location.pathname.split('/').pop();

		$('.category-sidebar .nav-link').removeClass('active')
			.each(function() {
				const $el = $(this);
				if ($el.attr('href') === currentPath) {
					$el.addClass('active');
				}
			});

	})


	// 서버에 장바구니 수량을 요청하여 배지 업데이트
	function updateCartBadge() {
		$.get('/cart/count', function(res) {
			try {
				var count = (res && res.cartCount) ? res.cartCount : 0;
				// 모든 장바구니 아이콘의 부모를 찾아 그 자식 .badge를 업데이트합니다
				$('.fa-shopping-cart').each(function() {
					var $icon = $(this);
					var $a = $icon.closest('a');
					if ($a.length) {
						var $badge = $a.find('.badge');
						if ($badge.length) {
							$badge.text(count);
						}
					}
				});
			} catch (e) { console.error('updateCartBadge error', e); }
		}, 'json').fail(function() { console.warn('Failed to fetch /cart/count'); });
	}

	// 페이지 로드 시 초기 배지 업데이트
	try { updateCartBadge(); } catch (e) {/*ignore*/ }

	// 간단한 토스트 알림 헬퍼 (비차단)
	function createToast(message, timeout) {
		try {
			var t = timeout || 2500;
			var $toast = $('<div class="copilot-toast" />').text(message).css({
				position: 'fixed',
				right: '20px',
				top: '20px',
				background: 'rgba(0,0,0,0.8)',
				color: '#fff',
				padding: '10px 14px',
				'border-radius': '4px',
				'z-index': 2147483647,
				'box-shadow': '0 2px 8px rgba(0,0,0,0.2)'
			});
			$('body').append($toast);
			$toast.hide().fadeIn(150);
			setTimeout(function() { $toast.fadeOut(300, function() { $toast.remove(); }); }, t);
		} catch (e) { console.warn('createToast failed', e); }
	}

	// 상품명과 '장바구니 보기' 버튼을 포함한 풍부한 장바구니 토스트
	function showAddToast(productName, count, imageUrl) {
		try {
			var t = 3500;
			var $toast = $('<div class="copilot-toast add-toast" />').css({
				position: 'fixed',
				right: '20px',
				top: '20px',
				background: '#fff',
				color: '#333',
				padding: '10px 14px',
				'border-radius': '6px',
				'z-index': 2147483647,
				'box-shadow': '0 2px 16px rgba(0,0,0,0.12)',
				'max-width': '320px'
			});
			var imgHtml = '';
			if (imageUrl) imgHtml = '<img src="' + imageUrl + '" style="width:48px;height:48px;object-fit:cover;margin-right:8px;float:left;border-radius:4px;"/>';
			var title = productName ? ('<strong style="display:block;margin-bottom:6px;">' + productName + '</strong>') : '';
			var body = '<div style="overflow:hidden;">' + imgHtml + '<div style="margin-left:56px;">' + title + '장바구니에 담겼습니다. 총 <strong>' + (count || 0) + '</strong>개</div></div>';
			var actions = '<div style="margin-top:8px;text-align:right;"><a href="/cart" class="btn btn-sm btn-primary" style="color:#fff;text-decoration:none;padding:6px 10px;border-radius:4px;">장바구니 보기</a></div>';
			$toast.html(body + actions);
			$('body').append($toast);
			$toast.hide().fadeIn(150);
			setTimeout(function() { $toast.fadeOut(300, function() { $toast.remove(); }); }, t);
		} catch (e) { console.warn('showAddToast failed', e); }
	}


	// 장바구니 추가 폼 제출을 가로채서 AJAX로 추가하고 배지 업데이트를 수행합니다
	$(document).on('submit', 'form[action="/cart/addForm"]', function(e) {
		e.preventDefault();
		var $form = $(this);
		var itemNo = $form.find('input[name="item_no"]').val();
		var qty = $form.find('input[name="qty"]').val() || 1;
		if (!itemNo) { createToast('item_no가 필요합니다.'); return; }
		$.post('/cart/add', { item_no: itemNo, qty: qty }, function(res) {
			if (res && res.success) {
				// 배지를 업데이트하고 간단한 피드백을 표시합니다
				updateCartBadge();
				// 토스트에 표시할 상품명을 DOM에서 찾습니다
				var productName = null;
				try {
					var $card = $form.closest('.product-item');
					if ($card && $card.length) productName = $card.find('.text-truncate').first().text().trim();
				} catch (e) { }
				showAddToast(productName, res.cartCount);
			} else {
				createToast('장바구니에 추가하지 못했습니다.');
			}
		}, 'json').fail(function() {
			createToast('네트워크 오류.');
		});
	});

	// `.add-to-cart-btn` 직접 클릭도 지원합니다
	$(document).on('click', '.add-to-cart-btn', function(e) {
		var $btn = $(this);
		e.preventDefault();
		// data 속성을 우선 사용하고, 없으면 주변 폼 입력값을 사용합니다
		var itemNo = $btn.data('item-no') || $btn.attr('data-item-no');
		var qty = $btn.data('qty') || 1;
		var $form = $btn.closest('form[action="/cart/addForm"]');
		if ((!itemNo || itemNo === '') && $form.length) {
			itemNo = $form.find('input[name="item_no"]').val();
			qty = $form.find('input[name="qty"]').val() || qty;
		}
		if (!itemNo) { createToast('item_no가 필요합니다.'); return; }
		// 더 나은 토스트를 위해 DOM에서 상품명을 찾으려고 시도합니다
		var productName = null;
		try {
			var $card = $btn.closest('.product-item');
			if ($card && $card.length) {
				productName = $card.find('.text-truncate').first().text().trim();
			}
		} catch (e) { /* ignore */ }
		$.post('/cart/add', { item_no: itemNo, qty: qty }, function(res) {
			if (res && res.success) {
				updateCartBadge();
				showAddToast(productName, res.cartCount);
			} else {
				createToast('장바구니에 추가하지 못했습니다.');
			}
		}, 'json').fail(function(jqxhr, status, err) {
			console.error('/cart/add failed (click)', status, err, jqxhr && jqxhr.responseText);
			createToast('네트워크 오류.');
		});
	});


	// 장바구니 추가 헬퍼 (버튼에서 호출: addToCart(itemNo, qty))
	function addToCart(itemNo, qty) {
		if (!itemNo) {
			console.warn('addToCart missing itemNo');
			createToast('item_no가 필요합니다.');
			return;
		}
		// data-item-no 속성이 있는 요소에서 상품명을 시도하여 찾습니다
		var productName = null;
		try {
			var $el = $('[data-item-no="' + itemNo + '"]').first();
			if ($el && $el.length) {
				var $card = $el.closest('.product-item');
				if ($card && $card.length) productName = $card.find('.text-truncate').first().text().trim();
			}
		} catch (e) { }
		$.post('/cart/add', { item_no: itemNo, qty: qty || 1 }, function(res) {
			if (res && res.success) {
				// 페이지 이동 대신 배지 업데이트 및 상품 토스트를 표시합니다
				updateCartBadge();
				showAddToast(productName, res.cartCount);
			} else {
				createToast('장바구니에 추가하지 못했습니다.');
			}
		}, 'json').fail(function(jqxhr, status, err) {
			console.error('/cart/add failed', status, err, jqxhr.responseText);
			createToast('네트워크 오류가 발생했습니다. 콘솔을 확인하세요.');
		});
	}
	window.addToCart = addToCart;

	// 데이터 기반 장바구니 버튼들을 위한 위임 클릭 핸들러
	$(document).on('click', '.add-to-cart', function(e) {
		e.preventDefault();
		var $btn = $(this);
		var itemNo = $btn.data('item-no');
		addToCart(itemNo);
	});

	const fields = $(".required-field");

	// 필드 검증 함수
	function validateFields() {
		let allValid = true;

		fields.each(function() {
			const el = $(this);
			const msg = el.closest("td").find(".error-msg");

			if (el.val().trim() === "") {
				el.addClass("input-error");
				msg.removeClass("d-none");
				allValid = false;
			} else {
				el.removeClass("input-error");
				msg.addClass("d-none");
			}
		});

		return allValid;
	}

	// 입력 또는 select 변경 시 바로 검증
	fields.on("input change", function() {
		validateFields();
	});

	// 버튼 클릭 시 최종 검증
	$(".submit-btn").on("click", function(e) {
		if (!validateFields()) {
			e.preventDefault(); // submit 막기
			return;
		}

		// 정상 submit → formaction 적용
		const form = $(this).closest("form");
		form.attr("action", $(this).attr("formaction") || form.attr("action"));
		form.submit();
	});

})(jQuery);
