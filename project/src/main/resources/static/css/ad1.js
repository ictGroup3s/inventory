/**
 *  adminchat.js
 */

$(function () {
    const adminSocket = new WebSocket("ws://" + location.host + "/ws");
    const adminId = "admin";

    function appendAdminMessage(msg, type, timestamp) {
        const timeStr = timestamp ? `<span class="time">[${timestamp}]</span> ` : "";
        const html = `<div class="admin-chat-message ${type}">${timeStr}${msg}</div>`;
        $("#admin-chat-messages").append(html);
        $("#admin-chat-messages").scrollTop($("#admin-chat-messages")[0].scrollHeight);
    }

    function sendMessage() {
        const message = $("#admin-chat-text").val().trim();
        if (!message) return;

        const chatMsg = { customerId: "user", adminId: adminId, message: message };
        adminSocket.send(JSON.stringify(chatMsg));
        appendAdminMessage(message, "self");
        $("#admin-chat-text").val("");
    }

    $("#admin-chat-send").off("click").on("click", function () { sendMessage(); });
    $("#admin-chat-text").off("keypress").on("keypress", function (e) {
        if (e.which === 13) { sendMessage(); return false; }
    });

    adminSocket.onmessage = function (event) {
        const chatMsg = JSON.parse(event.data);
        if (chatMsg.adminId === adminId) return;
        appendAdminMessage(chatMsg.message, "other", chatMsg.timestamp || null);
    };
});
