package com.example.service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.model.BoardRepository;
import com.example.model.vo.BoardVO;

@Service
public class BoardServiceImpl implements BoardService {

    @Autowired
    private BoardRepository repo;

 
    @Override
    public List<BoardVO> getBoardList() {
        return repo.getBoardList();
    }

    @Override
    public BoardVO getBoardDetail(int boardNo) {
        // 상세조회
        return repo.getBoardDetail(boardNo);
    }

    @Override
    public void insertBoard(BoardVO vo) {
        repo.insertBoard(vo);
    }
    
    @Override
    public void updateBoard(BoardVO vo) {
        repo.updateBoard(vo);
    }
    
    @Override
    public void deleteBoard(int boardNo) {
        repo.deleteBoard(boardNo);
    }

    // ================= 페이징 =================

  
    @Override
    public List<BoardVO> getBoardListPaging(Map<String, Object> param) {
        return repo.getBoardListPaging(param);
    }

    
    @Override
    public List<BoardVO> getBoardListPaging(int start, int end) {
        Map<String, Object> param = new HashMap<>();
        param.put("start", start);
        param.put("end", end);

        return repo.getBoardListPaging(param);
    }

    @Override
    public int getBoardCount() {
        return repo.getBoardCount();
    }


    
    // FAQ
    
    @Override
    public List<BoardVO> getFaqListPaging(int start, int end) {
        Map<String, Object> param = new HashMap<>();
        param.put("start", start);
        param.put("end", end);
        return repo.getFaqListPaging(param);
    }

    @Override
    public int getFaqCount() {
        return repo.getFaqCount();
    }

    @Override
    public BoardVO getFaqDetail(int boardNo) {
        return repo.getFaqDetail(boardNo);
    }

    @Override
    public void insertFaq(BoardVO vo) {
        repo.insertFaq(vo);
    }

    @Override
    public void updateFaq(BoardVO vo) {
        repo.updateFaq(vo);
    }

    @Override
    public void deleteFaq(int boardNo) {
        repo.deleteFaq(boardNo);
    }
}
