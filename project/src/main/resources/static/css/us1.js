/**
 *  userchat.js
 */

$(function () {
    const socket = new WebSocket("ws://" + location.host + "/ws");

    const myId = "user";

    function appendMessage(msg, type, timestamp) {
        const timeStr = timestamp ? `<span class="time">[${timestamp}]</span> ` : "";
        const html = `<div class="message ${type}">${timeStr}${msg}</div>`;
        $("#chat-messages").append(html);
        $("#chat-messages").scrollTop($("#chat-messages")[0].scrollHeight);
    }

    $("#chat-send").click(function () {
        const message = $("#chat-text").val();
        if (!message) return;

        const chatMsg = { customerId: myId, adminId: "admin", message: message };
        socket.send(JSON.stringify(chatMsg));
        $("#chat-text").val("");
    });

    socket.onmessage = function (event) {
        const chatMsg = JSON.parse(event.data);
        const type = chatMsg.customerId === myId ? "self" : "other";
        appendMessage(chatMsg.message, type, chatMsg.timestamp || null);
    };
});
