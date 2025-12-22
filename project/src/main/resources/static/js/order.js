/* =========================
   전체 선택 / 해제
========================= */
function toggleAllProducts(orderNo) {
    const selectAll = document.getElementById('selectAll_' + orderNo);
    const products = document.querySelectorAll(
        '.product-checkbox[data-order-no="' + orderNo + '"]'
    );

    products.forEach(cb => cb.checked = selectAll.checked);
}

/* =========================
   취소 / 반품 / 교환 버튼 처리
========================= */
function handleCRRequest(orderNo, type) {
    console.log("🔥 handleCRRequest 호출 - orderNo:", orderNo, "type:", type);

    // 선택된 상품
    const checked = document.querySelectorAll(
        '.product-checkbox[data-order-no="' + orderNo + '"]:checked'
    );

    // 아무것도 선택 안 함
    if (checked.length === 0) {
        alert("상품을 선택해주세요.");
        return;
    }

    // 전체 상품
    const all = document.querySelectorAll(
        '.product-checkbox[data-order-no="' + orderNo + '"]'
    );

    const isFullOrder = checked.length === all.length;
    console.log("전체 선택 여부:", isFullOrder, "(선택:", checked.length, "/ 전체:", all.length + ")");

    // ❌ 부분 선택 → 채팅 자동 열기 + 메시지 자동 입력
    if (!isFullOrder) {
        alert(
            '부분 ' + type + '은 온라인 신청이 불가능합니다.\n\n' +
            '관리자 채팅으로 연결됩니다.'
        );

        // 채팅창 열기
        const chatOpenBtn = document.getElementById('chat-open');
        if (!chatOpenBtn) {
            console.error('❌ chat-open 버튼 없음');
            return;
        }
        chatOpenBtn.click();

        // 선택된 상품 목록
        const selectedItems = Array.from(checked).map(cb => cb.value).join(',');

        // 채팅 입력창에 메시지 자동 입력
        setTimeout(function () {
            const chatInput = document.getElementById('chat-text');
            if (chatInput) {
                chatInput.value =
                    '[부분 ' + type + ' 문의]\n' +
                    '주문번호: ' + orderNo + '\n' +
                    '선택 상품: ' + selectedItems + '\n' +
                    '부분 ' + type + '에 대해 문의드립니다.';
                chatInput.focus();
            }
        }, 400);

        return;
    }

    // ✅ 전체 선택 → 신청 폼 표시
    console.log("✅ 전체 선택 - 신청 폼 표시");
    showCRForm(orderNo, type);
}

/* =========================
   전체 취소/반품/교환 폼 표시
========================= */
function showCRForm(orderNo, type) {
    console.log("📝 showCRForm 호출 - orderNo:", orderNo, "type:", type);

    const checkedBoxes = document.querySelectorAll(
        '.product-checkbox[data-order-no="' + orderNo + '"]:checked'
    );

    // 선택된 상품 목록
    const selectedItems = Array.from(checkedBoxes)
        .map(cb => cb.value)
        .join(',');

    console.log("선택된 상품:", selectedItems);

    // hidden input에 값 설정
    const typeInput = document.getElementById('crType_' + orderNo);
    const itemsInput = document.getElementById('selectedItems_' + orderNo);
    const fullOrderInput = document.getElementById('isFullOrder_' + orderNo);

    if (typeInput) {
        typeInput.value = type;
        console.log("✅ type 설정:", type);
    } else {
        console.error("❌ crType input 없음");
    }

    if (itemsInput) {
        itemsInput.value = selectedItems;
        console.log("✅ selectedItems 설정:", selectedItems);
    } else {
        console.error("❌ selectedItems input 없음");
    }

    if (fullOrderInput) {
        fullOrderInput.value = 'true';
        console.log("✅ isFullOrder 설정: true");
    } else {
        console.error("❌ isFullOrder input 없음");
    }

    // 폼 표시
    const container = document.getElementById('crFormContainer_' + orderNo);
    if (container) {
        container.style.display = 'block';
        console.log("✅ 폼 컨테이너 표시");
        
        // 제목 설정 (있는 경우에만)
        const titleElement = document.getElementById('crFormTitle_' + orderNo);
        if (titleElement) {
            titleElement.textContent = '전체 ' + type + ' 신청';
        }

        // 폼으로 스크롤
        container.scrollIntoView({ behavior: 'smooth', block: 'center' });
    } else {
        console.error("❌ 폼 컨테이너 없음");
    }
}

/* =========================
   폼 닫기
========================= */
function hideCRForm(orderNo) {
    console.log("폼 닫기:", orderNo);
    
    const container = document.getElementById('crFormContainer_' + orderNo);
    if (container) {
        container.style.display = 'none';
    }
    
    // 체크박스 초기화
    const checkboxes = document.querySelectorAll('.product-checkbox[data-order-no="' + orderNo + '"]');
    checkboxes.forEach(checkbox => checkbox.checked = false);
    
    const selectAllCheckbox = document.getElementById('selectAll_' + orderNo);
    if (selectAllCheckbox) {
        selectAllCheckbox.checked = false;
    }
    
    // 폼 리셋
    const form = document.getElementById('crForm_' + orderNo);
    if (form) {
        form.reset();
    }
}

/* =========================
   개별 체크 시 전체선택 동기화
========================= */
document.addEventListener('change', function (e) {
    if (!e.target.classList.contains('product-checkbox')) return;

    const orderNo = e.target.dataset.orderNo;
    const allCheckbox = document.getElementById('selectAll_' + orderNo);

    if (!allCheckbox) return;

    const boxes = document.querySelectorAll(
        '.product-checkbox[data-order-no="' + orderNo + '"]'
    );

    const checkedCount = Array.from(boxes).filter(cb => cb.checked).length;
    allCheckbox.checked = (checkedCount === boxes.length);
});

console.log("✅ 주문관리 함수 로드 완료");


// form submit 이벤트 감지
document.addEventListener('DOMContentLoaded', function() {
    console.log("✅ Form submit 리스너 등록");
    
    // 모든 CR 신청 폼에 이벤트 리스너 추가
    document.addEventListener('submit', function(e) {
        // CR 신청 폼인지 확인
        if (e.target.id && e.target.id.startsWith('crForm_')) {
            console.log("📤 폼 제출 감지:", e.target.id);
            
            const formData = new FormData(e.target);
            console.log("폼 데이터:");
            for (let [key, value] of formData.entries()) {
                console.log(`  ${key}: ${value}`);
            }
            
            // 필수 값 체크
            const orderNo = formData.get('orderNo');
            const type = formData.get('type');
            const reason = formData.get('reason');
            
            if (!type || type === '') {
                console.error("❌ type 값이 비어있음!");
                alert("신청 유형이 설정되지 않았습니다.");
                e.preventDefault();
                return false;
            }
            
            if (!reason || reason.trim() === '') {
                console.error("❌ reason 값이 비어있음!");
                alert("사유를 입력해주세요.");
                e.preventDefault();
                return false;
            }
            
            console.log("✅ 폼 검증 통과 - 서버로 전송");
        }
    });
});

