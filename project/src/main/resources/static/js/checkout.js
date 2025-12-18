/*************************************************
 * DOM 요소
 *************************************************/
const nameInput = document.getElementById('Name');
const phoneInput = document.getElementById('Phone');
const addressInput = document.getElementById('Address');

const shipNameInput = document.getElementById('shipName');
const shipPhoneInput = document.getElementById('shipPhone');
const shipAddressInput = document.getElementById('shipAddress');

const shipToCheckbox = document.getElementById('shipto');        // 수령지주소입력
const sameAsAboveCheckbox = document.getElementById('newaccount'); // 위 내용과 동일
const shippingSection = document.getElementById('shipping-address');
const checkoutForm = document.getElementById('checkoutForm');

/*************************************************
 * 수령지 주소 열기 / 닫기
 *************************************************/
shipToCheckbox.addEventListener('change', function () {
    if (this.checked) {
        $(shippingSection).collapse('show');
    } else {
        $(shippingSection).collapse('hide');
    }
});

/*************************************************
 * "위 내용과 동일" 체크
 *************************************************/
sameAsAboveCheckbox.addEventListener('change', function () {
    if (this.checked) {
        // ⭐ 수령지주소입력 체크박스도 자동으로 체크
        shipToCheckbox.checked = true;
        $(shippingSection).collapse('show');
        
        // 주문자 정보 → 수령지 정보로 복사
        shipNameInput.value = nameInput.value;
        shipPhoneInput.value = phoneInput.value;
        shipAddressInput.value = addressInput.value;

        shipNameInput.readOnly = true;
        shipPhoneInput.readOnly = true;
        shipAddressInput.readOnly = true;
    } else {
        shipNameInput.readOnly = false;
        shipPhoneInput.readOnly = false;
        shipAddressInput.readOnly = false;
    }
});

/*************************************************
 * 주문자 정보 변경 시 자동 동기화
 *************************************************/
function syncShipping() {
    if (sameAsAboveCheckbox.checked) {
        shipNameInput.value = nameInput.value;
        shipPhoneInput.value = phoneInput.value;
        shipAddressInput.value = addressInput.value;
    }
}

nameInput.addEventListener('input', syncShipping);
phoneInput.addEventListener('input', syncShipping);
addressInput.addEventListener('input', syncShipping);

/*************************************************
 * ⭐ 최종 방어 (가장 중요)
 * 수령지 입력 안 했으면 → 주문자 주소로 저장
 *************************************************/
/*************************************************
 * ⭐ 최종 방어 - 수령지 정보 필수!
 *************************************************/
if (checkoutForm) {
    checkoutForm.addEventListener('submit', function (e) {
        // ⭐⭐⭐ 수령지 정보 필수 체크
        const shipName = document.getElementById('shipName').value.trim();
        const shipPhone = document.getElementById('shipPhone').value.trim();
        const shipAddress = document.getElementById('shipAddress').value.trim();

        if (!shipName || !shipPhone || !shipAddress) {
            e.preventDefault();
            alert('수령지 주소를 입력해주세요!\n(수령지주소입력 체크박스를 클릭하여 입력하세요)');
            
            // 수령지 섹션 열기
            document.getElementById('shipto').checked = true;
            $('#shipping-address').collapse('show');
            
            return false;
        }

        // 메모 처리
        const memoSelect = document.getElementById('memoSelect');
        const memoInput = document.getElementById('memoInput');
        let finalMemo = '';
        
        if (memoSelect.value === 'direct') {
            finalMemo = memoInput.value;
        } else if (memoSelect.value !== '요청사항') {
            finalMemo = memoSelect.value;
        }
        
        // hidden input으로 최종 메모 전달
        const existingMemo = document.querySelector('input[name="finalMemo"]');
        if (existingMemo) {
            existingMemo.value = finalMemo;
        } else {
            const hiddenMemo = document.createElement('input');
            hiddenMemo.type = 'hidden';
            hiddenMemo.name = 'finalMemo';
            hiddenMemo.value = finalMemo;
            this.appendChild(hiddenMemo);
        }
    });
}

/*************************************************
 * ⭐ 결제 관련 코드 ⭐
 *************************************************/
let selectedCard = '';

// 결제하기 버튼 클릭
const btnOpenModal = document.getElementById('btnOpenModal');
if (btnOpenModal) {
    btnOpenModal.addEventListener('click', function() {
        // 필수 입력 검증
        if (!nameInput.value || !phoneInput.value || !addressInput.value) {
            alert('주소 정보를 모두 입력해주세요.');
            return;
        }

        // 결제 방식 선택 확인
        const paymentMethod = document.querySelector('input[name="payment"]:checked');
        if (!paymentMethod) {
            alert('결제 방식을 선택해주세요.');
            return;
        }

        // 모달 열기
        $('#payModal').modal('show');
    });
}

// 카드사 선택
function selectCard(cardName) {
    selectedCard = cardName;
    document.getElementById('selectedCardDisplay').textContent = `선택된 카드: ${cardName}`;
    
    // 모든 버튼 비활성화 후 선택된 버튼만 활성화
    document.querySelectorAll('.card-btn').forEach(btn => {
        btn.classList.remove('btn-primary');
        btn.classList.add('btn-outline-primary');
    });
    event.target.classList.remove('btn-outline-primary');
    event.target.classList.add('btn-primary');
}

