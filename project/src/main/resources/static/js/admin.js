/**
 *  admin.js
 */
$(function() {
    
    // ===== 재고 관리 변수 =====
    var currentStock = 0;

    // 등록 - 파일 업로드 시 미리보기
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

    // 페이지 로드 시 초기 상태 (둘 다 비활성화)
    $('.submit-btn.register').prop('disabled', true);
    $('.submit-btn.update').prop('disabled', true);

    // 폼 직접 입력 감지 (등록 모드)
    $('input[name="item_name"], input[name="origin_p"], input[name="sales_p"], input[name="stock_cnt"], select[name="cate_no"], textarea[name="item_content"], input[name="dis_rate"], #uploadFile').on('input change', function() {
        if (!$('input[name="item_no"]').val()) {
            $('.submit-btn.register').prop('disabled', false);
            $('.submit-btn.update').prop('disabled', true);
        }
    });

    // ===== 상품 목록 클릭 (통합) =====
    $('.item-row').on('click', function() {
        const $this = $(this);

        // 기본 필드 채우기
        $('input[name="item_no"]').val($this.data('item_no'));
        $('#item_no').val($this.data('item_no'));
        $('input[name="item_name"]').val($this.data('item_name'));
        $('#item_name').val($this.data('item_name'));
        $('textarea[name="item_content"]').val($this.data('item_content'));
        $('input[name="origin_p"]').val($this.data('origin_p'));
        $('#origin_p').val($this.data('origin_p'));
        $('input[name="sales_p"]').val($this.data('sales_p'));
        $('#sales_p').val($this.data('sales_p'));
        $('input[name="stock_cnt"]').val($this.data('stock_cnt'));
        $('select[name="cate_no"]').val($this.data('cate_no'));
        $('input[name="dis_rate"]').val($this.data('dis_rate'));

        // 재고 관련 (stock.jsp용)
        currentStock = parseInt($this.data('stock_cnt')) || 0;
        $('#current_stock').val(currentStock);
        $('#adjust_qty').val(0);
        $('#new_stock').val(currentStock);
        $('#adjustLabel').text('');
        $('#stockSubmitBtn').prop('disabled', true);

        // 재고 부족 경고 표시/숨김
        if (currentStock < 10) {
            $('#stockWarning').css('display', 'flex');
        } else {
            $('#stockWarning').css('display', 'none');
        }

        // 이미지
        let imgPath = $this.data('item_img');
        if (imgPath) {
            $('#preview').attr('src', '/img/product/' + imgPath);
        } else {
            $('#preview').attr('src', 'img/insert_pic.png');
        }

        // hidden input에 기존 이미지명 저장
        $('input[name="existingItemImg"]').val(imgPath || "");

        // 수정 모드: 이미지 필수 체크 해제
        $('#uploadFile').removeClass('required-field');
        $('#uploadFile').siblings('.error-msg').addClass('d-none');

        // 수정 모드: 수정 버튼 활성화, 등록 버튼 비활성화
        $('.submit-btn.update').prop('disabled', false);
        $('.submit-btn.register').prop('disabled', true);
    });

    // 비활성화된 등록 버튼 클릭 시
    $('.submit-btn.register').on('click', function(e) {
        if ($(this).prop('disabled')) {
            e.preventDefault();
            showToast('수정 모드입니다. 새 상품을 등록하려면 페이지를 새로고침 해주세요.');
            return false;
        }
    });

    // 비활성화된 수정 버튼 클릭 시
    $('.submit-btn.update').on('click', function(e) {
        if ($(this).prop('disabled')) {
            e.preventDefault();
            showToast('등록 모드입니다. 수정하려면 아래 목록에서 상품을 선택해주세요.');
            return false;
        }
    });

    // 삭제버튼
    $('.delete-btn').click(function() {
        let itemNo = $(this).data('itemno');
        let row = $(this).closest('tr');

        $.ajax({
            url: '/deleteItem',
            type: 'POST',
            data: { itemNo: itemNo },
            success: function(response) {
                if (response === "success") {
                    row.remove();
                    showToast("정말로 삭제하시겠습니까?");
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
        $("#modalFrame").attr("src", "");
    });

    // ===== 상품 필터링 =====
    function filterItems() {
        var searchText = $('#itemSearch').val().toLowerCase();
        var selectedCate = $('#categoryFilter').val();

        $('.item-row').each(function() {
            var itemName = $(this).data('item_name').toString().toLowerCase();
            var itemCate = $(this).data('cate_no').toString();

            var matchSearch = (searchText === '' || itemName.includes(searchText));
            var matchCate = (selectedCate === '' || itemCate === selectedCate);

            if (matchSearch && matchCate) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
    }

    $('#itemSearch').on('keyup', function() {
        filterItems();
    });

    $('#categoryFilter').change(function() {
        filterItems();
    });

    // ===== 재고 수량 조정 =====
    function updateNewStock() {
        var adjustQty = parseInt($('#adjust_qty').val()) || 0;
        var newStock = currentStock + adjustQty;

        // 음수 재고 방지
        if (newStock < 0) {
            newStock = 0;
            adjustQty = -currentStock;
            $('#adjust_qty').val(adjustQty);
        }

        $('#new_stock').val(newStock);

        // 라벨 표시
        if (adjustQty > 0) {
            $('#adjustLabel').text('입고 +' + adjustQty + '개').css('color', 'green');
            $('#stockSubmitBtn').prop('disabled', false);
        } else if (adjustQty < 0) {
            $('#adjustLabel').text('출고 ' + adjustQty + '개').css('color', 'red');
            $('#stockSubmitBtn').prop('disabled', false);
        } else {
            $('#adjustLabel').text('');
            $('#stockSubmitBtn').prop('disabled', true);
        }
    }

    // + 버튼
    $('#plusBtn').click(function() {
        var qty = parseInt($('#adjust_qty').val()) || 0;
        $('#adjust_qty').val(qty + 1);
        updateNewStock();
    });

    // - 버튼
    $('#minusBtn').click(function() {
        var qty = parseInt($('#adjust_qty').val()) || 0;
        $('#adjust_qty').val(qty - 1);
        updateNewStock();
    });

    // 직접 입력 시
    $('#adjust_qty').on('input', function() {
        updateNewStock();
    });

    // 초기화 버튼
    $('#resetBtn').click(function() {
        $('#adjust_qty').val(0);
        $('#new_stock').val(currentStock);
        $('#adjustLabel').text('');
        $('#stockSubmitBtn').prop('disabled', true);
    });

    // ===== 폼 제출 전 검증 =====
    $('form').on('submit', function(e) {
        let isValid = true;
        const isUpdateMode = $('input[name="item_no"]').val() !== '';

        $('.required-field').each(function() {
            const $field = $(this);
            const $errorMsg = $field.siblings('.error-msg');

            // 수정 모드일 때 이미지 필드는 검증 건너뛰기
            if (isUpdateMode && $field.attr('name') === 'item_imgFile') {
                $errorMsg.addClass('d-none');
                return true;
            }

            if ($field.val() === '' || $field.val() === null) {
                $errorMsg.removeClass('d-none');
                isValid = false;
            } else {
                $errorMsg.addClass('d-none');
            }
        });

        if (!isValid) {
            e.preventDefault();
        }
    });
	// ===== 페이지 로드 시 초기화 =====
	    $('#stockWarning').hide();

	

});