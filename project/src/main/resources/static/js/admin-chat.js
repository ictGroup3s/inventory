/**
 * admin-chat.js
 * 관리자 채팅 전용 JS
 * - Send 버튼 및 Enter 키로 메시지 전송
 * - WebSocket 서버와 실시간 통신
 * - self(오른쪽) / other(왼쪽) 메시지 표시
 * - 스크롤 자동 최하단
 */

$(function () {

    // ----------------- WebSocket 연결 -----------------
    const adminSocket = new WebSocket("ws://" + location.host + "/ws/chat");

    // ----------------- 관리자 ID 정의 -----------------
    const adminId = "admin";

    // ----------------- 메시지 화면에 추가 함수 -----------------
    function appendAdminMessage(msg, type, timestamp) {
        const timeStr = timestamp ? `<span class="time">[${timestamp}]</span> ` : "";
        const html = `<div class="admin-chat-message ${type}">${timeStr}${msg}</div>`;
        $("#admin-chat-messages").append(html);

        // 새 메시지 생기면 항상 맨 아래로 스크롤
        $("#admin-chat-messages").scrollTop($("#admin-chat-messages")[0].scrollHeight);
    }

    // ----------------- 채팅 목록 불러오기 -----------------
    function loadAdminChatList() {
        $.getJSON("/chat/rooms/admin", function (data) {
            $("#admin-chat-list").empty();
            data.forEach(function (room) {
                const div = $(`
                    <div class="chat-room">
                        ☰ 채팅 #${room.chat_no}
                    </div>
                `);
                div.click(function () {
                    loadAdminChatHistory(room.chat_no);
                });
                $("#admin-chat-list").append(div);
            });
        });
    }

    // ----------------- 채팅 기록 불러오기 -----------------
    function loadAdminChatHistory(chatNo) {
        $("#admin-chat-messages").empty();
        $.getJSON("/admin/chat/history/" + chatNo, function (chat) {
            if (chat && chat.chat_file) {
                $.get("/chat/files/" + chat.chat_file, function (text) {
                    text.split("\n").forEach(function (line) {
                        if (line.trim() !== "") {
                            appendAdminMessage(line, "other"); // user 메시지는 'other'
                        }
                    });
                });
            }
        });
    }

    // ----------------- 메시지 전송 함수 -----------------
    function sendMessage() {
        const message = $("#admin-chat-text").val().trim();
        if (!message) return;

        const chatMsg = {
            customerId: "user", // 상대 ID
            adminId: adminId,
            message: message
        };

        // WebSocket 서버로 메시지 전송
        adminSocket.send(JSON.stringify(chatMsg));

        // 화면에 관리자 메시지 표시
        appendAdminMessage(message, "self");

        // 입력창 초기화
        $("#admin-chat-text").val("");
    }

    // ----------------- Send 버튼 클릭 이벤트 -----------------
    $("#admin-chat-send").off("click").on("click", function () {
        sendMessage();
    });

    // ----------------- Enter 키 입력 이벤트 -----------------
    $("#admin-chat-text").off("keypress").on("keypress", function (e) {
        if (e.which === 13) { // Enter 키
            sendMessage();
            return false; // 폼 제출 방지
        }
    });

    // ----------------- 서버 메시지 수신 -----------------
    adminSocket.onmessage = function (event) {
        const chatMsg = JSON.parse(event.data);

        // 자기(admin)가 보낸 메시지는 화면에 다시 추가하지 않음
        if (chatMsg.adminId === adminId) return;

        appendAdminMessage(chatMsg.message, "other", chatMsg.timestamp || null);
    };

});
