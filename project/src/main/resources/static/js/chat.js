/**
 * 
 */


$(function () {

    $("#chat-icon").click(function () {
        $("#chat-box").toggle();
    });

    let userId = "user123"; 
    let adminId = "admin123";

    let ws = new WebSocket("ws://localhost:8080/ws/chat?userId=" + userId + "&adminId=" + adminId);

    ws.onmessage = function (msg) {
        $("#chat-messages").append("<div>" + msg.data + "</div>");
    };

    $("#chat-send").click(function () {
        let text = $("#chat-input").val();
        ws.send(text);
        $("#chat-input").val("");
    });
});
