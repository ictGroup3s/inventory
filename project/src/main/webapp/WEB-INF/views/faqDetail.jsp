<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<h3 class="mb-4">FAQ 상세보기</h3>

<table class="table table-bordered">
    <tr>
        <th style="width:150px;">번호</th>
        <td>${board.board_no}</td>
    </tr>
    <tr>
        <th style="width:150px;">카테고리</th>
        <td>${board.faq_category}</td>
    </tr>
    <tr>
        <th>질문(제목)</th>
        <td>${board.title}</td>
    </tr>
    <tr>
        <th>답변(내용)</th>
        <td style="height:200px;">${board.b_content}</td>
    </tr>
    <tr>
        <th>작성자</th>
        <td>${board.customer_id}</td>
    </tr>
    <tr>
        <th>작성일</th>
        <td>${board.b_date}</td>
    </tr>
</table>

<div class="text-right">
    <button class="btn btn-secondary" onclick="loadFaqPage(${page}); return false;">목록으로</button>
    <button class="btn btn-primary" onclick="loadFaqEdit(${board.board_no}, ${page}); return false;">수정</button>
    <button class="btn btn-danger" onclick="deleteFaq(${board.board_no}, ${page}); return false;">삭제</button>
</div>
