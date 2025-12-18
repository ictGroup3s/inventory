package com.example.model;

import java.util.List;
import java.util.Map;   // 🔥 페이징 파라미터용 (필수)

import com.example.model.vo.BoardVO;

public interface BoardRepository {
	
	// =====================
	// 기존 목록
	// =====================
    List<BoardVO> getBoardList();

    // =====================
    // 상세 조회
    // =====================
    BoardVO getBoardDetail(int boardNo);

    // =====================
    // 글 등록
    // =====================
    void insertBoard(BoardVO vo);
    
    // =====================
    // 글 수정
    // =====================
    void updateBoard(BoardVO vo);

    // =====================
    // 글 삭제
    // =====================
    void deleteBoard(int boardNo);
    
    // =====================
    // 페이징 목록 조회
    // start / end 전달
    // =====================
    List<BoardVO> getBoardListPaging(Map<String, Object> param);

    // =====================
    // 전체 게시글 수
    // =====================
    int getBoardCount();


    // =========================================
    // FAQ  
    // =========================================
    List<BoardVO> getFaqListPaging(Map<String, Object> param);
    int getFaqCount();
    BoardVO getFaqDetail(int boardNo);
    void insertFaq(BoardVO vo);
    void updateFaq(BoardVO vo);
    void deleteFaq(int boardNo);
}
