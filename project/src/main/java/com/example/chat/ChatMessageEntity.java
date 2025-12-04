package com.example.chat;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * JPA 엔티티: 채팅 메시지 영속화용
 */
@Entity
@Table(name = "chat_message")
public class ChatMessageEntity {

	@Id
	@Column(length = 64)
	private String id;

	@Column(nullable = false)
	private String roomId;

	@Column(nullable = false)
	private String sender;

	@Column(columnDefinition = "TEXT")
	private String content;

	@Column
	private String type; // enum name stored as String (e.g. "CHAT")

	@Column
	private long timestamp;

	@Column(nullable = false)
	private boolean isRead = false;

	public ChatMessageEntity() {
	}

	public ChatMessageEntity(String id, String roomId, String sender, String content, String type, long timestamp) {
		this.id = id;
		this.roomId = roomId;
		this.sender = sender;
		this.content = content;
		this.type = type;
		this.timestamp = timestamp;
		this.isRead = false;
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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
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

	public void setRead(boolean read) {
		isRead = read;
	}
}
