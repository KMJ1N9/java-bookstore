package com.gg.goods.controller.admin;

import com.gg.goods.entity.Stock;
import com.gg.goods.povos.StockVO;
import com.gg.goods.service.AdminStockService;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

/**
 * 管理员库存管理控制器
 */
@Controller
@RequestMapping("/admin/stock")
public class AdminStockController {

    @Autowired
    private AdminStockService adminStockService;

    /**
     * 库存列表页面（支持/list路径访问）
     */
    @RequestMapping("/list")
    public String stockListAlias(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            Model model) {
        // 直接调用stockList方法，复用相同的业务逻辑
        return stockList(pageNum, pageSize, model);
    }

    /**
     * 库存列表页面
     */
    @RequestMapping("/stockList")
    public String stockList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            Model model) {
        List<StockVO> stockList = adminStockService.getAllStockVOs();
        PageInfo<StockVO> pageInfo = new PageInfo<>(stockList);
        model.addAttribute("stockList", stockList);
        model.addAttribute("pageInfo", pageInfo);
        return "jsps/admin/stock/list";
    }

    @RequestMapping("/lowStockList")
    public String lowStockList(Model model) {
        List<StockVO> lowStockList = adminStockService.getLowStockVOs();
        PageInfo<StockVO> pageInfo = new PageInfo<>(lowStockList);
        model.addAttribute("stockList", lowStockList);
        model.addAttribute("pageInfo", pageInfo);
        return "jsps/admin/stock/list";
    }

    @RequestMapping("/searchStock")
    public String searchStock(String keyword, Model model) {
        List<StockVO> searchResult = adminStockService.searchStockByBookName(keyword);
        PageInfo<StockVO> pageInfo = new PageInfo<>(searchResult);
        model.addAttribute("stockList", searchResult);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("keyword", keyword);
        return "jsps/admin/stock/list";
    }

    /**
     * 更新库存数量
     */
    @ResponseBody
    @RequestMapping("/updateStockQuantity")
    public String updateStockQuantity(
            @RequestParam("bid") String bid,
            @RequestParam("quantity") Integer quantity,
            HttpServletRequest request) {
        try {
            int result = adminStockService.adminUpdateStockQuantity(bid, quantity, request);
            if (result > 0) {
                return "success";
            } else {
                return "error";
            }
        } catch (Exception e) {
            return "error";
        }
    }

    /**
     * 批量更新库存状态
     */
    @ResponseBody
    @RequestMapping("/batchUpdateStockStatus")
    public String batchUpdateStockStatus(
            @RequestParam("sids") String[] sids,
            @RequestParam("status") Integer status,
            HttpServletRequest request) {
        try {
            // 将数组转换为List
            List<String> sidList = java.util.Arrays.asList(sids);
            Map<String, Object> params = new java.util.HashMap<>();
            params.put("sids", sidList);
            params.put("status", status);

            int result = adminStockService.batchUpdateStockStatus(params, request);
            if (result > 0) {
                return "success";
            } else {
                return "error";
            }
        } catch (Exception e) {
            return "error";
        }
    }

    /**
     * 刷新所有库存状态
     */
    @ResponseBody
    @RequestMapping("/refreshAllStockStatus")
    public String refreshAllStockStatus(HttpServletRequest request) {
        try {
            adminStockService.refreshAllStockStatus(request);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }

    /**
     * 库存详情页面
     */
    @RequestMapping("/detail/{bid}")
    public String detail(@PathVariable("bid") String bid, Model model) {
        Stock stock = adminStockService.getStockByBid(bid);
        model.addAttribute("stockVO", new StockVO(stock));
        return "jsps/admin/stock/detail";
    }

    /**
     * 编辑库存页面
     */
    @RequestMapping("/edit/{bid}")
    public String edit(@PathVariable("bid") String bid, Model model) {
        Stock stock = adminStockService.getStockByBid(bid);
        model.addAttribute("stock", stock);
        return "jsps/admin/stock/edit";
    }

    /**
     * 更新库存信息
     */
    @RequestMapping("/update/info")
    public String updateInfo(Stock stock, Model model) {
        try {
            int result = adminStockService.adminUpdateStockInfo(stock);
            if (result > 0) {
                model.addAttribute("message", "更新成功");
            } else {
                model.addAttribute("message", "更新失败");
            }
        } catch (Exception e) {
            model.addAttribute("message", "更新失败：" + e.getMessage());
        }
        return "jsps/admin/stock/message";
    }

    /**
     * 更新库存数量
     */
    @RequestMapping("/update/quantity")
    public String updateQuantity(String bid, Integer quantity, Model model) {
        try {
            int result = adminStockService.adminUpdateStockQuantity(bid, quantity);
            if (result > 0) {
                model.addAttribute("message", "更新成功");
            } else {
                model.addAttribute("message", "更新失败");
            }
        } catch (Exception e) {
            model.addAttribute("message", "更新失败：" + e.getMessage());
        }
        return "jsps/admin/stock/message";
    }
}