$(function() {
	console.log("고객 채팅 JS 로드 완료");
	console.log("chat-open 버튼:", $("#chat-open").length);
	console.log("back-to-top 버튼:", $(".back-to-top").length);

	$(".back-to-top").show();

	const isLoggedIn = myId && myId.trim() !== "";

	let socket = null;
	let reconnectInterval = null;
	let assignedAdminId = null;
	let lastDisplayedDate = null;
	let hasNewMessage = false; // 새 메시지 플래그

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

			// 연결되면 바로 방 입장 (관리자 배정 후)
			if (assignedAdminId) {
				joinRoom();
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

			console.log("보낸 사람:", chatMsg.sender);
			console.log("채팅창 상태:", $("#chat-box").css("display"));

			// 관리자가 보낸 메시지 + 채팅창 닫혀있으면 빨간 점 표시
			if (chatMsg.sender === "admin" && $("#chat-box").css("display") === "none") {
				console.log("🔴 빨간 점 추가!");
				hasNewMessage = true;
				$("#chat-open").addClass("has-unread");
			}
		};
	}

	// 방 입장 (빈 메시지로 세션 등록)
	function joinRoom() {
		if (!socket || socket.readyState !== WebSocket.OPEN) return;
		if (!assignedAdminId) return;

		const joinMsg = {
			customerId: myId,
			adminId: assignedAdminId,
			message: "__JOIN__",
			sender: "customer",
			type: "join"
		};

		socket.send(JSON.stringify(joinMsg));
		console.log("🚪 방 입장 요청:", joinMsg);
	}

	// 초기 연결
	connectWebSocket();

	// 메시지 출력 함수
	function appendMessage(msg, type, timestamp) {
		// JOIN 메시지는 표시 안 함
		if (msg === "__JOIN__") return;

		console.log("timestamp:", timestamp);
		let html = "";

		if (timestamp) {
			const dateTime = new Date(timestamp.replace(" ", "T"));
			const dateStr = formatDate(dateTime);
			const timeStr = formatTime(dateTime);

			if (lastDisplayedDate !== dateStr) {
				html += `<div class="date-divider">${dateStr}</div>`;
				lastDisplayedDate = dateStr;
			}

			html += `<div class="message ${type}">${msg}<span class="time">${timeStr}</span></div>`;
		} else {
			html += `<div class="message ${type}">${msg}</div>`;
		}

		$("#chat-messages").append(html);
		$("#chat-messages").scrollTop($("#chat-messages")[0].scrollHeight);
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

	// 관리자 자동 배정
	function assignAdmin() {
		$.ajax({
			url: "/chat/assign-admin",
			type: "POST",
			contentType: "application/json",
			data: JSON.stringify({ customerId: myId }),
			success: function(adminId) {
				assignedAdminId = adminId;
				console.log("✅ 배정된 관리자:", assignedAdminId);
				// 관리자 배정 후 방 입장
				joinRoom();
			},
			error: function() {
				console.error("❌ 관리자 배정 실패");
				alert("관리자 연결에 실패했습니다.");
			}
		});
	}

	// 페이지 로드 시 관리자 배정
	if (isLoggedIn) {
		assignAdmin();
	}

	// 채팅 내역 불러오기
	function loadChatHistory(chatNo) {
		if (!isLoggedIn) {
			alert("로그인이 필요합니다.");
			return;
		}

		console.log("🔍 채팅 내역 불러오기:", chatNo);
		$("#chat-messages").empty();
		lastDisplayedDate = null;

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

	// 메시지 전송
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

	// 토글
	const chatBox = $("#chat-box");
	const listBox = $("#chat-list-box");

	// 채팅 열기 버튼
	$("#chat-open").click(function() {
		if (!isLoggedIn) {
			alert("로그인이 필요합니다.");
			return;
		}

		if (!assignedAdminId) {
			assignAdmin();
		}

		// 채팅창 토글
		if (chatBox.css("display") === "none") {
			chatBox.css("display", "flex");
			// 빨간 점 제거
			hasNewMessage = false;
			$("#chat-open").removeClass("has-unread");

			// 최근 채팅 내역 자동 로드
			loadLatestChat();
		} else {
			chatBox.hide();
		}
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

	// 최근 채팅 내역 자동 로드
	function loadLatestChat() {
		$.getJSON("/chat/rooms/" + myId, function(data) {
			if (data && data.length > 0) {
				const latestRoom = data[0];
				console.log("📂 최근 채팅방 로드:", latestRoom.chat_no);
				loadChatHistory(latestRoom.chat_no);
			}
		});
	}

	// 페이지 로드 시 최근 채팅 내역 미리 로드
	if (isLoggedIn) {
		loadLatestChat();
	}
	
	// 안읽은 메시지 확인 함수
	function checkUnreadMessages() {
	    if (!isLoggedIn) return;

	    $.getJSON("/chat/unread/" + myId, function(count) {
	        console.log("안읽은 메시지 개수:", count);
	        if (count > 0) {
	            hasNewMessage = true;
	            $("#chat-open").addClass("has-unread");
	        }
	    });
	}

	// 페이지 로드 시 안읽은 메시지 확인
	if (isLoggedIn) {
	    checkUnreadMessages();
	}
});