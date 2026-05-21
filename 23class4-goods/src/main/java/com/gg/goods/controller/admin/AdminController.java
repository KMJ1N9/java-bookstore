package com.gg.goods.controller.admin;

import com.gg.goods.entity.Admin;
import com.gg.goods.exception.BusinessException;
import com.gg.goods.service.AdminService;
import com.gg.goods.service.CacheStatisticsService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Map;

@Controller
@RequestMapping("/admin")
@Slf4j
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private CacheStatisticsService cacheStatisticsService;

    /**
     * 跳转到管理员登录页面
     */
    @RequestMapping(value = "/loginPage", method = RequestMethod.GET)
    public String loginPage() {
        return "jsps/admin/login";
    }

    /**
     * 管理员登录
     */
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(Admin admin, Model model, HttpSession session) {
        log.info("管理员登录请求 - 用户名: {}", admin.getAdminname());
        try {
            Admin loginAdmin = adminService.login(admin);
            if (loginAdmin != null) {
                // 登录成功，将管理员信息存入session
                session.setAttribute("admin", loginAdmin);
                // 记录会话创建时间，用于项目重启后验证会话有效性
                session.setAttribute("sessionCreatedTime", System.currentTimeMillis());
                log.info("管理员登录成功 - 用户名: {}, ID: {}", loginAdmin.getAdminname(), loginAdmin.getAdminId());
                return "jsps/admin/index";
            } else {
                // 登录失败
                log.warn("管理员登录失败 - 用户名: {}，密码错误", admin.getAdminname());
                model.addAttribute("msg", "用户名或密码错误");
                return "jsps/admin/login";
            }
        } catch (BusinessException e) {
            // 捕获业务异常，返回友好的错误提示
            log.warn("管理员登录业务异常 - 用户名: {}, 异常: {}", admin.getAdminname(), e.getMessage());
            model.addAttribute("msg", e.getMessage());
            return "jsps/admin/login";
        }
    }

    /**
     * 管理员退出登录
     */
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpSession session) {
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin != null) {
            log.info("管理员退出登录 - 用户名: {}, ID: {}", admin.getAdminname(), admin.getAdminId());
        }
        session.invalidate();
        return "redirect:/admin/loginPage";
    }

    /**
     * 后台首页
     */
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String index(HttpSession session) {
        // 检查管理员是否已登录
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            // 未登录，重定向到登录页面
            return "redirect:/admin/loginPage";
        }
        return "jsps/admin/index";
    }

    /**
     * 缓存详情页面
     */
    @RequestMapping(value = "/cache/detail", method = RequestMethod.GET)
    public String cacheDetail(HttpSession session, Model model, String cacheName) {
        // 检查管理员是否已登录
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            // 未登录，重定向到登录页面
            return "redirect:/admin/loginPage";
        }

        if (cacheName == null || cacheName.isEmpty()) {
            model.addAttribute("error", "缓存名称不能为空");
            return "redirect:/admin/cache/list";
        }

        try {
            Map<String, Object> cacheInfo = cacheStatisticsService.getCacheInfo(cacheName);
            model.addAttribute("cacheName", cacheName);
            model.addAttribute("stats", cacheInfo);
        } catch (Exception e) {
            model.addAttribute("error", "获取缓存详情失败: " + e.getMessage());
        }

        return "jsps/admin/cache/detail";
    }

    /**
     * 清除指定缓存
     */
    @RequestMapping(value = "/cache/clear", method = RequestMethod.GET)
    public String clearCache(HttpSession session, Model model, String cacheName) {
        // 检查管理员是否已登录
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            // 未登录，重定向到登录页面
            return "redirect:/admin/loginPage";
        }

        log.info("管理员缓存操作 - 用户: {}, 操作: 清除缓存, 缓存名称: {}", admin.getAdminname(), cacheName);

        if (cacheName == null || cacheName.isEmpty()) {
            log.warn("管理员缓存操作失败 - 用户: {}, 原因: 缓存名称为空", admin.getAdminname());
            model.addAttribute("error", "缓存名称不能为空");
            return "redirect:/admin/cache/list";
        }

        try {
            boolean result = cacheStatisticsService.clearCache(cacheName);
            if (result) {
                log.info("管理员缓存清除成功 - 用户: {}, 缓存名称: {}", admin.getAdminname(), cacheName);
                model.addAttribute("message", "缓存 " + cacheName + " 清除成功");
            } else {
                log.warn("管理员缓存清除失败 - 用户: {}, 缓存名称: {}, 原因: 缓存不存在", admin.getAdminname(), cacheName);
                model.addAttribute("error", "缓存 " + cacheName + " 不存在");
            }
        } catch (Exception e) {
            log.error("管理员缓存清除异常 - 用户: {}, 缓存名称: {}, 异常: {}", admin.getAdminname(), cacheName, e.getMessage());
            model.addAttribute("error", "清除缓存失败: " + e.getMessage());
        }

        return "redirect:/admin/cache/list";
    }

    /**
     * 清除所有缓存
     */
    @RequestMapping(value = "/cache/clearAll", method = RequestMethod.GET)
    public String clearAllCaches(HttpSession session, Model model) {
        // 检查管理员是否已登录
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            // 未登录，重定向到登录页面
            return "redirect:/admin/loginPage";
        }

        log.info("管理员缓存操作 - 用户: {}, 操作: 清除所有缓存", admin.getAdminname());

        try {
            int clearedCount = cacheStatisticsService.clearAllCaches();
            log.info("管理员清除所有缓存成功 - 用户: {}, 清除缓存数量: {}", admin.getAdminname(), clearedCount);
            model.addAttribute("message", "已清除 " + clearedCount + " 个缓存");
        } catch (Exception e) {
            log.error("管理员清除所有缓存异常 - 用户: {}, 异常: {}", admin.getAdminname(), e.getMessage());
            model.addAttribute("error", "清除所有缓存失败: " + e.getMessage());
        }

        return "redirect:/admin/cache/list";
    }

    /**
     * 缓存列表页面
     */
    @RequestMapping(value = "/cache/list", method = RequestMethod.GET)
    public String cacheList(HttpSession session, Model model) {
        // 检查管理员是否已登录
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            // 未登录，重定向到登录页面
            return "redirect:/admin/loginPage";
        }

        try {
            // 获取所有缓存名称
            java.util.Collection<String> cacheNames = cacheStatisticsService.getAllCacheNames();
            model.addAttribute("cacheNames", cacheNames);
        } catch (Exception e) {
            model.addAttribute("error", "获取缓存列表失败: " + e.getMessage());
        }

        return "jsps/admin/cache/list";
    }
}