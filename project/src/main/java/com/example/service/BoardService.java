package com.example.service;

import java.util.List;
import java.util.Map;

import com.example.model.vo.BoardVO;

public interface BoardService {

   

    // 목록
    List<BoardVO> getBoardList();

    // 상세
    BoardVO getBoardDetail(int boardNo);

    // 글 등록
    void insertBoard(BoardVO vo);
    
    // 글 수정
    void updateBoard(BoardVO vo);
    
    // 글 삭제
    void deleteBoard(int boardNo);
    

    // ================= 페이징 =================

    
    List<BoardVO> getBoardListPaging(Map<String, Object> param);
    
    List<BoardVO> getBoardListPaging(int start, int end);
   
    int getBoardCount();


    
    // FAQ
     
    List<BoardVO> getFaqListPaging(int start, int end);
    int getFaqCount();
    BoardVO getFaqDetail(int boardNo);
    void insertFaq(BoardVO vo);
    void updateFaq(BoardVO vo);
    void deleteFaq(int boardNo);
}
