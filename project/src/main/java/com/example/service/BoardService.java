package com.example.service;

import java.util.List;

import com.example.model.vo.BoardVO;

public interface BoardService {

    // 목록
    List<BoardVO> getBoardList();

    // 상세
    BoardVO getBoardDetail(int boardNo);

    // 글 등록
    void insertBoard(BoardVO vo);
}