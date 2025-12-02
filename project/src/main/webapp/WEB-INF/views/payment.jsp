<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<body>
<h3>결제 진행중...</h3>
<p>결제 수단: <%= request.getParameter("payment") %></p>

<!-- 실제 결제 SDK 연동 혹은 결제 완료 후 처리 -->
</body>
</html>