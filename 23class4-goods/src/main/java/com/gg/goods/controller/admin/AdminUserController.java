package com.gg.goods.controller.admin;

import com.gg.goods.entity.User;
import com.gg.goods.service.AdminUserService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * 管理员用户管理控制器
 */
@Controller
@RequestMapping("/admin/user")
public class AdminUserController {

    @Autowired
    private AdminUserService adminUserService;

    /**
     * 分页查询用户列表
     *
     * @param pageNum  页码
     * @param pageSize 每页大小
     * @param model    模型对象
     * @return 用户列表页面
     */
    @RequestMapping("/list")
    public String list(@RequestParam(defaultValue = "1") Integer pageNum,
                       @RequestParam(defaultValue = "10") Integer pageSize,
                       Model model) {
        PageInfo<User> pageInfo = adminUserService.findAllUsers(pageNum, pageSize);
        model.addAttribute("pageInfo", pageInfo);
        return "jsps/admin/user/list";
    }

    @RequestMapping("/search")
    public String search(@RequestParam String loginname,
                         @RequestParam(defaultValue = "1") Integer pageNum,
                         @RequestParam(defaultValue = "10") Integer pageSize,
                         Model model) {
        PageInfo<User> pageInfo = adminUserService.findUsersByLoginname(loginname, pageNum, pageSize);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("loginname", loginname);
        return "jsps/admin/user/list";
    }

    @RequestMapping("/toAdd")
    public String toAdd() {
        return "jsps/admin/user/add";
    }

    @RequestMapping("/toEdit/{uid}")
    public String toEdit(@PathVariable String uid, Model model) {
        User user = adminUserService.findUserByUid(uid);
        model.addAttribute("user", user);
        return "jsps/admin/user/edit";
    }

    /**
     * 更新用户信息
     *
     * @param user       用户对象
     * @param attributes 重定向属性
     * @return 重定向到用户列表页面
     */
    @RequestMapping("/update")
    public String update(User user, RedirectAttributes attributes) {
        boolean result = adminUserService.updateUser(user);
        if (result) {
            attributes.addFlashAttribute("message", "更新用户成功");
        } else {
            attributes.addFlashAttribute("message", "更新用户失败");
        }
        return "redirect:/admin/user/list";
    }

    /**
     * 删除用户
     *
     * @param uid        用户ID
     * @param attributes 重定向属性
     * @return 重定向到用户列表页面
     */
    @RequestMapping("/delete/{uid}")
    public String delete(@PathVariable String uid, RedirectAttributes attributes) {
        boolean result = adminUserService.deleteUser(uid);
        if (result) {
            attributes.addFlashAttribute("message", "删除用户成功");
        } else {
            attributes.addFlashAttribute("message", "删除用户失败：该用户存在相关订单记录，不能删除");
        }
        return "redirect:/admin/user/list";
    }

    /**
     * 启用用户
     *
     * @param uid        用户ID
     * @param attributes 重定向属性
     * @return 重定向到用户列表页面
     */
    @RequestMapping("/enable/{uid}")
    public String enable(@PathVariable String uid, RedirectAttributes attributes) {
        boolean result = adminUserService.updateUserStatus(uid, 1);
        if (result) {
            attributes.addFlashAttribute("message", "启用用户成功");
        } else {
            attributes.addFlashAttribute("message", "启用用户失败");
        }
        return "redirect:/admin/user/list";
    }

    /**
     * 禁用用户
     *
     * @param uid        用户ID
     * @param attributes 重定向属性
     * @return 重定向到用户列表页面
     */
    @RequestMapping("/disable/{uid}")
    public String disable(@PathVariable String uid, RedirectAttributes attributes) {
        boolean result = adminUserService.updateUserStatus(uid, 0);
        if (result) {
            attributes.addFlashAttribute("message", "禁用用户成功");
        } else {
            attributes.addFlashAttribute("message", "禁用用户失败");
        }
        return "redirect:/admin/user/list";
    }

    /**
     * 添加用户
     *
     * @param user       用户对象
     * @param attributes 重定向属性
     * @return 重定向到用户列表页面
     */
    @RequestMapping("/add")
    public String addUser(User user, RedirectAttributes attributes) {
        Integer result = adminUserService.addUser(user);
        if (result > 0) {
            attributes.addFlashAttribute("message", "添加用户成功！");
        } else {
            attributes.addFlashAttribute("message", "添加用户失败！");
        }
        return "redirect:/admin/user/list";
    }
}