$(function() {
	console.log("고객 채팅 JS 로드 완료");
	console.log("chat-open 버튼:", $("#chat-open").length);
	console.log("back-to-top 버튼:", $(".back-to-top").length);

	$(".back-to-top").show();

	// 채팅창 상태 복원
	const chatOpen = sessionStorage.getItem("chatOpen");
	if (chatOpen === "true") {
		$("#chat-box").css("display", "flex");
	}
	
	const isLoggedIn = myId && myId.trim() !== "";

	let socket = null;
	let reconnectInterval = null;
	let assignedAdminId = null;
	let lastDisplayedDate = null;
	let hasNewMessage = false;
	let currentChatNo = null; // 현재 채팅방 번호 추가

	function showToast(message, type = 'info') {
		const container = $('#toast-container');
		if (container.length === 0) {
			$('body').append('<div class="toast-container" id="toast-container"></div>');
		}

		// 기존 모든 토스트 제거 (중복 방지)
		$('#toast-container .toast').remove();

		const toast = $(`<div class="toast ${type}">${message}</div>`);
		$('#toast-container').append(toast);

		// 10초 유지 → CSS 애니메이션 자체가 10초 후 fade-out
		setTimeout(() => {
			toast.remove();
		}, 4000); // 애니메이션 완전히 끝난 후 삭제
	}

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

			// 채팅 종료 메시지 처리
			if (chatMsg.message === "__CLOSE__") {
				console.log("🔒 채팅 종료 알림 수신");

				// 종료 메시지 표시
				$("#chat-messages").append(`
		            <div class="system-message">
		                채팅이 종료되었습니다.
		            </div>
		        `);

				// 입력창 비활성화
				$("#chat-text").prop("disabled", true);
				$("#chat-send").prop("disabled", true);

				// 새 채팅 시작 버튼 표시
				$("#new-chat-btn").show();

				return;
			}

			const type = chatMsg.sender === "customer" ? "self" : "other";
			appendMessage(chatMsg.message, type, chatMsg.timestamp || null);

			console.log("보낸 사람:", chatMsg.sender);
			console.log("채팅창 상태:", $("#chat-box").css("display"));

			if (chatMsg.sender === "admin" && $("#chat-box").css("display") === "none") {
				console.log("🔴 빨간 점 추가!");
				hasNewMessage = true;
				$("#chat-open").addClass("has-unread");
			}
		};
	}

	// 방 입장
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

	connectWebSocket();

	// 메시지 출력 함수
	function appendMessage(msg, type, timestamp) {
	    if (msg === "__JOIN__") return;

	    const $container = $("#chat-messages");

	    // 사용자가 이미 맨 아래에 있었는지 체크
	    const isAtBottom =
	        $container.scrollTop() + $container.innerHeight() >=
	        $container[0].scrollHeight - 10;

	    let html = "";

	    if (timestamp) {
	        const dateTime = new Date(timestamp.replace(" ", "T"));
	        const dateStr = formatDate(dateTime);
	        const timeStr = formatTime(dateTime);

	        if (lastDisplayedDate !== dateStr) {
	            html += `<div class="date-divider">${dateStr}</div>`;
	            lastDisplayedDate = dateStr;
	        }

	        html += `<div class="message ${type}">
	                    ${msg}
	                    <span class="time">${timeStr}</span>
	                 </div>`;
	    } else {
	        html += `<div class="message ${type}">${msg}</div>`;
	    }

	    // 🔹 append (아래로 쌓임)
	    $container.append(html);

	    // 🔹 사용자가 맨 아래에 있을 때만 자동 스크롤
	    if (isAtBottom) {
	        $container.scrollTop($container[0].scrollHeight);
	    }
	}



	function formatDate(date) {
		const days = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
		const year = date.getFullYear();
		const month = date.getMonth() + 1;
		const day = date.getDate();
		const dayName = days[date.getDay()];
		return `${year}년 ${month}월 ${day}일 ${dayName}`;
	}

	function formatTime(date) {
		let hours = date.getHours();
		const minutes = String(date.getMinutes()).padStart(2, "0");
		const period = hours < 12 ? "오전" : "오후";

		if (hours === 0) hours = 12;
		else if (hours > 12) hours -= 12;

		return `${period} ${hours}:${minutes}`;
	}

	function assignAdmin() {
		$.ajax({
			url: "/chat/assign-admin",
			type: "POST",
			contentType: "application/json",
			data: JSON.stringify({ customerId: myId }),
			success: function(adminId) {
				assignedAdminId = adminId;
				console.log("✅ 배정된 관리자:", assignedAdminId);
				joinRoom();
			},
			error: function() {
				console.error("❌ 관리자 배정 실패");
				showToast("관리자 연결에 실패했습니다.", "error");
			}
		});
	}

	if (isLoggedIn) {
		assignAdmin();
	}

	// 채팅 내역 불러오기
	function loadChatHistory(chatNo) {
		if (!isLoggedIn) {
			showToast("로그인이 필요합니다.", "warning");
			return;
		}

		currentChatNo = chatNo; // 현재 채팅방 번호 저장

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

	// 실제 메시지 전송 함수
	function sendMessageToServer() {
		const msg = $("#chat-text").val();
		console.log("입력된 메시지:", msg);

		if (!msg) {
			console.log("메시지가 비어있음");
			return;
		}

		if (!socket || socket.readyState !== WebSocket.OPEN) {
			showToast("연결이 끊어졌습니다. 재연결 중...", "info");
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
			showToast("메시지 전송에 실패했습니다.", "error");
		}
	}

	// 메시지 전송
	$("#chat-send").click(function() {
		console.log("Send 버튼 클릭됨");

		if (!isLoggedIn) {
			showToast("로그인이 필요합니다.", "warning");
			return;
		}

		if (!assignedAdminId) {
			showToast("관리자 연결 중입니다. 잠시 후 다시 시도해주세요.", "info");
			assignAdmin();
			return;
		}

		// 현재 채팅방이 종료됐는지 확인
		if (currentChatNo) {
			$.getJSON("/chat/status/" + currentChatNo, function(status) {
				console.log("채팅 상태:", status);
				if (status === "CLOSED") {
					// 종료된 채팅이면 새 채팅 시작
					console.log("🆕 종료된 채팅 - 새 채팅 시작");
					currentChatNo = null;
					$("#chat-messages").empty();
					lastDisplayedDate = null;
				}
				sendMessageToServer();
			}).fail(function() {
				// API 실패해도 메시지 전송 시도
				console.log("상태 확인 실패, 메시지 전송 시도");
				sendMessageToServer();
			});
		} else {
			sendMessageToServer();
		}
	});

	// 엔터키
	$("#chat-text").keypress(function(e) {
		if (e.which === 13) {
			$("#chat-send").click();
			return false;
		}
	});

	const chatBox = $("#chat-box");
	const listBox = $("#chat-list-box");

	$("#chat-open").click(function() {
		if (!isLoggedIn) {
			showToast("로그인이 필요합니다.", "error");
			return;
		}

		if (!assignedAdminId) {
			assignAdmin();
		}

		if (chatBox.css("display") === "none") {
			chatBox.css("display", "flex");
			sessionStorage.setItem("chatOpen", "true");  // 상태 저장
			hasNewMessage = false;
			$("#chat-open").removeClass("has-unread");
			loadLatestChat();
		} else {
			chatBox.hide();
			sessionStorage.setItem("chatOpen", "false");  // 상태 저장
		}
	});

	$("#chat-close").click(function() {
		chatBox.hide();
		sessionStorage.setItem("chatOpen", "false");  // 상태 저장
	});

	$("#chat-toggle-list").click(function() {
		if (!isLoggedIn) {
			showToast("로그인이 필요합니다.", "warning");
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

				const isClosed = room.status === 'CLOSED';
				const statusText = isClosed ? '🔒 종료됨' : '💬 진행중';

				const box = $(`
	                <div class='chat-room ${isClosed ? "closed" : ""}'>
	                    <span class="chat-info">채팅 #${room.chat_no} (${statusText})</span>
	                    <button class="delete-btn" data-chat-no="${room.chat_no}">✕</button>
	                </div>
	            `);

				// 채팅방 클릭
				box.find(".chat-info").click(function() {
					console.log("채팅방 클릭:", room.chat_no);
					loadChatHistory(room.chat_no);
					$("#chat-list-box").hide();
					$("#chat-box").css("display", "flex");

					// 종료된 채팅이면 입력창 비활성화
					if (isClosed) {
						$("#chat-text").prop("disabled", true);
						$("#chat-send").prop("disabled", true);
						$("#new-chat-btn").show();
					} else {
						$("#chat-text").prop("disabled", false);
						$("#chat-send").prop("disabled", false);
						$("#new-chat-btn").hide();
					}
				});

				// 삭제 버튼 클릭
				box.find(".delete-btn").click(function(e) {
					e.stopPropagation();
					if (confirm("이 채팅을 삭제하시겠습니까?")) {
						$.ajax({
							url: "/chat/delete/" + room.chat_no,
							type: "DELETE",
							success: function() {
								showToast("삭제되었습니다.", "info");
								loadChatList();
							},
							error: function() {
								showToast("삭제에 실패했습니다.", "error");
							}
						});
					}
				});

				$("#chat-list").append(box);
			});
		}).fail(function(error) {
			console.error("❌ 채팅 목록 불러오기 실패:", error);
			$("#chat-list").append("<div class='no-chat'>채팅 목록을 불러올 수 없습니다</div>");
		});
	}

	function loadLatestChat() {
		$.getJSON("/chat/rooms/" + myId, function(data) {
			if (data && data.length > 0) {
				const latestRoom = data[0];
				console.log("📂 최근 채팅방 로드:", latestRoom.chat_no);
				loadChatHistory(latestRoom.chat_no);
			}
		});
	}

	if (isLoggedIn) {
		loadLatestChat();
	}

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

	if (isLoggedIn) {
		checkUnreadMessages();
	}


	// 새 채팅 시작 버튼
	$("#new-chat-btn").click(function() {
		console.log("🆕 새 채팅 시작");

		// 초기화
		currentChatNo = null;
		$("#chat-messages").empty();
		lastDisplayedDate = null;

		// 입력창 활성화
		$("#chat-text").prop("disabled", false);
		$("#chat-send").prop("disabled", false);

		// 버튼 숨기기
		$("#new-chat-btn").hide();

		// 새 관리자 배정
		assignAdmin();
	});
});