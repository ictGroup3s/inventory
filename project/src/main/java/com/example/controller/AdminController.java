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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.model.vo.ProductVO;
import com.example.service.AdminService;
import com.example.service.AdminServiceImpl;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AdminController {

    private final AdminServiceImpl adminServiceImpl;

	@Autowired
	private AdminService adminService;

    AdminController(AdminServiceImpl adminServiceImpl) {
        this.adminServiceImpl = adminServiceImpl;
    }

	// 상품 등록 페이지 + 목록 보여주기
	@GetMapping("/item")
	public String showItemForm(Model m) {
		List<ProductVO> list = adminService.getItemList();
		log.info("----- AdminController- showItemForm호출 -----");
		//log.info("controller [ " + list + " ]");
		m.addAttribute("list", list);

		return "item"; // item.jsp
	}

	// 상품 등록
	@PostMapping("/saveItem")
	public String saveItem(@ModelAttribute ProductVO vo, @RequestParam("item_imgFile") MultipartFile file)
			throws Exception {

		// vo에 dis_rate가 정상적으로 넘어왔는지 확인
	    log.info("Received dis_rate: " + vo.getDis_rate());
	    
		// 1. 이미지가 존재하면 서버에 저장
		if (!file.isEmpty()) {
			String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();

			// 저장 경로
			String savePath = System.getProperty("user.dir") + "\\src\\main\\resources\\static\\img\\product";
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
	public String updateItem(ProductVO vo) throws IOException {
		// MultipartFile에 업로드된 파일이 있는지 확인
		if (vo.getItem_imgFile() != null && !vo.getItem_imgFile().isEmpty()) {
			MultipartFile file = vo.getItem_imgFile();
			String fileName = file.getOriginalFilename();
			
			// 원하는 경로에 저장
			file.transferTo(new File("src/main/resources/static/img/product/" + fileName));

			// VO에 파일명 세팅 (DB 저장용)
			vo.setItem_img(fileName);
		}

		// 서비스 호출
		adminService.updateItem(vo);

		return "redirect:/item";
	}

	@PostMapping("/deleteItem")
	@ResponseBody
	public String deleteItem(@RequestParam("itemNo") Integer itemNo) {
		log.info("받은 item_no: " + itemNo);
		try {
			adminService.deleteItem(itemNo);
			return "success";
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}

	}
	
	// ***** stock ***** 
	// 상품 등록 페이지 + 목록 보여주기
	@GetMapping("/stock")
	public String showItem(Model m) {
	    log.info("===== /stock 호출됨 =====");  // 이거 추가
	    List<ProductVO> list = adminService.getStockList();
	    m.addAttribute("list", list);
	    return "stock";
	}
	
	@PostMapping("/updateStock")
	public String updateItemStock(ProductVO vo){
		adminService.updateStock(vo);

		return "redirect:/stock";
	}
	

}
