package com.example.service;

import java.util.List;

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
        // 🔥 상세조회 기능 구현 (없어서 오류났던 부분)
        return repo.getBoardDetail(boardNo);
    }

    @Override
    public void insertBoard(BoardVO vo) {
        repo.insertBoard(vo);
    }
}
