// 주문자 정보 입력 필드들
const nameInput = document.getElementById('Name');
const phoneInput = document.getElementById('Phone');
const addressInput = document.getElementById('Address');

// 수령지 주소 입력 필드들
const shipNameInput = document.getElementById('shipName');
const shipPhoneInput = document.getElementById('shipPhone');
const shipAddressInput = document.getElementById('shipAddress');

// 수령지 주소 섹션
const shippingAddressSection = document.getElementById('shipping-address');

// "위 내용과 동일" 체크박스 (원래 있던 newaccount를 사용)
const sameAsAboveCheckbox = document.getElementById('newaccount');

// 배송지 정보가 모두 입력되었는지 확인
let isShippingSectionOpened = false;

function checkAllFieldsFilled() {
    if (!nameInput || !phoneInput || !addressInput || !shippingAddressSection) return;
    
    const name = nameInput.value.trim();
    const phone = phoneInput.value.trim();
    const address = addressInput.value.trim();
    
    // 모든 필드가 입력되었고 아직 펼쳐지지 않았다면
    if (name !== '' && phone !== '' && address !== '' && !isShippingSectionOpened) {
        $('#shipping-address').collapse('show');
        isShippingSectionOpened = true;
    }
}

// 각 입력 필드에 이벤트 리스너 추가 (입력할 때마다 체크)
if (nameInput && phoneInput && addressInput) {
    nameInput.addEventListener('input', checkAllFieldsFilled);
    phoneInput.addEventListener('input', checkAllFieldsFilled);
    addressInput.addEventListener('input', checkAllFieldsFilled);
}

// "위 내용과 동일" 체크박스 기능
if (sameAsAboveCheckbox && shipNameInput && shipPhoneInput && shipAddressInput) {
    sameAsAboveCheckbox.addEventListener('change', function() {
        if (this.checked) {
            // 주문자 정보를 수령지로 복사
            shipNameInput.value = nameInput.value;
            shipPhoneInput.value = phoneInput.value;
            shipAddressInput.value = addressInput.value;
            
            // 입력 필드 비활성화 (수정 불가)
            shipNameInput.disabled = true;
            shipPhoneInput.disabled = true;
            shipAddressInput.disabled = true;
            
            // 비활성화된 필드 스타일
            shipNameInput.style.backgroundColor = '#e9ecef';
            shipPhoneInput.style.backgroundColor = '#e9ecef';
            shipAddressInput.style.backgroundColor = '#e9ecef';
        } else {
            // 체크 해제 시 입력 필드 활성화 (직접 입력 가능)
            shipNameInput.disabled = false;
            shipPhoneInput.disabled = false;
            shipAddressInput.disabled = false;
            
            // 스타일 복원
            shipNameInput.style.backgroundColor = '';
            shipPhoneInput.style.backgroundColor = '';
            shipAddressInput.style.backgroundColor = '';
        }
    });
    
    // 주문자 정보가 변경되면 "위 내용과 동일"이 체크되어 있을 때 자동 업데이트
    const updateShippingAddress = function() {
        if (sameAsAboveCheckbox.checked) {
            shipNameInput.value = nameInput.value;
            shipPhoneInput.value = phoneInput.value;
            shipAddressInput.value = addressInput.value;
        }
    };
    
    if (nameInput) nameInput.addEventListener('input', updateShippingAddress);
    if (phoneInput) phoneInput.addEventListener('input', updateShippingAddress);
    if (addressInput) addressInput.addEventListener('input', updateShippingAddress);
}

// 옵션 1: 주소 입력 중에도 실시간으로 체크 (blur 대신 input 이벤트)
nameInput.addEventListener('input', checkAllFieldsFilled);
phoneInput.addEventListener('input', checkAllFieldsFilled);
addressInput.addEventListener('input', checkAllFieldsFilled);

// 옵션 2: 마지막 필드 입력 완료 시에만 펼치기
addressInput.addEventListener('blur', function() {
    const name = nameInput.value.trim();
    const phone = phoneInput.value.trim();
    const address = this.value.trim();
    
    if (name !== '' && phone !== '' && address !== '') {
        $(shippingAddressSection).collapse('show');
        // 부드러운 스크롤
        setTimeout(() => {
            shippingAddressSection.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }, 350); // collapse 애니메이션 시간 후
    }
});

// 각 입력 필드에 이벤트 리스너 추가
if (nameInput && phoneInput && addressInput) {
    nameInput.addEventListener('blur', checkAllFieldsFilled);
    phoneInput.addEventListener('blur', checkAllFieldsFilled);
    addressInput.addEventListener('blur', checkAllFieldsFilled);
}

