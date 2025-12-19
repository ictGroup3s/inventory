<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>공지사항 게시판</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<!-- Favicon -->
<link href="img/favicon.ico" rel="icon">

<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

<!-- Bootstrap CSS -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom Styles -->
<link rel="stylesheet" href="css/style.css">

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
</head>

<body>

	<!-- Topbar -->
	<div class="row align-items-center py-3 px-xl-4" style="margin-left:70px;">
		<div class="col-lg-3 d-none d-lg-block">
			<a href="/" class="text-decoration-none"> <img src="img/logo.png"
				class="logo" />
			</a>
		</div>
			<div class="col-lg-6 col-6 text-left">
			<form action="selectall" method="get" style="margin-left:-20px; margin-right:90px;">
				<div class="input-group">
					<input type="text" name="q" class="form-control"
						placeholder="찾고 싶은 상품을 검색하세요." value="${q}">
					<div class="input-group-append">
						<button class="input-group-text bg-transparent text-primary" type="submit">
								<i class="fa fa-search"></i>
						</button>
					</div>
				</div>
			</form>
		</div>
		<div class="col-lg-3 col-6 text-right">
			<a href="cart" class="btn border"> <i
				class="fas fa-shopping-cart text-primary"></i> <span class="badge">0</span>
			</a>
		</div>
	</div>
	<div class="d-flex justify-content-end align-items-center gap-2"style="margin-right:50px;">
							<!-- 로그인전 -->
							<c:if test="${empty sessionScope.loginUser}">
								<a href="login" class="nav-item nav-link " style="color:black;">로그인</a>
								<a href="register" class="nav-item nav-link"style="color:black;">회원가입</a>
								<a href="board" class="nav-item nav-link"style="color:black;">고객센터</a>
							</c:if>
							
							<!-- 회원 로그인 후   -->
							<c:if test="${not empty sessionScope.loginUser}">
								<span class="nav-item nav-link">안녕하세요,
									${sessionScope.loginUser.name}님!</span>


								<c:if test="${sessionScope.loginRole == 0}">
									<a href="mypage" class="nav-item nav-link">마이페이지</a>
								</c:if>

								<c:if test="${sessionScope.loginRole == 1}">
									<a href="dashboard" class="nav-item nav-link">관리자 페이지</a>
								</c:if>
								<!-- 로그아웃 링크 -->
								<a href="logout" class="nav-item nav-link">로그아웃</a>

							</c:if>
						</div>
					</div>
	<!-- Main Layout -->
<div class="container-fluid">
<div class="row px-xl-5">
<div class="col-lg-2">
<!-- 사이드바 -->
<nav class="category-sidebar" style="margin-left:-50px;">
    <h6 class="p-3">고객센터</h6>
    <ul class="nav flex-column">
        <li class="nav-item"><a href="board" class="nav-link active" id="noticeLink">문의</a></li>

        <li class="nav-item">
    <a href="/board?tab=faq" class="nav-link" id="faqLink" onclick="loadFaqPage(1); return false;">자주 묻는 질문</a>
</li>

    </ul>
</nav>
</div>
<!-- 콘텐츠 -->
<div class="col-lg-10 dashboard-content pt-5">


<div id="contentArea">

<!-- 게시글 목록 -->
<div class="table-responsive mb-4">
<table class="table table-bordered text-center">
<thead class="thead-light">
<tr>
    <th style="width:80px;">번호</th>
    <th>제목</th>
    <th style="width:150px;">작성자</th>
    <th style="width:150px;">작성일</th>
</tr>
</thead>
<tbody>

<c:forEach var="b" items="${list}">
<tr>
    <td>${b.board_no}</td>
    <td>
        <a href="boardDetail?id=${b.board_no}">
            ${b.title}
        </a>
    </td>
    <td>${b.customer_id}</td>
    <td>${b.b_date}</td>
</tr>
</c:forEach>

<c:if test="${empty list}">
<tr>
    <td colspan="4">등록된 공지사항이 없습니다.</td>
</tr>
</c:if>

</tbody>
</table>
</div>

<!-- 글쓰기 -->
<div class="text-right mb-3">
    <button class="btn btn-primary" onclick="showWriteForm()">글쓰기</button>
</div>

<!-- 🔥 페이징 영역 (위치만 이동 + 스타일 추가) -->
<div class="text-center mt-4">
    <c:if test="${page > 1}">
        <a class="btn btn-outline-secondary btn-sm" href="/board?page=1">&laquo;</a>
        <a class="btn btn-outline-secondary btn-sm" href="/board?page=${page-1}">&lsaquo;</a>
    </c:if>

    <span class="mx-2 font-weight-bold">
        ${page} / ${totalPage}
    </span>

    <c:if test="${page < totalPage}">
        <a class="btn btn-outline-secondary btn-sm" href="/board?page=${page+1}">&rsaquo;</a>
        <a class="btn btn-outline-secondary btn-sm" href="/board?page=${totalPage}">&raquo;</a>
    </c:if>
</div>


</div>
</div>
</div>
</div>



<!-- JS -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>

<script>
function showWriteForm(){
    $("#contentArea").load("<%=request.getContextPath()%>/boardWrite");
}


// FAQ AJAX 로딩
   

function setActiveMenu(isFaq){
    if(isFaq){
        $("#noticeLink").removeClass("active");
        $("#faqLink").addClass("active");
    }else{
        $("#faqLink").removeClass("active");
        $("#noticeLink").addClass("active");
    }
}

function loadFaqPage(page){
    setActiveMenu(true);
    $("#contentArea").load("<%=request.getContextPath()%>/faq?page=" + page);
}

function showFaqWriteForm(page){
    setActiveMenu(true);
    $("#contentArea").load("<%=request.getContextPath()%>/faqWrite?page=" + page);
}

function loadFaqDetail(id, page){
    setActiveMenu(true);
    $("#contentArea").load("<%=request.getContextPath()%>/faqDetail?id=" + id + "&page=" + page);
}

function loadFaqEdit(id, page){
    setActiveMenu(true);
    $("#contentArea").load("<%=request.getContextPath()%>/faqEdit?id=" + id + "&page=" + page);
}

function deleteFaq(id, page){
    if(!confirm("삭제하시겠습니까?")) return;
    setActiveMenu(true);
    // 삭제 후 목록으로 자동 복귀
    $("#contentArea").load("<%=request.getContextPath()%>/faqDelete?id=" + id + "&page=" + page);
}


//  URL 파라미터로 FAQ 탭 자동 오픈
  
$(function(){
    var params = new URLSearchParams(window.location.search);
    if(params.get("tab") === "faq"){
        loadFaqPage(1);
    }
});

</script>


</body>
</html>