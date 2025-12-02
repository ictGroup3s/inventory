package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.model.vo.ProductVO;
import com.example.service.AdminService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AdminController {

	@Autowired
	private AdminService adminService;

	// 상품 등록 페이지 + 목록 보여주기
	@GetMapping("/item")
	public String showItemForm(Model m) {
		List<ProductVO> list = adminService.getItemList();
		log.info("controller [ " + list + " ]");
		m.addAttribute("list", list);

		return "item"; // item.jsp
	}

	// 상품 등록
	@PostMapping("/saveItem")
	public String saveItem(@ModelAttribute ProductVO vo, @RequestParam("uploadFile") MultipartFile file)
			throws Exception {

		// 1. 이미지가 존재하면 서버에 저장
		if (!file.isEmpty()) {
			String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();

			// 저장 경로
			String savePath = System.getProperty("user.dir") + "\\src\\main\\resources\\static\\img\\product\\";
			log.info("저장경로: " + savePath);

			File dir = new File(savePath);
			if (!dir.exists()) {
				dir.mkdirs();
			}

			File dest = new File(dir, fileName);
			file.transferTo(dest); // 실제 파일 저장

			// VO에 DB에 저장할 필드명(item_img)에 세팅
			vo.setItem_img(fileName);
		} else {
			vo.setItem_img("");
		}

		// 2. 상품 저장
		adminService.saveItem(vo);

		return "redirect:/item";
	}

	@PostMapping("/itemUpdate")
	public String updateItem(ProductVO productVO) throws IOException {
		// MultipartFile에 업로드된 파일이 있는지 확인
		if (productVO.getItem_imgFile() != null && !productVO.getItem_imgFile().isEmpty()) {
			MultipartFile file = productVO.getItem_imgFile();
			String fileName = file.getOriginalFilename();

			// 원하는 경로에 저장
			file.transferTo(new File("src/main/resources/static/img/product/" + fileName));

			// VO에 파일명 세팅 (DB 저장용)
			productVO.setItem_img(fileName);
		}

		// 서비스 호출
		adminService.updateItem(productVO);

		return "redirect:/item";
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
