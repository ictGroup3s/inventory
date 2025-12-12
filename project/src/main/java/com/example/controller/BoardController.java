package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.model.vo.BoardVO;
import com.example.service.BoardService;

@Controller
public class BoardController {

    @Autowired
    private BoardService service;

    /** 게시판 목록 */
    @GetMapping("/board")
    public String boardList(Model model) {
        model.addAttribute("list", service.getBoardList());
        return "board"; 
    }

    /** 게시글 상세보기 */
    @GetMapping("/boardDetail")
    public String boardDetail(@RequestParam("id") int id, Model model) {
        model.addAttribute("board", service.getBoardDetail(id));
        return "boardDetail"; 
    }

    /** 글쓰기 폼 */
    @GetMapping("/boardWrite")
    public String writeForm() {
        return "boardWrite";
    }

    /** 글 등록 */
    @PostMapping("/boardWrite")
    public String write(BoardVO vo) {
        service.insertBoard(vo);
        return "redirect:/board";   // 🔥 등록 후 목록으로 이동
    }
}
