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

	// 결제진행
	function processPayment() {
		if (!selectedCard) {
			alert('카드를 선택해주세요!');
			return;
		}
		
		sessionStorage.setItem('selectedCard', selectedCard);
		sessionStorage.setItem('amount', '${cartTotal}');
		window.location.href = '/ordercomplete';
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
				// 계좌이체는 바로 완료 페이지로 이동
				window.location.href = '/ordercomplete';
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