// 결제 진행
function processPayment() {
    if (!selectedCard) {
        alert('카드사를 선택해주세요.');
        return;
    }

    // 폼 제출
    document.getElementById('checkoutForm').submit();
}

// 계좌이체 선택 시 계좌 정보 표시
const directcheck = document.getElementById('directcheck');
const bankInfo = document.getElementById('bankInfo');
if (directcheck) {
    directcheck.addEventListener('change', function() {
        if (this.checked) {
            bankInfo.style.display = 'block';
        } else {
            bankInfo.style.display = 'none';
        }
    });
}

// 네이버페이 버튼
const naverPayBtn = document.getElementById('naverPayBtn');
if (naverPayBtn) {
    naverPayBtn.addEventListener('click', function() {
        if (!nameInput.value || !phoneInput.value || !addressInput.value) {
            alert('주소 정보를 모두 입력해주세요.');
            return;
        }
        alert('네이버페이 결제는 준비중입니다.');
    });
}

// 카카오페이 버튼
const kakaoPayBtn = document.getElementById('kakaoPayBtn');
if (kakaoPayBtn) {
    kakaoPayBtn.addEventListener('click', function() {
        if (!nameInput.value || !phoneInput.value || !addressInput.value) {
            alert('주소 정보를 모두 입력해주세요.');
            return;
        }
        alert('카카오페이 결제는 준비중입니다.');
    });
}

// 메모 선택 (직접입력)
const memoSelect = document.getElementById('memoSelect');
const memoInput = document.getElementById('memoInput');
if (memoSelect) {
    memoSelect.addEventListener('change', function() {
        if (this.value === 'direct') {
            memoInput.style.display = 'block';
        } else {
            memoInput.style.display = 'none';
        }
    });
}

// 주문내역 검색기능
let currentPeriodFilter = 'all';
let currentStatusFilter = 'all';

// JSP에서 window.hasOrderList 로 주입받을 예정
let hasOrderList = false;

function filterByPeriod(period) {
    currentPeriodFilter = period;
    applyFilters();
}

function filterByStatus(status) {
    currentStatusFilter = status;
    applyFilters();
}

function parseOrderDate(dateStr) {
    const parts = dateStr.split(' ')[0].split('-');
    return new Date(parts[0], parts[1] - 1, parts[2]);
}

function applyFilters() {
    const rows = document.querySelectorAll('.order-row');
    let visibleCount = 0;
    const today = new Date();

    rows.forEach(row => {
        const orderDate = parseOrderDate(row.dataset.orderDate);
        const status = row.dataset.status;

        let matchesPeriod = true;
        if (currentPeriodFilter !== 'all') {
            const daysDiff = Math.floor((today - orderDate) / 86400000);
            if (currentPeriodFilter === '1month') matchesPeriod = daysDiff <= 30;
            if (currentPeriodFilter === '3month') matchesPeriod = daysDiff <= 90;
            if (currentPeriodFilter === '6month') matchesPeriod = daysDiff <= 180;
        }

        const matchesStatus =
            currentStatusFilter === 'all' || status === currentStatusFilter;

        if (matchesPeriod && matchesStatus) {
            row.style.display = '';
            visibleCount++;
        } else {
            row.style.display = 'none';
        }
    });

    document.getElementById('totalCount').textContent = visibleCount;

    const noResultMsg = document.getElementById('noResultMessage');
    const table = document.getElementById('orderTable');

    if (noResultMsg && table) {
        if (visibleCount === 0 && hasOrderList) {
            noResultMsg.style.display = 'block';
            table.style.display = 'none';
        } else {
            noResultMsg.style.display = 'none';
            table.style.display = 'table';
        }
    }
}

function resetFilters() {
    currentPeriodFilter = 'all';
    currentStatusFilter = 'all';
    applyFilters();
}

document.addEventListener('DOMContentLoaded', () => {
    applyFilters();
});

function parseOrderDate(dateStr) {
    // "2025-12-17 15:30:00" → Date
    const parts = dateStr.split(' ')[0].split('-');
    return new Date(parts[0], parts[1] - 1, parts[2]);
}

function filterByDateRange() {
    const startInput = document.getElementById('startDate').value;
    const endInput = document.getElementById('endDate').value;

    const startDate = startInput ? new Date(startInput) : null;
    const endDate = endInput ? new Date(endInput) : null;

	// ⭐ 핵심: 종료일을 하루의 끝으로 설정
	  if (endDate) {
	      endDate.setHours(23, 59, 59, 999);
	  }
	  
    const rows = document.querySelectorAll('.order-row');
    let visibleCount = 0;

    rows.forEach(row => {
        const orderDate = parseOrderDate(row.dataset.orderDate);
        let visible = true;

        if (startDate && orderDate < startDate) visible = false;
        if (endDate && orderDate > endDate) visible = false;

        row.style.display = visible ? '' : 'none';
        if (visible) visibleCount++;
    });

    document.getElementById('totalCount').textContent = visibleCount;

	 document.getElementById('totalCount').textContent = visibleCount;

	    document.getElementById('noResultMessage').style.display =
	        visibleCount === 0 ? 'block' : 'none';
	}


