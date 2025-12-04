package com.example.chat;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessageEntity, String> {

    long countByRoomIdAndIsReadFalse(String roomId);

    List<ChatMessageEntity> findTop100ByRoomIdOrderByTimestampDesc(String roomId);

}
