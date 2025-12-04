package com.example.model;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.ChatVO;

@Repository
public class ChatRepository {
	
	@Autowired
	private SqlSessionTemplate sess;
	public void saveChat(ChatVO vo) {
		sess.insert("chatMapper.insertChat", vo);
	}
}
