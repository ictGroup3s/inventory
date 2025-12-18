<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<h3 class="mb-4">FAQ 수정</h3>

<form action="/faqUpdate" method="post">

    <!-- PK 전달 -->
    <input type="hidden" name="board_no" value="${board.board_no}">
    <input type="hidden" name="customer_id" value="${board.customer_id}">

    <div class="form-group">
        <label>카테고리:</label>
        <select name="faq_category" class="form-control" required>
            <option value="">선택</option>
            <option value="배송문의" <%= "" %>>배송문의</option>
            <option value="취소/반품" <%= "" %>>취소/반품</option>
            <option value="결제/영수증" <%= "" %>>결제/영수증</option>
            <option value="회원/계정" <%= "" %>>회원/계정</option>
            <option value="상품/재고" <%= "" %>>상품/재고</option>
        </select>
    </div>

    <script>
        // JSP에서 선택값 세팅  
        (function(){
            var v = "${board.faq_category}";
            if(v){
                document.addEventListener("DOMContentLoaded", function(){
                    var sel = document.querySelector("select[name='faq_category']");
                    if(sel) sel.value = v;
                });
            }
        })();
    </script>

    <div class="form-group">
        <label>질문(제목):</label>
        <input type="text" name="title" class="form-control" value="${board.title}" required>
    </div>

    <div class="form-group">
        <label>답변(내용):</label>
        <textarea name="b_content" class="form-control" rows="6" required>${board.b_content}</textarea>
    </div>

    <div class="text-right">
        <button type="button" class="btn btn-secondary" onclick="loadFaqDetail(${board.board_no}, ${page}); return false;">취소</button>
        <button type="submit" class="btn btn-primary">수정 완료</button>
    </div>

</form>
