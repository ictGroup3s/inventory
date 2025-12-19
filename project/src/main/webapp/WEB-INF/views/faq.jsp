<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<h3 class="mb-4">자주 묻는 질문(FAQ)</h3>

<!-- 카테고리 안내 -->
<div class="alert alert-light border mb-4">
	<strong>안내:</strong> 질문을 클릭하면 답변이 펼쳐집니다.
</div>

<!-- FAQ 목록 -->
<div class="accordion" id="faqAccordion">

	<c:forEach var="b" items="${list}" varStatus="st">
		<div class="card mb-2">
			<div class="card-header" id="heading${b.board_no}">
				<h6 class="mb-0 d-flex justify-content-between align-items-center">
					<button class="btn btn-link text-left" type="button"
						data-toggle="collapse" data-target="#collapse${b.board_no}"
						aria-expanded="false" aria-controls="collapse${b.board_no}">
						<span class="badge badge-primary mr-2">${b.faq_category}</span> Q.
						${b.title}
					</button>
					<c:if test="${sessionScope.loginRole == 1}">
						<div>
							<!-- 상세/수정/삭제는 '관리용' 버튼 -->
							<button class="btn btn-outline-secondary btn-sm"
								onclick="loadFaqDetail(${b.board_no}, ${page}); return false;">
								상세</button>
							<button class="btn btn-outline-primary btn-sm"
								onclick="loadFaqEdit(${b.board_no}, ${page}); return false;">
								수정</button>
							<button class="btn btn-outline-danger btn-sm"
								onclick="deleteFaq(${b.board_no}, ${page}); return false;">
								삭제</button>
						</div>
					</c:if>
				</h6>
			</div>

			<div id="collapse${b.board_no}" class="collapse"
				aria-labelledby="heading${b.board_no}" data-parent="#faqAccordion">
				<div class="card-body">
					<p class="mb-0">${b.b_content}</p>
					<div class="text-right mt-3">
						<small class="text-muted">등록일: ${b.b_date}</small>
					</div>
				</div>
			</div>
		</div>
	</c:forEach>

	<c:if test="${empty list}">
		<div class="alert alert-warning">등록된 FAQ가 없습니다.</div>
	</c:if>

</div>

<!-- 글쓰기 -->
<div class="text-right mb-3 mt-4">
	<c:if test="${sessionScope.loginRole == 1}">
		<button class="btn btn-primary"
			onclick="showFaqWriteForm(${page}); return false;">글쓰기</button>
	</c:if>
</div>

<!-- 페이징 -->
<div class="text-center mt-4">
	<c:if test="${page > 1}">
		<a class="btn btn-outline-secondary btn-sm" href="#"
			onclick="loadFaqPage(1); return false;">&laquo;</a>
		<a class="btn btn-outline-secondary btn-sm" href="#"
			onclick="loadFaqPage(${page-1}); return false;">&lsaquo;</a>
	</c:if>

	<span class="mx-2 font-weight-bold"> ${page} / ${totalPage} </span>

	<c:if test="${page < totalPage}">
		<a class="btn btn-outline-secondary btn-sm" href="#"
			onclick="loadFaqPage(${page+1}); return false;">&rsaquo;</a>
		<a class="btn btn-outline-secondary btn-sm" href="#"
			onclick="loadFaqPage(${totalPage}); return false;">&raquo;</a>
	</c:if>
</div>
