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

    // ❌ 부분 선택 → 채팅 자동 열기 + 메시지 자동 입력
    if (!isFullOrder) {

        alert(
            '부분 ' + type + '은 온라인 신청이 불가능합니다.\n\n' +
            '관리자 채팅으로 연결됩니다.'
        );

        // 1️⃣ 채팅창 열기 (기존 버튼 강제 클릭)
        const chatOpenBtn = document.getElementById('chat-open');
        if (!chatOpenBtn) {
            console.error('❌ chat-open 버튼 없음');
            return;
        }
        chatOpenBtn.click();

        // 2️⃣ 채팅 입력창에 메시지 자동 입력
        setTimeout(function () {
            const chatInput = document.getElementById('chat-text');
            if (chatInput) {
                chatInput.value =
                    '[부분 ' + type + ' 문의]\n' +
                    '주문번호: ' + orderNo + '\n' +
                    '선택 상품에 대해 문의드립니다.';
                chatInput.focus();
            }
        }, 400); // 채팅창 DOM 열릴 시간 확보

        return;
    }

    // ✅ 전체 선택 → 기존 신청 폼
    showCRForm(orderNo, type, true);
}



/* =========================
   전체 취소/반품/교환 폼 표시
========================= */
function showCRForm(orderNo, type) {

    const checkedBoxes = document.querySelectorAll(
        '.product-checkbox[data-order-no="' + orderNo + '"]:checked'
    );

    const selectedItems = Array.from(checkedBoxes)
        .map(cb => cb.value)
        .join(',');

    // 폼 표시
    const container = document.getElementById('crFormContainer_' + orderNo);
    container.style.display = 'block';

    // 값 세팅
    document.getElementById('crType_' + orderNo).value = type;
    document.getElementById('selectedItems_' + orderNo).value = selectedItems;
    document.getElementById('isFullOrder_' + orderNo).value = true;

    // 제목
    let title = '전체 ' + type + ' 신청';
    document.getElementById('crFormTitle_' + orderNo).textContent = title;

    container.scrollIntoView({ behavior: 'smooth', block: 'center' });
}

/* =========================
   부분 선택 시 메시지
========================= */
 function showPartialCancelMessage(type, orderNo, selectedItems) {
    const ok = confirm(
        '부분 ' + type + '은 온라인 신청이 불가능합니다.\n\n' +
        '확인을 누르면 관리자 채팅으로 연결됩니다.'
    );

    if (!ok) return;

    // ✅ 채팅 열기 (이미 있는 로직 사용)
    $("#chat-open").trigger("click");

    // ✅ 채팅 UI 렌더링 후 메시지 자동 입력
    setTimeout(function () {
        const $input = $("#chat-text");

        if ($input.length === 0) {
            console.error("채팅 입력창을 찾을 수 없음");
            return;
        }

        $input.val(
            "주문번호: " + orderNo + "\n" +
            "요청 유형: 부분 " + type + "\n" +
            "선택 상품: " + selectedItems + "\n\n" +
            "부분 " + type + " 문의드립니다."
        );

        $input.focus();
    }, 500);
}

function openChat() {
    document.getElementById('chatToggle').click(); // ← 실제 채팅 버튼
}

/* =========================
   폼 닫기
========================= */
function hideCRForm(orderNo) {
    document.getElementById('crFormContainer_' + orderNo).style.display = 'none';
    document.getElementById('crForm_' + orderNo).reset();
}

/* =========================
   개별 체크 시 전체선택 동기화
========================= */
document.addEventListener('change', function (e) {
    if (!e.target.classList.contains('product-checkbox')) return;

    const orderNo = e.target.dataset.orderNo;
    const allCheckbox = document.getElementById('selectAll_' + orderNo);

    const boxes = document.querySelectorAll(
        '.product-checkbox[data-order-no="' + orderNo + '"]'
    );

    const checkedCount = Array.from(boxes).filter(cb => cb.checked).length;
    allCheckbox.checked = (checkedCount === boxes.length);
});
