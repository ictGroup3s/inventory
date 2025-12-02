package com.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import com.example.model.vo.ProductVO;
import com.example.service.AdminService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("admin")
public class AdminController {

	@Autowired
	private AdminService adminService;

	// 상품 등록 페이지 보여주기
	@GetMapping("item")
	public String ShowItemForm(Model m) {
		m.addAttribute("item", new ProductVO());

		return "item";
	}
	/*
	 * //상품 등록
	 * 
	 * @PostMapping("insertItem") public String insertItem(@ModelAttribute ItemVO
	 * ,Model m) {
	 * 
	 * MultipartFile img = item.getImage(); return "insert"; }
	 */

	/*
	 * // 상품 등록
	 * 
	 * @PostMapping("saveItem") public String insertItem(@RequestParam("file")
	 * MultipartFile files, ItemVO vo) { try { // 파일 원본이름 String originalFileName =
	 * files.getOriginalFilename(); log.info("원본 파일명: " + originalFileName);
	 * 
	 * // 첨부된 파일이 있을 경우 if (originalFileName != null && !originalFileName.isEmpty())
	 * { String filename = new MD5Generator(originalFileName).toString();
	 * log.info("변경파일명: " + filename);
	 * 
	 * // 원본파일의 확장자 붙이기 String extension =
	 * originalFileName.substring(originalFileName.lastIndexOf(".")); filename =
	 * filename + extension;
	 * 
	 * String savepath = System.getProperty("user.dir") +
	 * "\\src\\main\\resources\\static\\files\\board"; log.info("저장경로: " +
	 * savepath);
	 * 
	 * if (!new File(savepath).exists()) { new File(savepath).mkdirs(); } // 저장하기
	 * String filepath = savepath + "\\" + filename; files.transferTo(new
	 * File(filepath));
	 * 
	 * log.info(filepath+" 저장됨");
	 * 
	 * ItemVO itemVO = new ItemVO();
	 * 
	 * 
	 * } } catch (Exception e) { e.printStackTrace(); } return "redirect:item"; }
	 */
}
