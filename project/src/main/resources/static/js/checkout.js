/*체크박스 복사 스크립트*/
document.getElementById('newaccount').addEventListener('change', function() {
    if(this.checked) {
        document.getElementById('shipName').value = document.getElementById('Name').value;
        document.getElementById('shipPhone').value = document.getElementById('Phone').value;
        document.getElementById('shipAddress').value = document.getElementById('Address').value;
    } else {
        document.getElementById('shipName').value = '';
        document.getElementById('shipPhone').value = '';
        document.getElementById('shipAddress').value = '';
    }
});

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
            cardType: selectedCard
        },
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
});