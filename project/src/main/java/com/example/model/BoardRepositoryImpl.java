package com.example.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.BoardVO;

@Repository
public class BoardRepositoryImpl implements BoardRepository {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final String NS = "boardMapper.";

    @Override
    public List<BoardVO> getBoardList() {
        return sqlSession.selectList(NS + "getBoardList");
    }

    @Override
    public BoardVO getBoardDetail(int boardNo) {
        // boardMapper.xml 의 getBoardDetail 사용
        return sqlSession.selectOne(NS + "getBoardDetail", boardNo);
    }

    @Override
    public void insertBoard(BoardVO vo) {
        sqlSession.insert(NS + "insertBoard", vo);
    }
}
