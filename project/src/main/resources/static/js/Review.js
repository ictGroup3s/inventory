$(function(){
	
	var reviewSection = $('#review-section');
	var reviewList = $('#review-list'); // 변수 상단으로 이동 (중복 제거)
	var item_no = reviewSection.data('item-no');
	var loginUser = reviewSection.data('login-user');

	// '리뷰' 탭이 보여질 때 리뷰를 로드
	$(document).on('shown.bs.tab', 'a[href="#tab-pane-3"]', function() {
		loadReviews();
	});

    // 페이지 로드 시 바로 리뷰 로드 (상단 평점/개수 표시를 위해)
    loadReviews();

	var allReviews = [];
	var currentPage = 1;
	var itemsPerPage = 5;

    // [공통 함수] 별점(하트) 상태 업데이트
    function updateStarState($elements, value) {
        $elements.each(function() {
            var starValue = $(this).data('value');
            if (starValue <= value) {
                $(this).removeClass('far').addClass('fas'); // 꽉 찬 하트
            } else {
                $(this).removeClass('fas').addClass('far'); // 빈 하트
            }
        });
    }

    // 평점 선택 (메인 작성 폼)
    $(document).on('click', '.rating-heart', function() {
        var value = $(this).data('value');
        $('#rating').val(value);
        updateStarState($('.rating-heart'), value);
    });

    // 평점 선택 (수정 폼)
    $(document).on('click', '.edit-rating-heart', function() {
        var value = $(this).data('value');
        var container = $(this).closest('.edit-rating-container');
        container.find('.edit-rating-input').val(value);
        updateStarState(container.find('.edit-rating-heart'), value);
    });

	function loadReviews() {
		reviewList.html('<p>리뷰를 불러오는중...</p>');

		$.ajax({
			url: '/review/list',
			type: 'GET',
			dataType: 'json',
			data: { item_no: item_no },
			success: function(reviews) {				
				if (!reviews || reviews.length === 0) {
                    $('#review-summary').text('(0개)');
                    $('#product-rating-summary').html('<i class="far fa-heart" style="color: #D19C97;"></i> 0.0 (0개 리뷰)');
					reviewList.html('<p>등록된 리뷰가 없습니다.</p>');
					$('#review-pagination').empty();
					return;
                }
				allReviews = reviews;

                // 평균 평점 계산
                var totalRating = 0;
                var count = 0;
                reviews.forEach(function(r) {
                    if(r.rating) {
                        totalRating += r.rating;
                        count++;
                    }
                });
                var avg = count > 0 ? (totalRating / count).toFixed(1) : 0;
                var summaryHtml = '<i class="fas fa-heart" style="color: #D19C97;"></i> ' + avg + ' / ' + reviews.length + '개';
                
                $('#review-summary').html(summaryHtml);
                $('#product-rating-summary').html('<i class="fas fa-heart" style="color: #D19C97;"></i> ' + avg + ' (' + reviews.length + '개 리뷰)');

				renderReviews(1);
			},
			error: function(err) {				
				reviewList.html('<p>리뷰를 불러올 수 없습니다.</p>');
			}
		});
	}

// 		리뷰 페이지 이동 	
	function renderReviews(page) {
		currentPage = page;
		var start = (page - 1) * itemsPerPage;
		var end = start + itemsPerPage;
		var slicedReviews = allReviews.slice(start, end);
		
		reviewList.empty();
		
		// 리뷰 항목 생성
		slicedReviews.forEach(function(r) {
            var ratingHtml = '';
            var rating = r.rating || 5; // 기본값 5
            for(var i=1; i<=5; i++) {
                if(i <= rating) {
                    ratingHtml += '<i class="fas fa-heart" style="color: #D19C97;"></i>';
                } else {
                    ratingHtml += '<i class="far fa-heart" style="color: #D19C97;"></i>';
                }
            }

			var html = '<div class="mb-3 border-bottom pb-2" id="review-' + r.review_no + '">'
				+ '<div class="d-flex justify-content-between align-items-center">'
				+ '<div>'
                + '<h6>' + r.customer_id + ' <small><i>' + r.re_date + '</i></small></h6>'
                + '<div class="mb-1">' + ratingHtml + '</div>'
                + '</div>';
			
			// 로그인한 유저 본인의 리뷰일 경우 수정/삭제 버튼 표시
			if (loginUser && String(loginUser) === String(r.customer_id)) {
				html += '<div>'
					+ '<button class="btn btn-sm btn-outline-primary mr-1 edit-review-btn" data-id="' 
					+ r.review_no 
					+ '">수정</button>'
					+ '<button class="btn btn-sm btn-outline-danger delete-review-btn" data-id="' 
					+ r.review_no 
					+ '">삭제</button>'
					+ '</div>';
			}
			
			html += '</div>'
				+ '<p class="review-content">' + r.re_content + '</p>'
				+ '</div>';
			reviewList.append(html);
		});

		renderPagination();
	}

	// 리뷰 삭제 버튼 클릭
	$(document).on('click', '.delete-review-btn', function() {
		if (!confirm('정말 삭제하시겠습니까?')) return;
		var reviewNo = $(this).data('id');
		
		$.ajax({
			url: '/review/delete',
			type: 'POST',
			data: { review_no: reviewNo },
			success: function(res) {
				alert('삭제되었습니다.');
				loadReviews();
			},
			error: function(err) {
				alert('삭제 실패');
			}
		});
	});

	// 리뷰 수정 버튼 클릭시 수정폼으로 전환
	$(document).on('click', '.edit-review-btn', function() {
		var reviewNo = $(this).data('id');
        // 현재 리뷰 데이터 찾기
        var reviewData = allReviews.find(function(r) { return r.review_no == reviewNo; });
        var currentRating = reviewData ? (reviewData.rating || 5) : 5;

		var reviewDiv = $('#review-' + reviewNo);
		var contentP = reviewDiv.find('.review-content');
		var originalContent = contentP.text();

        // 수정용 별점 HTML 생성
        var starsHtml = '<div class="mb-2 edit-rating-container">';
        for(var i=1; i<=5; i++) {
            var starClass = (i <= currentRating) ? 'fas' : 'far';
            starsHtml += '<i class="'+starClass+' fa-heart fa-lg edit-rating-heart mr-1" data-value="'
					+ i+'" style="cursor:pointer; color: #D19C97;"></i>';
        }
        starsHtml += '<input type="hidden" class="edit-rating-input" value="'+currentRating+'"></div>';

		var editHtml = '<div class="edit-form">'
            + starsHtml
			+ '<textarea class="form-control mb-2 edit-textarea" rows="3">' 
			+ originalContent 
			+ '</textarea>'
			+ '<div class="text-right">'
			+ '<button class="btn btn-sm btn-primary save-edit-btn" data-id="' 
			+ reviewNo 
			+ '">저장</button> '
			+ '<button class="btn btn-sm btn-secondary cancel-edit-btn">취소</button>'
			+ '</div>'
			+ '</div>';
		
		contentP.hide();
        reviewDiv.find('.mb-1').hide(); // 기존 별점 숨기기
		reviewDiv.append(editHtml);
		$(this).prop('disabled', true); // 수정 버튼 비활성화
	});

	// 수정 취소
	$(document).on('click', '.cancel-edit-btn', function() {
		var reviewDiv = $(this).closest('.mb-3');
		reviewDiv.find('.edit-form').remove();
		reviewDiv.find('.review-content').show();
        reviewDiv.find('.mb-1').show(); // 기존 별점 보이기
		reviewDiv.find('.edit-review-btn').prop('disabled', false);
	});

	// 수정 저장
	$(document).on('click', '.save-edit-btn', function() {
		var reviewNo = $(this).data('id');
		var reviewDiv = $(this).closest('.mb-3');
		var newContent = reviewDiv.find('.edit-textarea').val();
        var newRating = reviewDiv.find('.edit-rating-input').val();

		$.ajax({
			url: '/review/update',
			type: 'POST',
			contentType: 'application/json',
			data: JSON.stringify({ review_no: reviewNo, re_content: newContent, rating: newRating }),
			success: function(res) {
				alert('수정되었습니다.');
				loadReviews();
			},
			error: function(err) {
				alert('수정 실패');
			}
		});
	});

//	페이지 버튼 생성 (위에 설정된 리뷰개수 5개 초과시) ---
	function renderPagination() {
		var totalPages = Math.ceil(allReviews.length / itemsPerPage);
		var pagination = $('#review-pagination');
		pagination.empty();

		if (totalPages <= 1) return;

		var ul = $('<ul class="pagination mb-0"></ul>');
		
		// 이전으로
		var prevClass = currentPage === 1 ? 'disabled' : '';
		ul.append('<li class="page-item ' + prevClass + '"><a class="page-link" href="#" data-page="' 
			+ (currentPage - 1) + '">이전</a></li>');

		// 페이지 번호
		for (var i = 1; i <= totalPages; i++) {
			var activeClass = i === currentPage ? 'active' : '';
			ul.append('<li class="page-item ' + activeClass 
				+ '"><a class="page-link" href="#" data-page="' 
				+ i + '">' 
				+ i + '</a></li>');
		}

		// 다음페이지로
		var nextClass = currentPage === totalPages ? 'disabled' : '';
		ul.append('<li class="page-item ' + nextClass + '"><a class="page-link" href="#" data-page="' 
			+ (currentPage + 1) + '">다음</a></li>');

		pagination.append(ul);
	}

	// 리뷰 페이지 이동 버튼 클릭
	$(document).on('click', '#review-pagination .page-link', function(e) {
		e.preventDefault();
		var page = $(this).data('page');
		if (page && page > 0 && page <= Math.ceil(allReviews.length / itemsPerPage)) {
			renderReviews(page);
		}
	});
// 		페이지 이동	끝 ----------------------------

// 		리뷰 등록
	$('#addReview').on('click', function() {
		var reviewData = {
			item_no: item_no,
			re_title: $('#re_title').val(),
			re_content: $('#re_content').val(),
			customer_id: $('input[name="customer_id"]').val(),
            rating: $('#rating').val()
		};

		$.ajax({
			url: '/review/add',
			type: 'POST',
			contentType: 'application/json',
			data: JSON.stringify(reviewData),
			success: function(response) {
				alert('리뷰가 등록되었습니다.');
				$('#re_title').val('');
				$('#re_content').val('');
				loadReviews();	// 리뷰 목록 새로고침
			},
			error: function(err) {
		//		console.error(err);
				alert('리뷰 등록에 실패했습니다.');
			}
		});
	});
	
	
});

