<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>취소/반품/교환내역</title>
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
						<li class="nav-item"><a href="/mydelivery" class="nav-link">배송내역</a></li>
						<li class="nav-item"><a href="/mycs" class="nav-link active">취소·반품·교환내역</a></li>
						<li class="nav-item"><a href="/update" class="nav-link">내정보수정</a></li>
						<li class="nav-item"><a href="/delete" class="nav-link">회원탈퇴</a></li>
					</ul>
				</nav>
			</div>

			<!-- Main Content -->
			<div class="col-lg-10" style="margin-top: 30px; margin-bottom: 50px;">
				<div class="text-center mb-4">
					<h4>취소·반품·교환내역</h4>
					<button class="btn btn-primary" style="margin-left: 850px;"
						data-toggle="modal" data-target="#crApplyModal">
						취소·반품·교환신청</button>
				</div>

				<!-- 메시지 표시 -->
				<c:if test="${not empty message}">
					<div
						class="alert alert-${messageType == 'success' ? 'success' : 'danger'} alert-dismissible fade show"
						role="alert">
						${message}
						<button type="button" class="close" data-dismiss="alert">&times;</button>
					</div>
				</c:if>

				<div class="col-lg-10 mx-auto">
					<table class="table table-striped">
						<thead>
							<tr>
								<th>주문번호</th>
								<th>상품명</th>
								<th>신청유형</th>
								<th>상태</th>
								<th>신청일</th>
								<th></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="cr" items="${crList}">
								<tr>
									<td>${cr.order_no}</td>
									<td>${cr.item_name}</td>
									<td>${cr.type}</td>
									<td>${cr.status}</td>
									<td><fmt:formatDate value="${cr.re_date}"
											pattern="yyyy-MM-dd HH:mm" /></td>
									<td>
										<button class="btn btn-sm btn-secondary" data-toggle="modal"
											data-target="#detailModal_${cr.cr_no}">상세보기</button>
									</td>
								</tr>
							</c:forEach>

							<c:if test="${empty crList}">
								<tr>
									<td colspan="6" class="text-center">취소·반품·교환 신청 내역이 없습니다.</td>
								</tr>
							</c:if>
							<c:choose>
								<c:when test="${order.item_cnt > 1}">
									<button class="btn btn-secondary" disabled>부분 취소 불가
										(채팅 문의)</button>
									<a href="/chat/admin" class="btn btn-outline-danger"> 관리자
										문의 </a>
								</c:when>
							</c:choose>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 취소/반품/교환 신청 모달 -->
	<div class="modal fade" id="crApplyModal" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<form action="/mycs/apply" method="post" id="crApplyForm">
					<div class="modal-header">
						<h5 class="modal-title">취소·반품·교환 신청</h5>
						<button type="button" class="close" data-dismiss="modal">
							<span>&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<!-- 주문번호 입력 -->
						<div class="form-group">
							<label><h6>주문번호 <span class="text-danger">*</span></h6></label>
							<select name="order_no" id="order_no" class="form-control"
								required>
								<option value="">주문번호를 선택하세요</option>

								<c:forEach var="order" items="${orderList}">
									<option value="${order}">주문번호 ${order}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group">
							<label>상품번호</label> 
							<select name="return_cnt" id="return_cnt" class="form-control">
								<option value="">상품을 선택하세요</option>
							</select>
						</div>
						<!-- 신청 유형 -->
						<div class="form-group">
							<label>신청 유형 <span class="text-danger">*</span></label>
							<select name="type" id="type" class="form-control" required>
								<option value="">선택하세요</option>
								<option value="취소">취소</option>
								<option value="반품">반품</option>
								<option value="교환">교환</option>
							</select>
						</div>

						<!-- 사유 -->
						<div class="form-group">
							<label>사유 <span class="text-danger">*</span></label>
							<textarea name="reason"
									  id="reason"
									  class="form-control"
									  rows="4"
									  placeholder="사유를 입력해주세요"
									  required></textarea>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
						<button type="submit" class="btn btn-primary">신청하기</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- 상세보기 모달 (각 항목별) -->
	<c:forEach var="cr" items="${crList}">
		<div class="modal fade" id="detailModal_${cr.cr_no}" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">취소·반품·교환 상세내역</h5>
						<button type="button" class="close" data-dismiss="modal">
							<span>&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="row mb-3">
							<div class="col-md-6">
								<strong>신청번호:</strong> ${cr.cr_no}
							</div>
							<div class="col-md-6">
								<strong>주문번호:</strong> ${cr.order_no}
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-6">
								<strong>신청유형:</strong> ${cr.type}
							</div>
							<div class="col-md-6">
								<strong>상태:</strong> ${cr.status}
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-12">
								<strong>신청일:</strong> <fmt:formatDate value="${cr.re_date}" pattern="yyyy-MM-dd HH:mm:ss" />
							</div>
						</div>
						<c:if test="${not empty cr.return_cnt}">
							<div class="row mb-3">
								<div class="col-md-12">
									<strong>교환 상품번호:</strong> ${cr.return_cnt}
								</div>
							</div>
						</c:if>
						<hr>
						<div class="row mb-3">
							<div class="col-md-12">
								<strong>사유:</strong>
								<p class="mt-2">${cr.reason}</p>
							</div>
						</div>
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