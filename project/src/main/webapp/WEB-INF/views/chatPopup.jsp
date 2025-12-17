<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅 팝업 예제</title>

<!-- STOMP/SockJS 클라이언트 CDN -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<style>
/* 작은 채팅 버튼 (화면 우측 하단) */
.chat-button {
  position: fixed;
  right: 20px;
  bottom: 20px;
  z-index: 1050;
  background:#007bff; color:#fff; border:none; border-radius:50%;
  width:60px; height:60px; cursor:pointer; box-shadow:0 4px 12px rgba(0,0,0,0.2);
  display:flex; align-items:center; justify-content:center; font-size:22px;
}

/* 채팅 창 */
.chat-box {
  position: fixed;
  right: 20px;
  bottom: 90px;
  width: 320px;
  max-width: calc(100% - 40px);
  height: 420px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 8px 24px rgba(0,0,0,0.15);
  display: none;
  flex-direction: column;
  overflow: hidden;
  z-index: 1060;
}

/* 헤더 */
.chat-header {
  background:#007bff; color:#fff; padding:10px 12px; font-weight:600;
  display:flex; justify-content:space-between; align-items:center;
}

/* 메시지 영역 */
.chat-messages {
  padding: 12px;
  height: calc(100% - 110px);
  overflow-y: auto;
  background: #f7f7f7;
}

/* 입력영역 */
.chat-input {
  display:flex; padding:8px; gap:8px; border-top:1px solid #eee;
}
.chat-input input { flex:1; padding:8px 10px; border-radius:6px; border:1px solid #ddd; }
.chat-input button { background:#007bff; color:#fff; border:none; padding:8px 12px; border-radius:6px; }

/* 메시지 스타일 */
.msg { margin-bottom:10px; display:block; clear:both; }
.msg .meta { font-size:11px; color:#666; margin-bottom:2px; }
.msg .text { padding:8px 10px; border-radius:6px; display:inline-block; max-width:80%; }
.msg.customer .text { background:#e9f2ff; color:#044; float:left; }
.msg.admin .text { background:#007bff; color:#fff; float:right; }
</style>
</head>
<body>

<!-- 채팅 버튼 -->
<button id="chatToggle" class="chat-button" title="문의">
  💬
</button>

<!-- 채팅 박스 -->
<div id="chatBox" class="chat-box" role="dialog" aria-hidden="true">
  <div class="chat-header">
    <span>관리자 채팅</span>
    <div>
      <button id="minimizeBtn" title="최소화" style="background:none;border:none;color:#fff">─</button>
      <button id="closeBtn" title="닫기" style="background:none;border:none;color:#fff">✕</button>
    </div>
  </div>

  <div id="messages" class="chat-messages"></div>

  <div class="chat-input">
    <input id="senderInput" placeholder="이름(선택) e.g. 손님" />
    <input id="messageInput" placeholder="메시지를 입력하세요..." />
    <button id="sendBtn">전송</button>
  </div>
</div>

<script>
(function() {
  const toggle = document.getElementById('chatToggle');
  const box = document.getElementById('chatBox');
  const closeBtn = document.getElementById('closeBtn');
  const minimizeBtn = document.getElementById('minimizeBtn');
  const messagesEl = document.getElementById('messages');
  const sendBtn = document.getElementById('sendBtn');
  const input = document.getElementById('messageInput');
  const senderInput = document.getElementById('senderInput');

  // 기본 roomId: 고객-관리자 단일 채팅이면 'admin' 등 지정
  const roomId = 'admin'; // 필요시 동적 생성 (주문번호 기반 등)
  let stompClient = null;
  let connected = false;

  function showBox() { box.style.display = 'flex'; box.setAttribute('aria-hidden','false'); }
  function hideBox() { box.style.display = 'none'; box.setAttribute('aria-hidden','true'); }

  toggle.addEventListener('click', function() {
    if (box.style.display === 'flex') {
      hideBox();
    } else {
      showBox();
      if (!connected) connect();
    }
  });
  closeBtn.addEventListener('click', hideBox);
  minimizeBtn.addEventListener('click', function(){
    // 최소화: 메시지 영역과 입력 숨기기(간단)
    if (messagesEl.style.display === 'none') {
      messagesEl.style.display = ''; document.querySelector('.chat-input').style.display = 'flex';
    } else {
      messagesEl.style.display = 'none'; document.querySelector('.chat-input').style.display = 'none';
    }
  });

  // print message
  function appendMessage(msg) {
    const el = document.createElement('div');
    el.className = 'msg ' + (msg.sender && msg.sender.toLowerCase().includes('admin') ? 'admin' : 'customer');
    const meta = document.createElement('div'); meta.className = 'meta';
    const time = new Date(msg.timestamp || Date.now()).toLocaleTimeString();
    meta.textContent = (msg.sender || '누군가') + ' · ' + time;
    const text = document.createElement('div'); text.className = 'text';
    text.textContent = msg.content;
    el.appendChild(meta); el.appendChild(text);
    messagesEl.appendChild(el);
    messagesEl.scrollTop = messagesEl.scrollHeight;
  }

  // WebSocket / STOMP 연결
  function connect() {
    const socket = new SockJS(window.location.origin + '/ws');
    stompClient = Stomp.over(socket);
    stompClient.debug = function(){}; // 콘솔 숨김 (원하면 로깅)
    stompClient.connect({}, function(frame) {
      connected = true;
      // 구독: room 별 구독
      stompClient.subscribe('/topic/chat/' + roomId, function(payload) {
        try {
          const msg = JSON.parse(payload.body);
          appendMessage(msg);
        } catch(e) { console.error(e); }
      });
      // (옵션) 히스토리 불러오기: REST endpoint가 구현되어있다면 호출해서 appendMessage
      fetch(window.location.origin + '/api/chat/history?roomId=' + encodeURIComponent(roomId))
        .then(r => r.json())
        .then(list => { if (Array.isArray(list)) list.forEach(appendMessage); })
        .catch(()=>{});
    }, function(error){
      console.error('STOMP error', error);
    });
  }

  // 전송
  function send() {
    const text = input.value && input.value.trim();
    if (!text) return;
    const sender = senderInput.value && senderInput.value.trim() || '손님';
    const msg = { type: 'CHAT', roomId: roomId, sender: sender, content: text, timestamp: Date.now() };
    if (stompClient && connected) {
      stompClient.send('/app/chat.send', {}, JSON.stringify(msg));
      input.value = '';
      // 로컬에 즉시 표시 (옵션)
      appendMessage(msg);
    } else {
      // fallback: REST 전송 가능
      fetch('/api/chat/send', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(msg) })
        .then(()=> { input.value=''; appendMessage(msg); })
        .catch(e => console.error(e));
    }
  }

  sendBtn.addEventListener('click', send);
  input.addEventListener('keypress', function(e){ if (e.key === 'Enter') send(); });
})();
</script>
</body>
</html>