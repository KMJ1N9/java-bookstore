package com.gg.goods.controller.admin;

import com.gg.goods.entity.Order;
import com.gg.goods.entity.Orderitem;
import com.gg.goods.service.OrderService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/admin/order")
public class AdminOrderController {

    @Autowired
    private OrderService orderService;

    /**
     * 查看所有订单（支持分页）
     */
    @RequestMapping("/list")
    public String findAllOrders(@RequestParam(defaultValue = "1") Integer page,
                                @RequestParam(defaultValue = "10") Integer pageSize,
                                Model model) {
        // 启用分页
        PageHelper.startPage(page, pageSize);
        // 查询所有订单
        List<Order> orders = orderService.findAllOrders();
        // 创建PageInfo对象
        PageInfo<Order> pageInfo = new PageInfo<>(orders);
        // 添加到模型
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("orders", orders);
        return "jsps/admin/order/list";
    }

    /**
     * 查看订单详情
     */
    @RequestMapping("/desc/{oid}")
    public String viewOrderDetail(@PathVariable String oid, Model model) {
        // 查询订单基本信息
        Order order = orderService.getOrderById(oid);
        // 查询订单项列表
        List<Orderitem> orderItems = orderService.findOrderItemsByOid(oid);
        // 添加到模型
        model.addAttribute("order", order);
        model.addAttribute("orderItems", orderItems);
        return "jsps/admin/order/desc";
    }

    /**
     * 跳转到修改地址页面
     */
    @RequestMapping("/updateAddressPage/{oid}")
    public String updateAddressPage(@PathVariable String oid, Model model) {
        // 查询订单信息
        Order order = orderService.getOrderById(oid);
        model.addAttribute("order", order);
        return "jsps/admin/order/updateAddress";
    }

    /**
     * 更新订单地址
     */
    @RequestMapping("/updateAddress")
    public String updateOrderAddress(@RequestParam String oid,
                                     @RequestParam String address,
                                     Model model) {
        try {
            // 验证地址是否为空
            if (address == null || address.trim().isEmpty()) {
                model.addAttribute("message", "地址不能为空！");
                // 重新加载订单信息并返回修改页面
                Order order = orderService.getOrderById(oid);
                model.addAttribute("order", order);
                return "jsps/admin/order/updateAddress";
            }

            // 更新地址
            boolean success = orderService.updateAddress(oid, address.trim());

            if (success) {
                // 修改成功，跳转到订单详情页面
                return "redirect:/admin/order/desc/" + oid;
            } else {
                model.addAttribute("message", "修改地址失败，请重试！");
                // 重新加载订单信息并返回修改页面
                Order order = orderService.getOrderById(oid);
                model.addAttribute("order", order);
                return "jsps/admin/order/updateAddress";
            }
        } catch (Exception e) {
            model.addAttribute("message", "修改地址发生错误：" + e.getMessage());
            // 重新加载订单信息并返回修改页面
            try {
                Order order = orderService.getOrderById(oid);
                model.addAttribute("order", order);
            } catch (Exception ex) {
                // 如果加载订单也失败，返回订单列表
                return "redirect:/admin/order/list";
            }
            return "jsps/admin/order/updateAddress";
        }
    }

    /**
     * 订单发货
     */
    @RequestMapping("/deliver")
    @ResponseBody
    public String deliverOrder(@RequestParam String oid) {
        try {
            Order order = orderService.getOrderById(oid);
            if (order != null && order.getStatus() == 2) { // 确保只有已付款状态的订单可以发货
                boolean success = orderService.updateStatus(oid, 3);
                return success ? "success" : "error";
            }
            return "invalid_status";
        } catch (Exception e) {
            return "error";
        }
    }

    /**
     * 确认付款
     */
    @RequestMapping("/payOrder")
    @ResponseBody
    public String payOrder(@RequestParam String oid) {
        try {
            Order order = orderService.getOrderById(oid);
            if (order != null && order.getStatus() == 1) { // 确保只有等待付款状态的订单可以确认付款
                boolean success = orderService.updateStatus(oid, 2);
                return success ? "success" : "error";
            }
            return "invalid_status";
        } catch (Exception e) {
            return "error";
        }
    }

    /**
     * 取消订单
     */
    @RequestMapping("/cancelOrder")
    @ResponseBody
    public String cancelOrder(@RequestParam String oid) {
        try {
            Order order = orderService.getOrderById(oid);
            if (order != null && order.getStatus() == 1) { // 确保只有等待付款状态的订单可以取消
                boolean success = orderService.updateStatus(oid, 5);
                return success ? "success" : "error";
            }
            return "invalid_status";
        } catch (Exception e) {
            return "error";
        }
    }
}