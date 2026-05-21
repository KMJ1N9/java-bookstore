package com.gg.goods.controller.admin;

import com.gg.goods.service.AdminDashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

/**
 * 管理员仪表盘控制器
 * 处理仪表盘数据的实时更新请求
 */
@Controller
@RequestMapping("/admin/dashboard")
public class AdminDashboardController {

    @Autowired
    private AdminDashboardService adminDashboardService;

    /**
     * 获取仪表盘统计数据
     *
     * @return 包含统计数据和最近活动的Map
     */
    @RequestMapping("/stats")
    @ResponseBody
    public Map<String, Object> getDashboardStats() {
        return adminDashboardService.getDashboardStats();
    }
}
