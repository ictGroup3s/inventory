package com.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.model.vo.BoardVO;
import com.example.service.BoardService;

/* 🔽 [추가] */
import com.example.model.vo.CustomerVO;
import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {

    @Autowired
    private BoardService service;

    /**
     * 게시판 목록 + 페이징
     */
    @GetMapping("/board")
    public String boardList(
            @RequestParam(defaultValue = "1") int page,
            Model model) {

        int pageSize = 10;                 // 한 페이지당 글 수
        int start = (page - 1) * pageSize + 1;
        int end = page * pageSize;

        int totalCount = service.getBoardCount();
        int totalPage = (int) Math.ceil(totalCount / (double) pageSize);

        model.addAttribute("list", service.getBoardListPaging(start, end));
        model.addAttribute("page", page);
        model.addAttribute("totalPage", totalPage);

        return "board";
    }

    /**
     * 게시글 상세보기
     */
    @GetMapping("/boardDetail")
    public String boardDetail(@RequestParam("id") int id, Model model) {
        model.addAttribute("board", service.getBoardDetail(id));
        return "boardDetail";
    }

    /**
     * 글쓰기 폼
     */
    @GetMapping("/boardWrite")
    public String writeForm() {
        return "boardWrite";
    }

    /**
     * 글 등록
     */
    @PostMapping("/boardWrite")
    public String write(BoardVO vo, HttpSession session) {

        // 추가한 부분
        CustomerVO loginUser = (CustomerVO) session.getAttribute("loginUser");
        if (loginUser != null) {
            vo.setCustomer_id(loginUser.getCustomer_id());
        }
       
        //

        System.out.println("boardcontroller: " + vo);
        service.insertBoard(vo);
        return "redirect:/board";
    }

    /**
     * 수정 폼
     */
    @GetMapping("/boardEdit")
    public String boardEdit(@RequestParam("id") int id, Model model) {
        model.addAttribute("board", service.getBoardDetail(id));
        return "boardEdit";
    }

    /**
     * 수정 처리
     */
    @PostMapping("/boardUpdate")
    public String boardUpdate(BoardVO vo) {
        service.updateBoard(vo);
        return "redirect:/boardDetail?id=" + vo.getBoard_no();
    }

    /**
     * 삭제
     */
    @GetMapping("/boardDelete")
    public String boardDelete(@RequestParam("id") int id) {
        service.deleteBoard(id);
        return "redirect:/board";
    }

    /**
     * FAQ 목록 + 페이징
     */
    @GetMapping("/faq")
    public String faqList(
            @RequestParam(defaultValue = "1") int page,
            Model model) {

        int pageSize = 10;
        int start = (page - 1) * pageSize + 1;
        int end = page * pageSize;

        int totalCount = service.getFaqCount();
        int totalPage = (int) Math.ceil(totalCount / (double) pageSize);

        model.addAttribute("list", service.getFaqListPaging(start, end));
        model.addAttribute("page", page);
        model.addAttribute("totalPage", totalPage);

        return "faq";
    }

    /**
     * FAQ 상세
     */
    @GetMapping("/faqDetail")
    public String faqDetail(
            @RequestParam("id") int id,
            @RequestParam(defaultValue = "1") int page,
            Model model) {

        model.addAttribute("board", service.getFaqDetail(id));
        model.addAttribute("page", page);
        return "faqDetail";
    }

    /**
     * FAQ 글쓰기 폼
     */
    @GetMapping("/faqWrite")
    public String faqWriteForm(@RequestParam(defaultValue = "1") int page, Model model) {
        model.addAttribute("page", page);
        return "faqWrite";
    }

    /**
     * FAQ 등록
     */
    @PostMapping("/faqWrite")
    public String faqWrite(BoardVO vo) {
        service.insertFaq(vo);
        return "redirect:/faq";
    }

    /**
     * FAQ 수정 폼
     */
    @GetMapping("/faqEdit")
    public String faqEdit(
            @RequestParam("id") int id,
            @RequestParam(defaultValue = "1") int page,
            Model model) {
        model.addAttribute("board", service.getFaqDetail(id));
        model.addAttribute("page", page);
        return "faqEdit";
    }

    /**
     * FAQ 수정 처리
     */
    @PostMapping("/faqUpdate")
    public String faqUpdate(BoardVO vo) {
        service.updateFaq(vo);
        return "redirect:/faq";
    }

    /**
     * FAQ 삭제
     */
    @GetMapping("/faqDelete")
    public String faqDelete(@RequestParam("id") int id) {
        service.deleteFaq(id);
        return "redirect:/faq";
    }
}
