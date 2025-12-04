/**
 * 
 */


$(function () {
	
	let ws;

	$("#chat-open").click(function () {
	    $("#chat-box").show();

	    ws = new WebSocket("ws://localhost:8080/ws/chat?userId=user01&adminId=admin01");

	    ws.onmessage = (e) => {
	        $("#chat-messages").append("<div>" + e.data + "</div>");
	    };
	});

	$("#chat-close").click(function () {
	    $("#chat-box").hide();
	    if (ws) ws.close();
	});

	$("#chat-send").click(function () {
	    let msg = $("#chat-text").val();
	    ws.send(msg);
	    $("#chat-text").val("");
	});

/*
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
    });*/
});