// "위 내용과 동일" 체크박스 클릭 시 주소 복사
if (sameAsAboveCheckbox) {
    sameAsAboveCheckbox.addEventListener('change', function() {
        if (this.checked) {
            // 주소 복사
            shipNameInput.value = nameInput.value;
            shipPhoneInput.value = phoneInput.value;
            shipAddressInput.value = addressInput.value;
            
            // 입력 필드 비활성화 (수정 불가)
            shipNameInput.disabled = true;
            shipPhoneInput.disabled = true;
            shipAddressInput.disabled = true;
        } else {
            // 체크 해제 시 입력 필드 활성화
            shipNameInput.disabled = false;
            shipPhoneInput.disabled = false;
            shipAddressInput.disabled = false;
            
            // 값 초기화 (선택사항)
            // shipNameInput.value = '';
            // shipPhoneInput.value = '';
            // shipAddressInput.value = '';
        }
    });
}

// 주소가 변경되면 "위 내용과 동일" 체크박스가 체크되어 있을 때 자동 업데이트
if (nameInput && phoneInput && addressInput && sameAsAboveCheckbox) {
    const updateShippingAddress = function() {
        if (sameAsAboveCheckbox.checked) {
            shipNameInput.value = nameInput.value;
            shipPhoneInput.value = phoneInput.value;
            shipAddressInput.value = addressInput.value;
        }
    };
    
    nameInput.addEventListener('input', updateShippingAddress);
    phoneInput.addEventListener('input', updateShippingAddress);
    addressInput.addEventListener('input', updateShippingAddress);
}

// 전화번호 입력 유효성 검사 (11자리 제한 + 정상 입력 후 원래 상태로 복구)
const phone = document.getElementById('Phone');
const PhoneError = document.getElementById('PhoneError');

if (phoneInput) {

    phoneInput.addEventListener('input', function () {

        let value = phoneInput.value.replace(/[^0-9]/g, ''); // 숫자만 허용
        phoneInput.value = value;

        // ===============================
        // ⭐ 원래 상태로 되돌리는 함수
        // ===============================
        function resetPhoneStyle() {
            phoneInput.classList.remove('valid-phone', 'invalid-phone');
            phoneInput.style.border = "";               // ★ 테두리 복구
            phoneInput.style.backgroundColor = "";      // ★ 배경 복구
            phoneError.textContent = "";
        }

        // 입력 없으면 원래 상태로
        if (value.length === 0) {
            resetPhoneStyle();
            return;
        }

        // 11자리보다 적음 → 에러
        if (value.length < 11) {
            phoneInput.classList.remove('valid-phone');
            phoneInput.classList.add('invalid-phone');

            phoneInput.style.border = "2px solid #d9534f";
            phoneInput.style.backgroundColor = "#fff5f5";

            phoneError.textContent = "전화번호는 11자리여야 합니다.";
            return;
        }

        // 11자리 초과 → 에러
        if (value.length > 11) {

            phoneInput.classList.remove('valid-phone');
            phoneInput.classList.add('invalid-phone');

            phoneInput.style.border = "2px solid #d9534f";
            phoneInput.style.backgroundColor = "#fff5f5";

            phoneError.textContent = "11자리를 초과했습니다. 다시 입력해주세요.";
            return;
        }

        // ===============================
        // ⭐ 정확히 11자리 → 성공 (초록색)
        // ===============================
        if (value.length === 11) {

            phoneInput.classList.remove('invalid-phone');
            phoneInput.classList.add('valid-phone');

            phoneInput.style.border = "2px solid #5cb85c";
            phoneInput.style.backgroundColor = "#f4fff4";

            phoneError.textContent = "";
            return;
        }
    });
}

// 주문자 전화번호
const phoneError = document.getElementById("PhoneError");
phoneInput.addEventListener("input", () => validatePhone(phoneInput, phoneError));
phoneInput.addEventListener("blur", () => validatePhone(phoneInput, phoneError));

// 수령지 전화번호
const shipPhoneError = document.getElementById("shipPhoneError");
if (shipPhoneInput) {
    shipPhoneInput.addEventListener("input", () => validatePhone(shipPhoneInput, shipPhoneError));
    shipPhoneInput.addEventListener("blur", () => validatePhone(shipPhoneInput, shipPhoneError));
}





/*요청사항 직접입력*/
document.getElementById('memoSelect').addEventListener('change', function() {
    const memoInput = document.getElementById('memoInput');
    if(this.value === 'direct') {
        memoInput.style.display = 'block';
        memoInput.focus();
    } else {
        memoInput.style.display = 'none';
        memoInput.value = '';
    }
});

/*결제 모달 및 결제 방식 처리 */
let selectedCard = null;

