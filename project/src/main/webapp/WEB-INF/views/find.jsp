<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디/비밀번호 찾기</title>
</head>
<body>
<div class="container mt-5">
<h3>아이디/비밀번호 찾기</h3>

<!-- 아이디 찾기 -->
<form action="find" method="post" class="mb-3">
	<input type="hidden" name="action" value="findId">
	<input type="text" name="name" placeholder="이름" value="${name}" required class="form-control mb-2">
	<input type="text" name="phone" placeholder="핸드폰번호" value="${phone}" required class="form-control mb-2">
	<button type="submit" class="btn btn-primary">아이디 찾기</button>

</form>
<!-- 비밀번호 찾기 -->
<form action="find" method="post">
    <input type="hidden" name="action" value="findPw">
    <input type="text" name="id" placeholder="아이디" value="${id}" required class="form-control mb-2">
    <input type="text" name="phone" placeholder="핸드폰번호" value="${action eq 'findPw' ? phone : ''}" required class="form-control mb-2">
    <button type="submit" class="btn btn-warning">임시 비밀번호 발급</button>
</form>

<c:if test="${not empty findId}">
  <p>${findId}</p>
</c:if>
<c:if test="${not empty tempPwd}">
  <p>${tempPwd}</p>
</c:if>
<c:if test="${not empty error}">
  <p style="color:red">${error}</p>
</c:if>

</div>
</body>
</html>