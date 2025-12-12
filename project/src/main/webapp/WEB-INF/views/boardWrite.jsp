<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<h3 class="mb-4">공지사항 작성</h3>

<form action="/boardWrite" method="post">

    <div class="form-group">
        <label>제목:</label>
        <input type="text" name="title" class="form-control" required>
    </div>

    <div class="form-group">
        <label>내용:</label>
        <textarea name="b_content" class="form-control" rows="6" required></textarea>
    </div>

    <!-- 로그인 기능 대비 -->
    <input type="hidden" name="customer_id" value="admin">

    <button type="submit" class="btn btn-primary">등록</button>
    <a href="/board" class="btn btn-secondary">취소</a>

</form>