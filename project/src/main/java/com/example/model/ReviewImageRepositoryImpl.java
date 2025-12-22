package com.example.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.model.vo.ReviewImageVO;

@Repository
public class ReviewImageRepositoryImpl implements ReviewImageRepository {

	@Autowired
	private SqlSessionTemplate sess;

	@Override
	public int insert(ReviewImageVO image) {
		return sess.insert("com.example.model.ReviewImageRepository.insert", image);
	}

	@Override
	public List<ReviewImageVO> selectImagesByItemNo(Integer item_no) {
		return sess.selectList("com.example.model.ReviewImageRepository.selectImagesByItemNo", item_no);
	}

	@Override
	public List<ReviewImageVO> selectImagesByReviewNo(Integer review_no) {
		return sess.selectList("com.example.model.ReviewImageRepository.selectImagesByReviewNo", review_no);
	}

	@Override
	public int deleteByReviewNo(Integer review_no) {
		Integer result = sess.delete("com.example.model.ReviewImageRepository.deleteByReviewNo", review_no);
		return result == null ? 0 : result;
	}

	@Override
	public int deleteByIds(List<Integer> review_img_no_list) {
		Integer result = sess.delete("com.example.model.ReviewImageRepository.deleteByIds", review_img_no_list);
		return result == null ? 0 : result;
	}
}