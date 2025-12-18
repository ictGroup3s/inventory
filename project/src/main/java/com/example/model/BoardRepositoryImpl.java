package com.example.model;

import java.util.List;
import java.util.Map;

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
    
    @Override
    public void updateBoard(BoardVO vo) {
        sqlSession.update(NS + "updateBoard", vo);
    }
    
    @Override
    public void deleteBoard(int boardNo) {
        sqlSession.delete(NS + "deleteBoard", boardNo);
    }
    
    // ================= 페이징 추가 =================

    @Override
    public List<BoardVO> getBoardListPaging(Map<String, Object> param) {
        return sqlSession.selectList(NS + "getBoardListPaging", param);
    }

    @Override
    public int getBoardCount() {
        return sqlSession.selectOne(NS + "getBoardCount");
    }


  
    // FAQ 
   
    @Override
    public List<BoardVO> getFaqListPaging(Map<String, Object> param) {
        return sqlSession.selectList(NS + "getFaqListPaging", param);
    }

    @Override
    public int getFaqCount() {
        return sqlSession.selectOne(NS + "getFaqCount");
    }

    @Override
    public BoardVO getFaqDetail(int boardNo) {
        return sqlSession.selectOne(NS + "getFaqDetail", boardNo);
    }

    @Override
    public void insertFaq(BoardVO vo) {
        sqlSession.insert(NS + "insertFaq", vo);
    }

    @Override
    public void updateFaq(BoardVO vo) {
        sqlSession.update(NS + "updateFaq", vo);
    }

    @Override
    public void deleteFaq(int boardNo) {
        sqlSession.delete(NS + "deleteFaq", boardNo);
    }
}
