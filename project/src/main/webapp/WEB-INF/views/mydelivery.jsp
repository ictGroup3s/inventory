<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>배송내역</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">

	<!-- Main Layout -->
	<div class="container-fluid">
		<div class="row px-xl-5">
			<div class="col-lg-2">
				<!-- Sidebar -->
				<nav class="category-sidebar">
					<h6>마이페이지</h6>
					<ul class="nav flex-column">
						<li class="nav-item"><a href="/orderhistory" class="nav-link">주문내역</a></li>
						<li class="nav-item"><a href="/mydelivery" class="nav-link active">배송내역</a></li>
						<li class="nav-item"><a href="/mycs" class="nav-link">취소·반품·교환내역</a></li>
						<li class="nav-item"><a href="/update" class="nav-link">내정보수정</a></li>
						<li class="nav-item"><a href="/delete" class="nav-link">회원탈퇴</a></li>
					</ul>
				</nav>
			</div>
		
			<!-- Main Content -->
			<div class="col-lg-10" style="margin-top: -30px; margin-bottom: 50px;">
				<div class="text-center mb-4">
					<h4 style="margin-top:50px;">배송내역</h4>
				</div>
				
				<div class="col-lg-10 mx-auto">
					<c:choose>
						<c:when test="${empty deliveryList}">
							<p class="text-center">배송 내역이 없습니다.</p>
						</c:when>
						<c:otherwise>
							<table class="table table-striped">
								<thead>
									<tr>
										<th>주문번호</th>
										<th>주문일시</th>
										<th>상품명</th>
										<th>총 금액</th>
										<th>배송상태</th>
										<th></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="order" items="${deliveryList}">
										<tr>
											<td>${order.order_no}</td>
											<td>${order.order_date}</td>
											<td>
												<!-- ⭐⭐⭐ 첫 번째 상품만 표시 -->
												<c:if test="${not empty order.detailList}">
													${order.detailList[0].item_name}
													<!-- 2개 이상이면 "외 N개" 표시 -->
													<c:if test="${fn:length(order.detailList) > 1}">
														<span class="text-muted"> 외 ${fn:length(order.detailList) - 1}개</span>
													</c:if>
												</c:if>
											</td>
											<td><fmt:formatNumber value="${order.total_amount}" pattern="#,###"/>원</td>
											<td>
												<c:choose>
													<c:when test="${order.order_status == '배송준비중'}">
														<span class="badge badge-warning" style="background-color:#FFF3E0; color: #E65100;">배송준비중</span>
													</c:when>
													<c:when test="${order.order_status == '배송중'}">
														<span class="badge badge-info" style="background-color:#EDF1FF; color: #1565C0;">배송중</span>
													</c:when>
													<c:when test="${order.order_status == '배송완료'}">
														<span class="badge badge-success" style="background-color:#E8F5E9; color: #2E7D32;">배송완료</span>
													</c:when>
													<c:otherwise>
														<span class="badge badge-secondary">${order.order_status}</span>
													</c:otherwise>
												</c:choose>
											</td>
											<td>
												<button class="btn btn-sm btn-secondary" 
												        data-toggle="modal" 
												        data-target="#detailModal_${order.order_no}">
													상세보기
												</button>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</div>

	<!-- ⭐⭐⭐ 배송 상세 모달 - 모든 상품 표시 -->
	<c:forEach var="order" items="${orderList}">
		<div class="modal fade" id="detailModal_${order.order_no}" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">배송 상세내역</h5>
						<button type="button" class="close" data-dismiss="modal">
							<span>&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="row mb-3">
							<div class="col-md-6">
								<strong>주문번호:</strong> ${order.order_no}
							</div>
							<div class="col-md-6">
								<strong>주문일:</strong> ${order.order_date}
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-12">
								<strong>배송상태:</strong>
								<c:choose>
									<c:when test="${order.delivery_status == '배송준비중'}">
										<span class="badge badge-warning" style="background-color:#FFF3E0; color: #E65100;">배송준비중</span>
									</c:when>
									<c:when test="${order.delivery_status == '배송중'}">
														<span class="badge badge-info" style="background-color:#EDF1FF; color: #1565C0;">배송중</span>
									</c:when>
									<c:when test="${order.delivery_status == '배송완료'}">
										<span class="badge badge-success" style="background-color:#E8F5E9; color: #2E7D32;">배송완료</span>
									</c:when>
									<c:otherwise>
										<span class="badge badge-secondary">${order.delivery_status}</span>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
						<hr>
						<h6><strong>주문 상품</strong></h6>
						<table class="table table-bordered">
							<thead>
								<tr>
									<th>상품명</th>
									<th>수량</th>
									<th>금액</th>
								</tr>
							</thead>
							<tbody>
								<!-- ⭐⭐⭐ 모든 상품 표시 (단가 제외) -->
								<c:forEach var="detail" items="${order.detailList}">
									<tr>
										<td>${detail.item_name}</td>
										<td>${detail.item_cnt}개</td>
										<td><fmt:formatNumber value="${detail.amount}" pattern="#,###"/>원</td>
									</tr>
								</c:forEach>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="2" class="text-right"><strong>총 결제금액:</strong></td>
									<td><strong><fmt:formatNumber value="${order.total_amount}" pattern="#,###"/>원</strong></td>
								</tr>
							</tfoot>
						</table>
						<hr>
						<h6><strong>배송 추적</strong></h6>
						<ul class="mt-2">
							<li>${order.order_date}: 주문 접수</li>
							<c:choose>
								<c:when test="${order.delivery_status == '배송준비중'}">
									<li>현재: 상품 준비중</li>
								</c:when>
								<c:when test="${order.delivery_status == '배송중'}">
									<li>배송 시작됨</li>
									<li>배송 예정일: 1-2일 이내</li>
								</c:when>
								<c:when test="${order.delivery_status == '배송완료'}">
									<li>배송 완료</li>
								</c:when>
							</c:choose>
						</ul>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
					</div>
				</div>
			</div>
		</div>
	</c:forEach>

</body>
</html>