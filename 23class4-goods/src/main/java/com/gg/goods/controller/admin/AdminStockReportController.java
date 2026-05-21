package com.gg.goods.controller.admin;

import com.gg.goods.povos.StockReportPO;
import com.gg.goods.service.AdminStockReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

/**
 * 库存报表控制器
 * 处理库存统计和分析相关的请求
 */
@Controller
@RequestMapping("/admin/stock/report")
public class AdminStockReportController {

    @Autowired
    private AdminStockReportService adminStockReportService;

    /**
     * 默认请求处理，重定向到报表首页
     */
    @GetMapping("")
    public String defaultReport() {
        return "redirect:/admin/stock/report/index";
    }

    /**
     * 跳转到库存报表主页面
     *
     * @return 库存报表页面路径
     */
    @GetMapping("/index")
    public String reportIndex() {
        return "jsps/admin/stock/report";
    }

    /**
     * 获取库存概览统计数据
     *
     * @return 库存概览统计数据JSON
     */
    @GetMapping("/overview")
    @ResponseBody
    public Map<String, Object> getStockOverview() {
        return adminStockReportService.getStockOverviewStats();
    }

    /**
     * 获取库存状态分布数据
     *
     * @return 库存状态分布数据JSON
     */
    @GetMapping("/status-distribution")
    @ResponseBody
    public List<StockReportPO> getStockStatusDistribution() {
        return adminStockReportService.getStockStatusDistribution();
    }

    /**
     * 获取库存预警级别分布
     *
     * @return 库存预警级别分布数据JSON
     */
    @GetMapping("/warning-distribution")
    @ResponseBody
    public List<StockReportPO> getStockWarningDistribution() {
        return adminStockReportService.getStockWarningDistribution();
    }

    /**
     * 获取库存数量范围分布
     *
     * @return 库存数量范围分布数据JSON
     */
    @GetMapping("/quantity-range")
    @ResponseBody
    public List<StockReportPO> getStockQuantityRangeDistribution() {
        return adminStockReportService.getStockQuantityRangeDistribution();
    }

    /**
     * 获取近期库存变化趋势数据
     *
     * @param days 查询天数，默认为30天
     * @return 库存变化趋势数据JSON
     */
    @GetMapping("/trend")
    @ResponseBody
    public List<StockReportPO> getStockTrend(int days) {
        if (days <= 0 || days > 90) {
            days = 30; // 默认30天
        }
        return adminStockReportService.getStockTrendByDays(days);
    }

    /**
     * 获取库存周转率数据
     *
     * @return 库存周转率数据JSON
     */
    @GetMapping("/turnover")
    @ResponseBody
    public List<Map<String, Object>> getStockTurnover() {
        return adminStockReportService.getStockTurnoverData();
    }
}