// 카드 선택
function selectCard(cardType) {
    selectedCard = cardType;
    document.getElementById('selectedCardDisplay').innerText = '선택한 카드: ' + cardType;

    document.querySelectorAll('.card-btn').forEach(btn => {
        btn.classList.remove('btn-primary');
        btn.classList.add('btn-outline-primary');
    });
    event.target.classList.remove('btn-outline-primary');
    event.target.classList.add('btn-primary');
}

// 결제진행 (서버 전송 추가!)
function processPayment() {
    if (!selectedCard) {
        alert('카드를 선택해주세요!');
        return;
    }

    // 주문 정보 수집
    const name = $('#Name').val();
    const phone = $('#Phone').val();
    const address = $('#Address').val();
    const shipName = $('#shipName').val() || name;
    const shipPhone = $('#shipPhone').val() || phone;
    const shipAddress = $('#shipAddress').val() || address;
    const memo = $('#memoSelect').val() === 'direct' ? $('#memoInput').val() : $('#memoSelect').val();
    
    // 유효성 검사
    if(!name || !phone || !address) {
        alert('필수 정보를 입력해주세요.');
        return;
    }

    // 서버로 주문 데이터 전송
	$.ajax({
	    url: '/processPayment',
	    method: 'POST',
	    data: {
	        name: name,
	        phone: phone,
	        address: address,
	        shipName: shipName,
	        shipPhone: shipPhone,
	        shipAddress: shipAddress,
	        memo: memo,
	        cardType: selectedCard,
			amount: '${cartTotal}' 
	    },
	    xhrFields: {
	        withCredentials: true  // ★ 세션 쿠키 전송
	    },
	    crossDomain: true,          // ★ jQuery에서 credentials 사용 시 필수
	    success: function(response) {
	        $('#payModal').modal('hide');

	        // sessionStorage에도 저장 (필요시)
	        sessionStorage.setItem('selectedCard', selectedCard);
	        sessionStorage.setItem('amount', '${cartTotal}');

	        // 주문 완료 페이지로 이동
	        window.location.href = '/ordercomplete?orderNo=' + response.orderNo;
	    },
	    error: function(error) {
	        alert('결제 처리 중 오류가 발생했습니다.');
	        console.error(error);
	    }
	});
}

document.addEventListener('DOMContentLoaded', function() {
    const btnOpenModal = document.getElementById('btnOpenModal');
    const paymentRadios = document.querySelectorAll('input[name="payment"]');
    const bankRadio = document.getElementById('directcheck');
    const bankInfo = document.getElementById('bankInfo');

    // 결제하기 버튼 클릭
    btnOpenModal.addEventListener('click', function(e) {
        e.preventDefault();
        let selected = null;
        paymentRadios.forEach(radio => {
            if(radio.checked) selected = radio.id;
        });

        if(!selected) {
            alert('결제 방식을 선택해주세요!');
            return;
        }

        if(selected === 'paypal') {
            $('#payModal').modal('show');
        } else if(selected === 'directcheck') {
            // 계좌이체도 서버에 주문 저장 후 이동
            const name = $('#Name').val();
            const phone = $('#Phone').val();
            const address = $('#Address').val();
            
            if(!name || !phone || !address) {
                alert('필수 정보를 입력해주세요.');
                return;
            }
            
            $.ajax({
                url: '/processPayment',
                method: 'POST',
                data: {
                    name: name,
                    phone: phone,
                    address: address,
                    paymentType: 'bank'
                },
                success: function(response) {
                    window.location.href = '/ordercomplete?orderNo=' + response.orderNo;
                },
                error: function(error) {
                    alert('결제 처리 중 오류가 발생했습니다.');
                }
            });
        }
    });

    // 계좌이체 선택 시 계좌번호 표시
    paymentRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            if(bankRadio.checked) {
                bankInfo.style.display = 'block';
            } else {
                bankInfo.style.display = 'none';
            }
        });
    });

    // 네이버페이, 카카오페이 버튼
    const naverBtn = document.getElementById('naverPayBtn');
    const kakaoBtn = document.getElementById('kakaoPayBtn');

    naverBtn.addEventListener('click', function() {
        window.location.href = '/naver';
    });

    kakaoBtn.addEventListener('click', function() {
        window.location.href = '/kakao';
    });
	
	// 폼 제출 시 장바구니 체크
	const checkoutForm = document.getElementById('checkoutForm');
	if (checkoutForm) {
	    checkoutForm.addEventListener('submit', function(e) {
	        const cartCountElement = document.getElementById('cartCount');
	        const cartCount = cartCountElement ? parseInt(cartCountElement.textContent) : 0;
	        
	        if (cartCount === 0 || isNaN(cartCount)) {
	            e.preventDefault();
	            alert('장바구니에 상품이 없습니다.');
	            window.location.href = 'cart';
	            return false;
	        }
	    });
	}
	
});