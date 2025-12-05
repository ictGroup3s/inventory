/**
 * 채팅 기능 jQuery 최종 완성본
 */


$(function () {

    // ----------------- WebSocket 연결 -----------------
    const socket = new WebSocket("ws://" + location.host + "/ws/chat");

    // ----------------- 내 ID 정의 -----------------
    const myId = "user"; // <-- 로그인된 내 ID로 변경

    // ----------------- 메시지 출력 함수 -----------------
    function appendMessage(msg, type, timestamp) {
        const timeStr = timestamp ? `<span class="time">[${timestamp}]</span> ` : "";
        const html = `<div class="message ${type}">${timeStr}${msg}</div>`;
        $("#chat-messages").append(html);
        $("#chat-messages").scrollTop($("#chat-messages")[0].scrollHeight);
    }

    // ----------------- 나의 채팅 목록 불러오기 -----------------
    function loadChatList() {
        $.getJSON("/chat/rooms/customer1", function (data) {
            $("#chat-list").empty();

            data.forEach(function (room) {
                const div = $(`
                    <div class="chat-room">
                        ☰ 채팅 #${room.chat_no}
                    </div>
                `);

                div.click(function () {
                    loadChatHistory(room.chat_no);
                    $("#chat-list-box").hide();
                    $("#chat-box").css("display", "flex");
                });

                $("#chat-list").append(div);
            });
        });
    }

    // ----------------- 채팅 기록 불러오기 -----------------
    function loadChatHistory(chatNo) {
        $("#chat-messages").empty();

        $.getJSON("/chat/history/" + chatNo, function (chat) {
            if (chat && chat.chat_file) {
                $.get("/chat/files/" + chat.chat_file, function (text) {
                    text.split("\n").forEach(function (line) {
                        if (line.trim() !== "") {
                            // 채팅 기록 불러올 때는 상대 메시지 기준으로 "other"
                            appendMessage(line, "other");
                        }
                    });
                });
            }
        });
    }

    // ----------------- 채팅 전송 -----------------
    $("#chat-send").click(function () {
        const message = $("#chat-text").val();
        if (!message) return;

        const chatMsg = {
            customerId: myId,
            adminId: "admin",
            message: message
        };

        socket.send(JSON.stringify(chatMsg));
        $("#chat-text").val("");
    });

    // ----------------- 서버 메시지 수신 -----------------
    socket.onmessage = function (event) {
        const chatMsg = JSON.parse(event.data);

        // 내 메시지면 self, 상대 메시지면 other
        const type = chatMsg.customerId === myId ? "self" : "other";
        appendMessage(chatMsg.message, type, chatMsg.timestamp || null);
    };

    // ---------------------------------------------------
    //                  토글 기능 FIXED
    // ---------------------------------------------------

    const chatBox = $("#chat-box");
    const listBox = $("#chat-list-box");

    $("#chat-open").off("click");
    $("#chat-close").off("click");
    $("#chat-toggle-list").off("click");

    // ----------------- 채팅창 열기/닫기 -----------------
    $("#chat-open").on("click", function () {
        const isVisible = chatBox.css("display") !== "none";
        if (isVisible) {
            chatBox.hide();
        } else {
            chatBox.css("display", "flex");
        }
    });

    $("#chat-close").on("click", function () {
        chatBox.hide();
    });

    // ----------------- 리스트 열기/닫기 -----------------
    $("#chat-toggle-list").on("click", function () {
        const isVisible = listBox.css("display") !== "none";
        if (isVisible) {
            listBox.hide();
        } else {
            loadChatList();
            listBox.css("display", "block");
        }
    });

    // ----------------- 엔터키 전송 -----------------
    $("#chat-text").keypress(function (e) {
        if (e.which === 13) {
            $("#chat-send").click();
            return false;
        }
    });

});
