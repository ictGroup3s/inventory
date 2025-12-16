<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>주문내역</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">

	<!-- Main Layout -->
	<div class="container-fluid">
		<div class="row px-xl-5">
			<!-- Sidebar -->
			<div class="col-lg-2">
				<nav class="category-sidebar">
					<h6>마이페이지</h6>
					<ul class="nav flex-column">
						<li class="nav-item"><a href="/orderhistory" class="nav-link active">주문내역</a></li>
						<li class="nav-item"><a href="/mydelivery" class="nav-link">배송내역</a></li>
						<li class="nav-item"><a href="/mycs" class="nav-link">취소/반품/교환내역</a></li>
						<li class="nav-item"><a href="/update" class="nav-link">내정보수정</a></li>
						<li class="nav-item"><a href="/delete" class="nav-link">회원탈퇴</a></li>
					</ul>
				</nav>
			</div>

			<!-- Main Content -->
			<div class="col-lg-10" style="margin-top: -30px; margin-bottom: 50px;">
				<div class="text-center mb-4">
					<h4 style="margin-top:50px;">주문내역</h4>
				</div>

				<div class="col-lg-10 mx-auto">
					<table class="table table-striped">
						<thead>
							<tr>
								<th>주문번호</th>
								<th>상품명</th>
								<th>결제금액</th>
								<th>주문상태</th>
								<th>주문일시</th>
							</tr>
						</thead>
						<tbody>
						<c:choose>
								<c:when test="${empty deliveryList}">
									<tr>
										<td colspan="5" class="text-center">주문 내역이 없습니다.</td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:forEach var="detail" items="${deliveryList}">
										<tr>
											<td>${detail.order_no}</td>
											<td>${detail.item_name}</td>
											<td><fmt:formatNumber value="${detail.item_price}" pattern="#,###"/>원</td>
											<td>${detail.order_status}</td>
											<td>${detail.order_date}</td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

			
</body>
</html>