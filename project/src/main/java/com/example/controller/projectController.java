package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.ui.Model;

import lombok.extern.slf4j.Slf4j;

import java.util.*;
import com.fasterxml.jackson.databind.ObjectMapper;

@Slf4j
@Controller
public class projectController {
	
	
	@GetMapping("header")
	public String header() {
		return "header";
	}
	@GetMapping("cart")
	public String cart() {
		return "cart";
	}
	
	@GetMapping("shop")
	public String shop() {
		return "shop";
		
	}
	
	@GetMapping("checkout")
	public String checkout() {
		return "checkout";
	}
	
	@GetMapping("selectall")
	public String selectall() {
		return "selectall";
	}
	
	@GetMapping("detail")
	public String detail() {
		return "detail";
	}
	
	@GetMapping("itemdetail")
	public String itemdetail() {
		return "itemdetail";
	}
	
	@GetMapping("register")
	public String register() {
		return "register";
	}


	@GetMapping("login")
	public String login() {
		return "login";
	}
	
	@GetMapping("mlist")
	public String mlist() {
		return "mlist";
	}
	
	@GetMapping("selectBanchan")
	public String selectBanchan() {
		return "selectBanchan";
	}
	
	@GetMapping("selectBunsik")
	public String selectBunsik() {
		return "selectBunsik";
	}
	
	@GetMapping("selectDiet")
	public String selectDiet() {
		return "selectDiet";
	}
	
	@GetMapping("selectGui")
	public String selectGui() {
		return "selectGui";
	}
	
	@GetMapping("selectdrink")
	public String selectdrink() {
		return "selectdrink";
	}
	
	@GetMapping("selectSoup")
	public String selectSoup() {
		return "selectSoup";
	}

	@GetMapping("selectRecipe")
	public String selectRecipe() {
		return "selectRecipe";
	}

	@GetMapping("board")
	public String board() {
		return "board";
	}
	
	@GetMapping("dashboard")
	public String dashboard() {
		return "dashboard";
	}
	
	//@GetMapping("stock")
	//public String stock() {
	//	return "stock";
	//}

	//@GetMapping("item")
	//public String item() { 
	//	return "item"; 
	//}
	 
	@GetMapping("order")
	public String order() {
		return "order";
	}
	
	@GetMapping("/mypage")
	public String mypage() {
		return "mypage";
	}
	
	@GetMapping("/mycs")
	public String mycs() {
		return "mycs";
	}
	
	@GetMapping("/myqna")
	public String myqna() {
		return "myqna";
	}
	
	@GetMapping("/mydelivery")
	public String mydelivery() {
		return "mydelivery";
	}
	
	
	
	

	@GetMapping("event1")
	public String event1() {
		return "event1";
	}
	
	@GetMapping("event2")
	public String event2() {
		return "event2";
	}
	
// 	통계 페이지(연도별*월별 매출 / 지출)	
	@GetMapping("stats")
	public String stats(Model model) throws Exception {
        // Sample monthly data (year, month, sales, expenses, profit)
        List<Map<String, Object>> monthly = new ArrayList<>();
        // Example: recent 12 months (mocked)
        int[][] sample = {
            {2025, 11, 2630, 1870},
            {2025, 10, 2350, 1530},
            {2025, 9, 2080, 1350},
            {2025, 8, 1660, 1060},
            {2025, 7, 1630, 1240},
            {2025, 6, 1750, 1270},
            {2025, 5, 1820, 1210}
        };
        for (int[] r : sample) {
            Map<String, Object> m = new HashMap<>();
            int year = r[0];
            int month = r[1];
            int sales = r[2];
            int expenses = r[3];
            int profit = sales - expenses;
            double profitRate = sales != 0 ? Math.round((double)profit * 1000.0 / sales) / 10.0 : 0.0;
            m.put("year", year);
            m.put("month", month);
            m.put("sales", sales);
            m.put("expenses", expenses);
            m.put("profit", profit);
            m.put("profitRate", profitRate);
            m.put("note", "샘플 데이터");
            monthly.add(m);
        }

        // Sample daily metrics (recent 7 days)
        List<Map<String, Object>> dailyMetrics = new ArrayList<>();
        String[] days = {"2024-11-11","2024-11-10","2024-11-09","2024-11-08","2024-11-07","2024-11-06","2024-11-05"};
        int[] dayVisitors = {1200, 1150, 980, 1020, 1300, 1250, 1400};
        int[] dayOrders =   {120,  110,  95,  100,  135,  128,  150};
        for (int i = 0; i < days.length; i++) {
            Map<String, Object> d = new HashMap<>();
            d.put("date", days[i]);
            d.put("visitors", dayVisitors[i]);
            d.put("orders", dayOrders[i]);
            d.put("note", "샘플");
            dailyMetrics.add(d);
        }

        // Sample monthly visitors/orders (recent 7 months)
        List<Map<String, Object>> monthlyVisitors = new ArrayList<>();
        int[][] mv = {
            {2024,11,  37200, 2100},
            {2024,10,  36000, 1980},
            {2024,9,   34500, 1850},
            {2024,8,   31000, 1720},
            {2024,7,   29800, 1680},
            {2024,6,   30500, 1740},
            {2024,5,   32000, 1820}
        };
        for (int[] r : mv) {
            Map<String,Object> mm = new HashMap<>();
            int year = r[0];
            int month = r[1];
            int visitors = r[2];
            int orders = r[3];
            double avgPerDay = Math.round((double)orders / 30.0 * 10.0) / 10.0; // rough avg
            mm.put("year", year);
            mm.put("month", month);
            mm.put("visitors", visitors);
            mm.put("orders", orders);
            mm.put("avgPerDay", avgPerDay);
            mm.put("note", "샘플");
            monthlyVisitors.add(mm);
        }

        // Sort lists newest-first so view shows latest at top by default
        monthly.sort((a,b) -> {
            int ay = (int)a.get("year"); int am = (int)a.get("month");
            int by = (int)b.get("year"); int bm = (int)b.get("month");
            if (ay != by) return Integer.compare(by, ay); // year desc
            return Integer.compare(bm, am); // month desc
        });

        monthlyVisitors.sort((a,b) -> {
            int ay = (int)a.get("year"); int am = (int)a.get("month");
            int by = (int)b.get("year"); int bm = (int)b.get("month");
            if (ay != by) return Integer.compare(by, ay);
            return Integer.compare(bm, am);
        });

        dailyMetrics.sort((a,b) -> {
            // date strings in format yyyy-MM-dd -> lexicographic desc works
            String da = (String)a.get("date");
            String db = (String)b.get("date");
            return db.compareTo(da); // newest first
        });

        ObjectMapper mapper = new ObjectMapper();
        model.addAttribute("monthlyData", monthly);
        model.addAttribute("monthlyDataJson", mapper.writeValueAsString(monthly));
        model.addAttribute("dailyMetrics", dailyMetrics);
        model.addAttribute("monthlyVisitors", monthlyVisitors);

        return "stats";
    }
}
