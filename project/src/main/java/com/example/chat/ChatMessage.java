package com.example.chat;

/**
 * 채팅 메시지 DTO
 * - type: 메시지 종류(CHAT, JOIN, LEAVE)
 * - id: 메시지 고유 ID (서버에서 생성 가능)
 * - roomId: 채팅 룸 식별자 (예: 주문번호 또는 'admin')
 * - sender: 송신자 이름 또는 식별자
 * - content: 메시지 본문
 * - timestamp: 밀리초 단위 UTC 타임스탬프
 * - isRead: 관리자가 해당 메시지를 확인했는지 여부 (true = 읽음)
 */
public class ChatMessage {

	public enum MessageType { CHAT, JOIN, LEAVE }

    private MessageType type;
    private String id;
    private String roomId;
    private String sender;
    private String content;
    private long timestamp;
    private boolean isRead; // 추가: 읽음 여부

	public MessageType getType() {
		return type;
	}
	public void setType(MessageType type) {
		this.type = type;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getRoomId() {
		return roomId;
	}
	public void setRoomId(String roomId) {
		this.roomId = roomId;
	}
	public String getSender() {
		return sender;
	}
	public void setSender(String sender) {
		this.sender = sender;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public long getTimestamp() {
		return timestamp;
	}
	public void setTimestamp(long timestamp) {
		this.timestamp = timestamp;
	}
	public boolean isRead() {
		return isRead;
	}
	public void setRead(boolean isRead) {
		this.isRead = isRead;
	}
	
    
}