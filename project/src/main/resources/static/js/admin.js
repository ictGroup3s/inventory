/**
 * 
 */
$(function() {
	//등록 눌렸을때
	$('#uploadFile').on('change', function(event) {
		const file = event.target.files[0];
		const $preview = $('#preview');

		if (file) {
			const reader = new FileReader();
			reader.onload = function(e) {
				$preview.attr('src', e.target.result);
			};
			reader.readAsDataURL(file);
		} else {
			$preview.attr('src', 'img/insert_pic.png');
		}
	});

	//상품목록 클릭 했을때
	$('.item-row').on('click', function() {
		const $this = $(this);
		$('input[name="item_no"]').val($this.data('item_no'));
		$('input[name="item_name"]').val($this.data('item_name'));
		$('textarea[name="item_content"]').val($this.data('item_content'));
		$('input[name="origin_p"]').val($this.data('origin_p'));
		$('input[name="sales_p"]').val($this.data('sales_p'));
		$('input[name="stock_cnt"]').val($this.data('stock_cnt'));
		$('select[name="cate_no"]').val($this.data('cate_no'));
		let imgPath = $this.data('item_img');
		if (imgPath) {
			$('#preview').attr('src', '/img/product/' + imgPath);
		} else {
			$('#preview').attr('src', 'img/insert_pic.png'); // 기본 이미지
		}
	});

	//삭제버튼
	$('.delete-btn').click(function() {
		let itemNo = $(this).data('itemno'); // data-itemno와 맞춤
		let row = $(this).closest('tr');

		console.log(itemNo); // 숫자가 제대로 찍히는지 확인

		$.ajax({
			url: '/deleteItem',
			type: 'POST',
			data: { itemNo: itemNo },
			success: function(response) {
				if (response === "success") {
					row.remove();
					showToast("정말로 삭제하시겠습니까?")
				} else {
					showToast('삭제 실패');
				}
			},
			error: function() {
				showToast('삭제 실패');
			}
		});
	});
	
	// 상세보기 버튼 클릭
	$(".detail-btn").click(function() {
		var url = $(this).data("url");
		$("#modalFrame").attr("src", url);
		$("#overlay, #customModal").fadeIn(200);
	});

	// 닫기 버튼 혹은 오버레이 클릭
	$("#closeModal, #overlay").click(function() {
		$("#overlay, #customModal").fadeOut(200);
		$("#modalFrame").attr("src", ""); // iframe 초기화
	});
});