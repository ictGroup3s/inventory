$(function() {
	console.log("고객 채팅 JS 로드 완료");
	console.log("chat-open 버튼:", $("#chat-open").length);
	console.log("back-to-top 버튼:", $(".back-to-top").length);

	// 버튼 강제 표시
	$(".back-to-top").show();

	// 로그인한 고객 ID (HTML에서 주입됨)
	const isLoggedIn = myId && myId.trim() !== "";

	let socket = null;
	let reconnectInterval = null;
	let assignedAdminId = null;

	// WebSocket 연결 함수
	function connectWebSocket() {
		if (!isLoggedIn) return;

		socket = new WebSocket("ws://" + location.host + "/ws/chat");

		socket.onopen = function() {
			console.log("✅ WebSocket 연결 성공!");
			if (reconnectInterval) {
				clearTimeout(reconnectInterval);
				reconnectInterval = null;
			}
		};

		socket.onerror = function(error) {
			console.error("❌ WebSocket 에러:", error);
		};

		socket.onclose = function() {
			console.log("🔌 WebSocket 연결 종료");
			if (!reconnectInterval) {
				reconnectInterval = setTimeout(function() {
					console.log("🔄 재연결 시도 중...");
					connectWebSocket();
				}, 3000);
			}
		};

		socket.onmessage = function(event) {
			console.log("📨 메시지 수신:", event.data);
			const chatMsg = JSON.parse(event.data);

			const type = chatMsg.sender === "customer" ? "self" : "other";
			appendMessage(chatMsg.message, type, chatMsg.timestamp || null);
		};
	}

	// 초기 연결
	connectWebSocket();

	function appendMessage(msg, type, timestamp) {
		const timeStr = timestamp ? `<span class="time">[${timestamp}]</span> ` : "";
		const html = `<div class="message ${type}">${timeStr}${msg}</div>`;
		$("#chat-messages").append(html);
		$("#chat-messages").scrollTop($("#chat-messages")[0].scrollHeight);
	}

	// -------------------- 관리자 자동 배정 --------------------
	function assignAdmin() {
		$.ajax({
			url: "/chat/assign-admin",
			type: "POST",
			contentType: "application/json",
			data: JSON.stringify({ customerId: myId }),
			success: function(adminId) {
				assignedAdminId = adminId;
				console.log("✅ 배정된 관리자:", assignedAdminId);
			},
			error: function() {
				console.error("❌ 관리자 배정 실패");
				alert("관리자 연결에 실패했습니다.");
			}
		});
	}

	// -------------------- 채팅 내역 불러오기 --------------------
	function loadChatHistory(chatNo) {
		if (!isLoggedIn) {
			alert("로그인이 필요합니다.");
			return;
		}

		console.log("🔍 채팅 내역 불러오기:", chatNo);
		$("#chat-messages").empty();

		$.getJSON("/chat/history/" + chatNo, function(chat) {
			console.log("📦 받은 채팅 데이터:", chat);

			if (chat && chat.chat_file) {
				$.get("/chat/files/" + chat.chat_file, function(text) {
					console.log("📝 파일 내용:", text);

					text.split("\n").forEach(function(line) {
						if (!line.trim()) return;

						const match = line.match(/^\[(.*?)\] (.*?): (.*)$/);

						if (match) {
							const timestamp = match[1];
							const sender = match[2];
							const msg = match[3];
							const type = sender === myId ? "self" : "other";

							console.log("🔍 sender:", sender);
							console.log("🔍 myId:", myId);
							console.log("🔍 같나?:", sender === myId);
							console.log("---");

							appendMessage(msg, type, timestamp);
						}
					});
				}).fail(function(error) {
					console.error("❌ 파일 불러오기 실패:", error);
				});
			}
		}).fail(function(error) {
			console.error("❌ 채팅 기록 불러오기 실패:", error);
		});
	}

	// -------------------- 메시지 전송 --------------------
	$("#chat-send").click(function() {
		console.log("Send 버튼 클릭됨");

		if (!isLoggedIn) {
			alert("로그인이 필요합니다.");
			return;
		}

		if (!assignedAdminId) {
			alert("관리자 연결 중입니다. 잠시 후 다시 시도해주세요.");
			assignAdmin();
			return;
		}

		const msg = $("#chat-text").val();
		console.log("입력된 메시지:", msg);

		if (!msg) {
			console.log("메시지가 비어있음");
			return;
		}

		if (!socket || socket.readyState !== WebSocket.OPEN) {
			alert("연결이 끊어졌습니다. 재연결 중...");
			connectWebSocket();
			return;
		}

		const json = {
			customerId: myId,
			adminId: assignedAdminId,
			message: msg,
			sender: "customer"
		};

		try {
			console.log("전송할 데이터:", json);
			socket.send(JSON.stringify(json));
			$("#chat-text").val("");
		} catch (error) {
			console.error("전송 실패:", error);
			alert("메시지 전송에 실패했습니다.");
		}
	});

	// 엔터키
	$("#chat-text").keypress(function(e) {
		if (e.which === 13) {
			$("#chat-send").click();
			return false;
		}
	});

	// -------------------- 토글 --------------------
	const chatBox = $("#chat-box");
	const listBox = $("#chat-list-box");

	$("#chat-open").click(function() {
		if (!isLoggedIn) {
			alert("로그인이 필요합니다.");
			return;
		}

		if (!assignedAdminId) {
			assignAdmin();
		}

		chatBox.css("display", chatBox.css("display") === "none" ? "flex" : "none");
	});

	$("#chat-close").click(function() {
		chatBox.hide();
	});

	$("#chat-toggle-list").click(function() {
		if (!isLoggedIn) {
			alert("로그인이 필요합니다.");
			return;
		}

		if (listBox.css("display") === "none") {
			loadChatList();
			listBox.show();
		} else {
			listBox.hide();
		}
	});

	function loadChatList() {
		console.log("📋 채팅 목록 불러오기 시작");
		console.log("📋 myId:", myId);

		$.getJSON("/chat/rooms/" + myId, function(data) {
			console.log("📦 받은 채팅 목록 데이터:", data);

			$("#chat-list").empty();

			if (!data || data.length === 0) {
				$("#chat-list").append("<div class='no-chat'>채팅 내역이 없습니다</div>");
				return;
			}

			data.forEach(function(room) {
				console.log("📌 채팅방:", room);

				const box = $("<div class='chat-room'>채팅 #" + room.chat_no + "</div>");

				box.click(function() {
					console.log("채팅방 클릭:", room.chat_no);
					loadChatHistory(room.chat_no);
					$("#chat-list-box").hide();
					$("#chat-box").css("display", "flex");
				});

				$("#chat-list").append(box);
			});
		}).fail(function(error) {
			console.error("❌ 채팅 목록 불러오기 실패:", error);
			$("#chat-list").append("<div class='no-chat'>채팅 목록을 불러올 수 없습니다</div>");
		});
	}
});