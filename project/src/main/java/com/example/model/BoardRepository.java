package com.example.model;

import java.util.List;

import com.example.model.vo.BoardVO;

public interface BoardRepository {

    List<BoardVO> getBoardList();

    BoardVO getBoardDetail(int boardNo);

    void insertBoard(BoardVO vo);
}
