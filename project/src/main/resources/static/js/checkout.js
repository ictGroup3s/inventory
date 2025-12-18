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
if (checkoutForm) {
    checkoutForm.addEventListener('submit', function () {
        // 수령지주소입력 체크 안 했으면
        if (!shipToCheckbox.checked) {
            shipNameInput.value = nameInput.value;
            shipPhoneInput.value = phoneInput.value;
            shipAddressInput.value = addressInput.value;
        }

        // 수령지주소입력은 했지만 값이 비어있을 경우
        if (!shipNameInput.value) shipNameInput.value = nameInput.value;
        if (!shipPhoneInput.value) shipPhoneInput.value = phoneInput.value;
        if (!shipAddressInput.value) shipAddressInput.value = addressInput.value;
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





//마이페이지 검색기능
let currentTypeFilter = 'all';
	let currentStatusFilter = 'all';
	let currentSearchText = '';
	let currentSearchType = 'all';
	const hasCrList = document.body.dataset.hasCrList === 'true';

	// 검색 기능
	function searchCR() {
		currentSearchText = document.getElementById('searchInput').value.toLowerCase().trim();
		currentSearchType = document.getElementById('searchType').value;
		applyFilters();
	}

	// Enter 키로 검색
	document.getElementById('searchInput').addEventListener('keypress', function(e) {
		if (e.key === 'Enter') {
			searchCR();
		}
	});

	// 검색 타입 변경 시 placeholder 변경
	document.getElementById('searchType').addEventListener('change', function() {
		const searchInput = document.getElementById('searchInput');
		const searchType = this.value;
		
		if (searchType === 'all') {
			searchInput.placeholder = '검색어를 입력하세요';
		} else if (searchType === 'order_no') {
			searchInput.placeholder = '주문번호를 입력하세요';
		} else if (searchType === 'item_name') {
			searchInput.placeholder = '상품명을 입력하세요';
		}
	});

	// 유형별 필터
	function filterByType(type) {
		currentTypeFilter = type;
		
		// 버튼 활성화 상태 변경
		document.querySelectorAll('[data-type]').forEach(badge => {
			badge.classList.remove('active', 'badge-secondary');
			badge.classList.add('badge-light');
		});
		document.querySelector(`[data-type="${type}"]`).classList.add('active', 'badge-secondary');
		document.querySelector(`[data-type="${type}"]`).classList.remove('badge-light');
		
		applyFilters();
	}

	// 상태별 필터
	function filterByStatus(status) {
		currentStatusFilter = status;
		
		// 버튼 활성화 상태 변경
		document.querySelectorAll('[data-status]').forEach(badge => {
			badge.classList.remove('active', 'badge-secondary');
			badge.classList.add('badge-light');
		});
		document.querySelector(`[data-status="${status}"]`).classList.add('active', 'badge-secondary');
		document.querySelector(`[data-status="${status}"]`).classList.remove('badge-light');
		
		applyFilters();
	}

	// 모든 필터 적용
	function applyFilters() {
		const rows = document.querySelectorAll('.cr-row');
		let visibleCount = 0;
		
		rows.forEach(row => {
			const orderNo = row.dataset.orderNo.toLowerCase();
			const itemName = row.dataset.itemName.toLowerCase();
			const type = row.dataset.type;
			const status = row.dataset.status;
			
			// 검색어 필터
			let matchesSearch = true;
			if (currentSearchText !== '') {
				if (currentSearchType === 'all') {
					matchesSearch = orderNo.includes(currentSearchText) || itemName.includes(currentSearchText);
				} else if (currentSearchType === 'order_no') {
					matchesSearch = orderNo.includes(currentSearchText);
				} else if (currentSearchType === 'item_name') {
					matchesSearch = itemName.includes(currentSearchText);
				}
			}
			
			// 유형 필터
			const matchesType = currentTypeFilter === 'all' || type === currentTypeFilter;
			
			// 상태 필터
			const matchesStatus = currentStatusFilter === 'all' || status === currentStatusFilter;
			
			// 모든 조건 만족 시 표시
			if (matchesSearch && matchesType && matchesStatus) {
				row.style.display = '';
				visibleCount++;
			} else {
				row.style.display = 'none';
			}
		});
		
		// 결과 카운트 업데이트
		document.getElementById('totalCount').textContent = visibleCount;
		
		// 검색 결과 텍스트
		let resultText = '';
		if (currentSearchText) {
			const searchTypeText = currentSearchType === 'order_no' ? '주문번호' : 
								   currentSearchType === 'item_name' ? '상품명' : '전체';
			resultText += `- "${currentSearchText}" (${searchTypeText})`;
		}
		if (currentTypeFilter !== 'all') {
			resultText += ` [${currentTypeFilter}]`;
		}
		if (currentStatusFilter !== 'all') {
			resultText += ` [${currentStatusFilter}]`;
		}
		document.getElementById('searchResultText').textContent = resultText;
		
		// 검색 결과 없음 메시지
		const noResultMsg = document.getElementById('noResultMessage');
		const table = document.getElementById('crTable');
		if (visibleCount === 0 && hasCrList) {
			noResultMsg.style.display = 'block';
			table.style.display = 'none';
		} else {
			noResultMsg.style.display = 'none';
			table.style.display = 'table';
		}
	}

	// 초기화
	function resetSearch() {
		// 검색 필드 초기화
		document.getElementById('searchInput').value = '';
		document.getElementById('searchType').value = 'all';
		document.getElementById('searchInput').placeholder = '검색어를 입력하세요';
		
		currentSearchText = '';
		currentSearchType = 'all';
		currentTypeFilter = 'all';
		currentStatusFilter = 'all';
		
		// 모든 필터 버튼 초기화
		document.querySelectorAll('.filter-badge').forEach(badge => {
			badge.classList.remove('active', 'badge-secondary');
			badge.classList.add('badge-light');
		});
		document.querySelector('[data-type="all"]').classList.add('active', 'badge-secondary');
		document.querySelector('[data-type="all"]').classList.remove('badge-light');
		document.querySelector('[data-status="all"]').classList.add('active', 'badge-secondary');
		document.querySelector('[data-status="all"]').classList.remove('badge-light');
		
		applyFilters();
	}

