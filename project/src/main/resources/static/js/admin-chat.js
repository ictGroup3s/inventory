/**
 * 
 */

$(function () {

    // ----------------- WebSocket 연결 -----------------
    const adminSocket = new WebSocket("ws://" + location.host + "/ws/chat");

    // ----------------- 관리자 ID 정의 -----------------
    const adminId = "admin";

    // ----------------- 메시지 출력 함수 -----------------
    function appendAdminMessage(msg, type, timestamp) {
        const timeStr = timestamp ? `<span class="time">[${timestamp}]</span> ` : "";
        const html = `<div class="admin-chat-message ${type}">${timeStr}${msg}</div>`;
        $("#admin-chat-messages").append(html);
        $("#admin-chat-messages").scrollTop($("#admin-chat-messages")[0].scrollHeight);
    }

    // ----------------- 채팅 목록 불러오기 (선택 사항) -----------------
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
        $.getJSON("/chat/history/" + chatNo, function (chat) {
            if (chat && chat.chat_file) {
                $.get("/chat/files/" + chat.chat_file, function (text) {
                    text.split("\n").forEach(function (line) {
                        if (line.trim() !== "") {
                            appendAdminMessage(line, "other"); // user 메시지는 other
                        }
                    });
                });
            }
        });
    }

    // ----------------- 채팅 전송 -----------------
    $("#admin-chat-send").click(function () {
        const message = $("#admin-chat-text").val();
        if (!message) return;

        const chatMsg = {
            customerId: "user", // 실제 상대 ID (user)
            adminId: adminId,
            message: message
        };

        adminSocket.send(JSON.stringify(chatMsg));
        appendAdminMessage(message, "self"); // 내 메시지 self로 표시
        $("#admin-chat-text").val("");
    });

    // ----------------- 서버 메시지 수신 -----------------
    adminSocket.onmessage = function (event) {
        const chatMsg = JSON.parse(event.data);

        // 관리자 입장에서 user가 보낸 메시지이면 "other"로 표시
        const type = chatMsg.customerId !== adminId ? "other" : "self";
        appendAdminMessage(chatMsg.message, type, chatMsg.timestamp || null);
    };

    // ----------------- 엔터키 전송 -----------------
    $("#admin-chat-text").keypress(function (e) {
        if (e.which === 13) {
            $("#admin-chat-send").click();
            return false;
        }
    });
});
