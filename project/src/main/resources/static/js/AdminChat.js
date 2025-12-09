/**
 * AdminChat.js
 * 관리자 채팅 전용 JS
 */

$(function() {
	console.log("관리자 채팅 JS 로드 완료");

	if (typeof adminId === 'undefined' || !adminId || adminId === "") {
		console.error("❌ 관리자 로그인 정보가 없습니다.");
		alert("관리자 로그인이 필요합니다.");
		return;
	}

	console.log("✅ 현재 관리자:", adminId);

	let adminSocket = null;
	let currentCustomerId = null;
	let currentChatNo = null;
	let reconnectInterval = null;
	let lastDisplayedDate = null;

	// WebSocket 연결 함수
	function connectAdminWebSocket() {
		adminSocket = new WebSocket("ws://" + location.host + "/ws/chat");

		adminSocket.onopen = function() {
			console.log("✅ 관리자 WebSocket 연결 성공!");
			if (reconnectInterval) {
				clearTimeout(reconnectInterval);
				reconnectInterval = null;
			}
		};

		adminSocket.onerror = function(error) {
			console.error("❌ 관리자 WebSocket 에러:", error);
		};

		adminSocket.onclose = function() {
			console.log("🔌 관리자 WebSocket 연결 종료");
			if (!reconnectInterval) {
				reconnectInterval = setTimeout(function() {
					console.log("🔄 재연결 시도 중...");
					connectAdminWebSocket();
				}, 3000);
			}
		};

		adminSocket.onmessage = function(event) {
			console.log("📨 관리자 메시지 수신:", event.data);
			const chatMsg = JSON.parse(event.data);

			// 현재 열린 채팅방이면 메시지 표시
			if (chatMsg.customerId === currentCustomerId) {
				const type = chatMsg.sender === "admin" ? "self" : "other";
				appendAdminMessage(chatMsg.message, type, chatMsg.timestamp || null);
			}

			// 고객이 보낸 메시지면 목록에 빨간 점 표시
			if (chatMsg.sender === "customer") {
				const chatRoom = $(`.chat-room[data-customer-id="${chatMsg.customerId}"]`);
				if (chatMsg.customerId !== currentCustomerId) {
					chatRoom.addClass("has-unread");
				}
			}
		};
	}

	// 초기 연결
	connectAdminWebSocket();

	// 메시지 화면에 추가 함수
	function appendAdminMessage(msg, type, timestamp) {
		if (msg === "__JOIN__") return;

		let html = "";

		if (timestamp) {
			const dateTime = new Date(timestamp.replace(" ", "T"));
			const dateStr = formatDate(dateTime);
			const timeStr = formatTime(dateTime);

			if (lastDisplayedDate !== dateStr) {
				html += `<div class="date-divider">${dateStr}</div>`;
				lastDisplayedDate = dateStr;
			}

			html += `<div class="admin-chat-message ${type}">${msg}<span class="time">${timeStr}</span></div>`;
		} else {
			html += `<div class="admin-chat-message ${type}">${msg}</div>`;
		}

		$("#admin-chat-messages").append(html);
		$("#admin-chat-messages").scrollTop($("#admin-chat-messages")[0].scrollHeight);
	}

	// 날짜 포맷
	function formatDate(date) {
		const days = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
		const year = date.getFullYear();
		const month = date.getMonth() + 1;
		const day = date.getDate();
		const dayName = days[date.getDay()];
		return `${year}년 ${month}월 ${day}일 ${dayName}`;
	}

	// 시간 포맷
	function formatTime(date) {
		let hours = date.getHours();
		const minutes = String(date.getMinutes()).padStart(2, "0");
		const period = hours < 12 ? "오전" : "오후";

		if (hours === 0) hours = 12;
		else if (hours > 12) hours -= 12;

		return `${period} ${hours}:${minutes}`;
	}

	// 채팅 목록 불러오기
	function loadAdminChatList() {
		$.getJSON("/admin/chat/rooms?adminId=" + adminId, function(data) {
			$("#admin-chat-list").empty();

			if (data.length === 0) {
				$("#admin-chat-list").append("<div class='no-chat'>채팅방이 없습니다</div>");
				return;
			}

			data.forEach(function(room) {
				const div = $(`
					<div class="chat-room" data-customer-id="${room.customer_id}" data-chat-no="${room.chat_no}">
						💬 ${room.customer_id} (채팅 #${room.chat_no})
					</div>
				`);

				// 안읽은 메시지 확인
				$.getJSON("/admin/chat/unread?adminId=" + adminId + "&customerId=" + room.customer_id, function(count) {
					if (count > 0) {
						div.addClass("has-unread");
					}
				});

				div.click(function() {
					currentCustomerId = room.customer_id;
					currentChatNo = room.chat_no;
					console.log("✅ 선택된 고객:", currentCustomerId);
					$("#current-chat-user").text(room.customer_id + "님과의 채팅");
					loadAdminChatHistory(room.chat_no);
					$(".chat-room").removeClass("active");
					$(this).addClass("active");
					$(this).removeClass("has-unread");

					// 읽음 처리
					$.post("/admin/chat/read?adminId=" + adminId + "&customerId=" + room.customer_id);

					// 방 입장 (세션 등록)
					joinRoom(room.customer_id);
				});

				$("#admin-chat-list").append(div);
			});
		}).fail(function() {
			console.error("채팅 목록 불러오기 실패");
		});
	}

	// 방 입장 (세션 등록)
	function joinRoom(customerId) {
		if (!adminSocket || adminSocket.readyState !== WebSocket.OPEN) return;

		const joinMsg = {
			customerId: customerId,
			adminId: adminId,
			message: "__JOIN__",
			sender: "admin",
			type: "join"
		};

		adminSocket.send(JSON.stringify(joinMsg));
		console.log("🚪 관리자 방 입장:", joinMsg);
	}

	// 페이지 로드 시 채팅 목록 불러오기
	loadAdminChatList();

	// 채팅 기록 불러오기
	function loadAdminChatHistory(chatNo) {
		console.log("🔍 채팅 내역 불러오기 시작:", chatNo);
		$("#admin-chat-messages").empty();
		lastDisplayedDate = null;

		$.getJSON("/admin/chat/history/" + chatNo, function(chat) {
			console.log("📦 받은 채팅 데이터:", chat);

			if (chat && chat.chat_file) {
				console.log("📄 파일명:", chat.chat_file);

				$.get("/chat/files/" + chat.chat_file, function(text) {
					console.log("📝 파일 내용:", text);

					text.split("\n").forEach(function(line) {
						if (!line.trim()) return;

						const match = line.match(/^\[(.*?)\] (.*?): (.*)$/);
						if (match) {
							const timestamp = match[1];
							const sender = match[2];
							const msg = match[3];

							const type = sender === adminId ? "self" : "other";
							appendAdminMessage(msg, type, timestamp);
						}
					});
				}).fail(function(error) {
					console.error("❌ 파일 불러오기 실패:", error);
				});
			} else {
				console.warn("⚠️ chat_file이 없음");
			}
		}).fail(function(error) {
			console.error("❌ 채팅 기록 불러오기 실패:", error);
		});
	}

	// 메시지 전송 함수
	function sendMessage() {
		if (!currentCustomerId) {
			alert("채팅방을 선택해주세요.");
			return;
		}

		const message = $("#admin-chat-text").val().trim();
		if (!message) return;

		if (!adminSocket || adminSocket.readyState !== WebSocket.OPEN) {
			alert("연결이 끊어졌습니다. 재연결 중...");
			connectAdminWebSocket();
			return;
		}

		const chatMsg = {
			customerId: currentCustomerId,
			adminId: adminId,
			message: message,
			sender: "admin"
		};

		try {
			console.log("📤 관리자 메시지 전송:", chatMsg);
			adminSocket.send(JSON.stringify(chatMsg));
			$("#admin-chat-text").val("");
		} catch (error) {
			console.error("메시지 전송 실패:", error);
			alert("메시지 전송에 실패했습니다.");
		}
	}

	// Send 버튼 클릭 이벤트
	$("#admin-chat-send").off("click").on("click", function() {
		sendMessage();
	});

	// Enter 키 입력 이벤트
	$("#admin-chat-text").off("keypress").on("keypress", function(e) {
		if (e.which === 13) {
			sendMessage();
			return false;
		}
	});

	// 채팅 목록 새로고침 버튼
	$("#refresh-chat-list").on("click", function() {
		loadAdminChatList();
	});

	// 채팅 종료 버튼
	$("#close-chat").on("click", function() {
		if (!currentChatNo) {
			alert("채팅방을 선택해주세요.");
			return;
		}

		if (confirm("이 채팅을 종료하시겠습니까?")) {
			$.post("/admin/chat/close/" + currentChatNo, function() {
				alert("채팅이 종료되었습니다.");
				$("#admin-chat-messages").empty();
				$("#current-chat-user").text("채팅방을 선택해주세요");

				// 입력창 비활성화
				$("#admin-chat-text").prop("disabled", true);
				$("#admin-chat-send").prop("disabled", true);
				$("#close-chat").prop("disabled", true);

				currentCustomerId = null;
				currentChatNo = null;
				loadAdminChatList();
			}).fail(function() {
				alert("채팅 종료에 실패했습니다.");
			});
		}
	});

	div.click(function() {
		currentCustomerId = room.customer_id;
		currentChatNo = room.chat_no;
		console.log("✅ 선택된 고객:", currentCustomerId);
		$("#current-chat-user").text(room.customer_id + "님과의 채팅");
		loadAdminChatHistory(room.chat_no);
		$(".chat-room").removeClass("active");
		$(this).addClass("active");
		$(this).removeClass("has-unread");

		// 입력창 활성화
		$("#admin-chat-text").prop("disabled", false);
		$("#admin-chat-send").prop("disabled", false);
		$("#close-chat").prop("disabled", false);

		// 읽음 처리
		$.post("/admin/chat/read?adminId=" + adminId + "&customerId=" + room.customer_id);

		// 방 입장 (세션 등록)
		joinRoom(room.customer_id);
	});
});