$(function(){
	
	var reviewSection = $('#review-section');
	var reviewList = $('#review-list'); // 변수 상단으로 이동 (중복 제거)
	var item_no = reviewSection.data('item-no');
	var loginUser = reviewSection.data('login-user');

	// '리뷰' 탭이 보여질 때 리뷰를 로드
	$(document).on('shown.bs.tab', 'a[href="#tab-pane-3"]', function() {
		loadReviews();
	});

    // 페이지 로드 시 바로 리뷰 로드 (상단 평점/개수 표시를 위해)
    loadReviews();

	var allReviews = [];
	var currentPage = 1;
	var itemsPerPage = 5;

    // [공통 함수] 별점(하트) 상태 업데이트
    function updateStarState($elements, value) {
        $elements.each(function() {
            var starValue = $(this).data('value');
            if (starValue <= value) {
                $(this).removeClass('far').addClass('fas'); // 꽉 찬 하트
            } else {
                $(this).removeClass('fas').addClass('far'); // 빈 하트
            }
        });
    }

    // 평점 선택 (메인 작성 폼)
    $(document).on('click', '.rating-heart', function() {
        var value = $(this).data('value');
        $('#rating').val(value);
        updateStarState($('.rating-heart'), value);
    });

    // 평점 선택 (수정 폼)
    $(document).on('click', '.edit-rating-heart', function() {
        var value = $(this).data('value');
        var container = $(this).closest('.edit-rating-container');
        container.find('.edit-rating-input').val(value);
        updateStarState(container.find('.edit-rating-heart'), value);
    });

	function loadReviews() {
		reviewList.html('<p>리뷰를 불러오는중...</p>');

		$.ajax({
			url: '/review/list',
			type: 'GET',
			dataType: 'json',
			data: { item_no: item_no },
			success: function(reviews) {				
				if (!reviews || reviews.length === 0) {
                    $('#review-summary').text('(0개)');
                    $('#product-rating-summary').html('<i class="far fa-heart" style="color: #D19C97;"></i> 0.0 (0개 리뷰)');
					reviewList.html('<p>등록된 리뷰가 없습니다.</p>');
					$('#review-pagination').empty();
					return;
                }
				allReviews = reviews;

                // 평균 평점 계산
                var totalRating = 0;
                var count = 0;
                reviews.forEach(function(r) {
                    if(r.rating) {
                        totalRating += r.rating;
                        count++;
                    }
                });
                var avg = count > 0 ? (totalRating / count).toFixed(1) : 0;
                var summaryHtml = '<i class="fas fa-heart" style="color: #D19C97;"></i> ' + avg + ' / ' + reviews.length + '개';
                
                $('#review-summary').html(summaryHtml);
                $('#product-rating-summary').html('<i class="fas fa-heart" style="color: #D19C97;"></i> ' + avg + ' (' + reviews.length + '개 리뷰)');

				renderReviews(1);
			},
			error: function(err) {				
				reviewList.html('<p>리뷰를 불러올 수 없습니다.</p>');
			}
		});
	}

// 		리뷰 페이지 이동 	
	function renderReviews(page) {
		currentPage = page;
		var start = (page - 1) * itemsPerPage;
		var end = start + itemsPerPage;
		var slicedReviews = allReviews.slice(start, end);
		
		reviewList.empty();
		
		// 리뷰 항목 생성
		slicedReviews.forEach(function(r) {
            var ratingHtml = '';
            var rating = r.rating || 5; // 기본값 5
            for(var i=1; i<=5; i++) {
                if(i <= rating) {
                    ratingHtml += '<i class="fas fa-heart" style="color: #D19C97;"></i>';
                } else {
                    ratingHtml += '<i class="far fa-heart" style="color: #D19C97;"></i>';
                }
            }

			var html = '<div class="mb-3 border-bottom pb-2" id="review-' + r.review_no + '">'
				+ '<div class="d-flex justify-content-between align-items-center">'
				+ '<div>'
                + '<h6>' + r.customer_id + ' <small><i>' + r.re_date + '</i></small></h6>'
                + '<div class="mb-1">' + ratingHtml + '</div>'
                + '</div>';
			
			// 로그인한 유저 본인의 리뷰일 경우 수정/삭제 버튼 표시
			if (loginUser && String(loginUser) === String(r.customer_id)) {
				html += '<div>'
					+ '<button class="btn btn-sm btn-outline-primary mr-1 edit-review-btn" data-id="' 
					+ r.review_no 
					+ '">수정</button>'
					+ '<button class="btn btn-sm btn-outline-danger delete-review-btn" data-id="' 
					+ r.review_no 
					+ '">삭제</button>'
					+ '</div>';
			}
			
			html += '</div>'
				+ '<p class="review-content">' + r.re_content + '</p>'
				+ '</div>';
			reviewList.append(html);
		});

		renderPagination();
	}

	// 리뷰 삭제 버튼 클릭
	$(document).on('click', '.delete-review-btn', function() {
		if (!confirm('정말 삭제하시겠습니까?')) return;
		var reviewNo = $(this).data('id');
		
		$.ajax({
			url: '/review/delete',
			type: 'POST',
			data: { review_no: reviewNo },
			success: function(res) {
				alert('삭제되었습니다.');
				loadReviews();
			},
			error: function(err) {
				alert('삭제 실패');
			}
		});
	});

	// 리뷰 수정 버튼 클릭시 수정폼으로 전환
	$(document).on('click', '.edit-review-btn', function() {
		var reviewNo = $(this).data('id');
        // 현재 리뷰 데이터 찾기
        var reviewData = allReviews.find(function(r) { return r.review_no == reviewNo; });
        var currentRating = reviewData ? (reviewData.rating || 5) : 5;

		var reviewDiv = $('#review-' + reviewNo);
		var contentP = reviewDiv.find('.review-content');
		var originalContent = contentP.text();

        // 수정용 별점 HTML 생성
        var starsHtml = '<div class="mb-2 edit-rating-container">';
        for(var i=1; i<=5; i++) {
            var starClass = (i <= currentRating) ? 'fas' : 'far';
            starsHtml += '<i class="'+starClass+' fa-heart fa-lg edit-rating-heart mr-1" data-value="'
					+ i+'" style="cursor:pointer; color: #D19C97;"></i>';
        }
        starsHtml += '<input type="hidden" class="edit-rating-input" value="'+currentRating+'"></div>';

		var editHtml = '<div class="edit-form">'
            + starsHtml
			+ '<textarea class="form-control mb-2 edit-textarea" rows="3">' 
			+ originalContent 
			+ '</textarea>'
			+ '<div class="text-right">'
			+ '<button class="btn btn-sm btn-primary save-edit-btn" data-id="' 
			+ reviewNo 
			+ '">저장</button> '
			+ '<button class="btn btn-sm btn-secondary cancel-edit-btn">취소</button>'
			+ '</div>'
			+ '</div>';
		
		contentP.hide();
        reviewDiv.find('.mb-1').hide(); // 기존 별점 숨기기
		reviewDiv.append(editHtml);
		$(this).prop('disabled', true); // 수정 버튼 비활성화
	});

	// 수정 취소
	$(document).on('click', '.cancel-edit-btn', function() {
		var reviewDiv = $(this).closest('.mb-3');
		reviewDiv.find('.edit-form').remove();
		reviewDiv.find('.review-content').show();
        reviewDiv.find('.mb-1').show(); // 기존 별점 보이기
		reviewDiv.find('.edit-review-btn').prop('disabled', false);
	});

	// 수정 저장
	$(document).on('click', '.save-edit-btn', function() {
		var reviewNo = $(this).data('id');
		var reviewDiv = $(this).closest('.mb-3');
		var newContent = reviewDiv.find('.edit-textarea').val();
        var newRating = reviewDiv.find('.edit-rating-input').val();

		$.ajax({
			url: '/review/update',
			type: 'POST',
			contentType: 'application/json',
			data: JSON.stringify({ review_no: reviewNo, re_content: newContent, rating: newRating }),
			success: function(res) {
				alert('수정되었습니다.');
				loadReviews();
			},
			error: function(err) {
				alert('수정 실패');
			}
		});
	});

//	페이지 버튼 생성 (위에 설정된 리뷰개수 5개 초과시) ---
	function renderPagination() {
		var totalPages = Math.ceil(allReviews.length / itemsPerPage);
		var pagination = $('#review-pagination');
		pagination.empty();

		if (totalPages <= 1) return;

		var ul = $('<ul class="pagination mb-0"></ul>');
		
		// 이전으로
		var prevClass = currentPage === 1 ? 'disabled' : '';
		ul.append('<li class="page-item ' + prevClass + '"><a class="page-link" href="#" data-page="' 
			+ (currentPage - 1) + '">이전</a></li>');

		// 페이지 번호
		for (var i = 1; i <= totalPages; i++) {
			var activeClass = i === currentPage ? 'active' : '';
			ul.append('<li class="page-item ' + activeClass 
				+ '"><a class="page-link" href="#" data-page="' 
				+ i + '">' 
				+ i + '</a></li>');
		}

		// 다음페이지로
		var nextClass = currentPage === totalPages ? 'disabled' : '';
		ul.append('<li class="page-item ' + nextClass + '"><a class="page-link" href="#" data-page="' 
			+ (currentPage + 1) + '">다음</a></li>');

		pagination.append(ul);
	}

	// 리뷰 페이지 이동 버튼 클릭
	$(document).on('click', '#review-pagination .page-link', function(e) {
		e.preventDefault();
		var page = $(this).data('page');
		if (page && page > 0 && page <= Math.ceil(allReviews.length / itemsPerPage)) {
			renderReviews(page);
		}
	});
// 		페이지 이동	끝 ----------------------------

// 		리뷰 등록
	$('#addReview').on('click', function() {
		var reviewData = {
			item_no: item_no,
			re_title: $('#re_title').val(),
			re_content: $('#re_content').val(),
			customer_id: $('input[name="customer_id"]').val(),
            rating: $('#rating').val()
		};

		$.ajax({
			url: '/review/add',
			type: 'POST',
			contentType: 'application/json',
			data: JSON.stringify(reviewData),
			success: function(response) {
				alert('리뷰가 등록되었습니다.');
				$('#re_title').val('');
				$('#re_content').val('');
				loadReviews();	// 리뷰 목록 새로고침
			},
			error: function(err) {
		//		console.error(err);
				alert('리뷰 등록에 실패했습니다.');
			}
		});
	});
	
	
});
