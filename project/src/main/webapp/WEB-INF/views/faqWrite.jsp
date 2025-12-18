<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<h3 class="mb-4">FAQ 작성</h3>

<form action="/faqWrite" method="post">

    <div class="form-group">
        <label>카테고리:</label>
        <select name="faq_category" class="form-control" required>
            <option value="">선택</option>
            <option value="배송문의">배송문의</option>
            <option value="취소/반품">취소/반품</option>
            <option value="결제/영수증">결제/영수증</option>
            <option value="회원/계정">회원/계정</option>
            <option value="상품/재고">상품/재고</option>
        </select>
    </div>

    <div class="form-group">
        <label>질문(제목):</label>
        <input type="text" name="title" class="form-control" required>
    </div>

    <div class="form-group">
        <label>답변(내용):</label>
        <textarea name="b_content" class="form-control" rows="6" required></textarea>
    </div>

    <!-- 로그인 기능 대비 -->
    <input type="hidden" name="customer_id" value="admin">

    <button type="submit" class="btn btn-primary">등록</button>
    <button type="button" class="btn btn-secondary" onclick="loadFaqPage(${page}); return false;">취소</button>

</form>
