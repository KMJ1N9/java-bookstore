package com.gg.goods.controller;

import com.gg.goods.entity.Order;
import com.gg.goods.entity.Orderitem;
import com.gg.goods.entity.User;
import com.gg.goods.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/order")
public class OrderController {
    @Autowired
    private OrderService orderService;

    /**
     * 创建订单
     *
     * @param order      订单对象
     * @param orderitems 订单项列表
     * @param session    用户会话
     * @return 订单ID
     */
    @RequestMapping("/createOrder")
    public String createOrder(Order order, List<Orderitem> orderitems, HttpSession session, Model model) {
        // 从会话中获取当前登录用户
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/jsps/user/login.jsp";
        }

        // 设置订单用户ID
        order.setUid(user.getUid());

        // 创建订单
        String oid = orderService.createOrder(order, orderitems);

        // 将订单ID存入会话，用于后续操作
        session.setAttribute("oid", oid);

        return "redirect:/jsps/order/ordersucc.jsp";
    }

    /**
     * 查询我的订单列表
     *
     * @param session 用户会话
     * @param model   模型对象
     * @return 订单列表页面
     */
    @RequestMapping("/myOrders")
    public String myOrders(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/jsps/user/login.jsp";
        }

        List<Order> orderList = orderService.findByUid(user.getUid());
        model.addAttribute("orderList", orderList);

        return "jsps/order/list";
    }

    /**
     * 查询订单详情
     *
     * @param oid   订单ID
     * @param model 模型对象
     * @return 订单详情页面
     */
    @RequestMapping("/desc/{oid}")
    public String orderDesc(@PathVariable("oid") String oid, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/jsps/user/login.jsp";
        }

        // 查询订单信息
        Order order = orderService.findByOid(oid);
        // 查询订单项列表
        List<Orderitem> orderItems = orderService.findOrderItemsByOid(oid);

        model.addAttribute("order", order);
        model.addAttribute("orderItems", orderItems);

        return "jsps/order/desc";
    }

    /**
     * 跳转到支付页面
     *
     * @param oid   订单ID
     * @param model 模型对象
     * @return 支付页面
     */
    @RequestMapping("/toPay")
    public String toPay(@RequestParam("oid") String oid, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/jsps/user/login.jsp";
        }

        // 查询订单信息
        Order order = orderService.findByOid(oid);
        model.addAttribute("order", order);

        return "jsps/order/pay";
    }

    /**
     * 支付订单
     *
     * @param oid 订单ID
     * @return 支付结果
     */
    @RequestMapping("/pay")
    @ResponseBody
    public String payOrder(@RequestParam("oid") String oid) {
        boolean result = orderService.payOrder(oid);
        if (result) {
            return "success";
        } else {
            return "error";
        }
    }

    /**
     * 确认收货
     *
     * @param oid 订单ID
     * @return 操作结果
     */
    @RequestMapping("/confirmReceive")
    @ResponseBody
    public String confirmReceive(@RequestParam("oid") String oid) {
        boolean result = orderService.confirmReceive(oid);
        if (result) {
            return "success";
        } else {
            return "error";
        }
    }

    /**
     * 取消订单
     *
     * @param oid 订单ID
     * @return 操作结果
     */
    @RequestMapping("/cancel")
    @ResponseBody
    public String cancelOrder(@RequestParam("oid") String oid) {
        boolean result = orderService.cancelOrder(oid);
        if (result) {
            return "success";
        } else {
            return "error";
        }
    }

    /**
     * 更新收货地址
     *
     * @param oid     订单ID
     * @param address 新地址
     * @return 操作结果
     */
    @RequestMapping("/updateAddress")
    @ResponseBody
    public String updateAddress(@RequestParam("oid") String oid, @RequestParam("address") String address) {
        boolean result = orderService.updateAddress(oid, address);
        if (result) {
            return "success";
        } else {
            return "error";
        }
    }

    /**
     * 从购物车创建订单
     *
     * @param order       订单对象
     * @param cartitemIds 购物车项ID列表
     * @param session     用户会话
     * @return 订单成功页面
     */
    @RequestMapping("/createOrderFromCart")
    public String createOrderFromCart(Order order, @RequestParam("cartitemIds") List<String> cartitemIds, HttpSession session, Model model) {
        // 从会话中获取当前登录用户
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/jsps/user/login.jsp";
        }

        // 设置订单用户ID
        order.setUid(user.getUid());

        // 从购物车创建订单
        String oid = orderService.createOrderFromCart(order, cartitemIds);

        // 将订单ID和订单对象存入会话，用于后续操作
        session.setAttribute("oid", oid);

        // 查询订单详情并存储在session中，以便在页面显示订单金额等信息
        Order createdOrder = orderService.findByOid(oid);
        session.setAttribute("order", createdOrder);

        return "redirect:/jsps/order/ordersucc.jsp";
    }

    /**
     * AJAX从购物车创建订单
     *
     * @param order       订单对象
     * @param cartitemIds 购物车项ID列表
     * @param session     用户会话
     * @return JSON结果
     */
    @RequestMapping("/createOrderFromCartAjax")
    @ResponseBody
    public java.util.Map<String, Object> createOrderFromCartAjax(Order order, @RequestParam("cartitemIds") List<String> cartitemIds, HttpSession session) {
        java.util.Map<String, Object> result = new java.util.HashMap<>();

        // 从会话中获取当前登录用户
        User user = (User) session.getAttribute("user");
        if (user == null) {
            result.put("success", false);
            result.put("message", "用户未登录");
            return result;
        }

        try {
            // 设置订单用户ID
            order.setUid(user.getUid());

            // 从购物车创建订单
            String oid = orderService.createOrderFromCart(order, cartitemIds);

            result.put("success", true);
            result.put("oid", oid);
            result.put("message", "订单创建成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "订单创建失败：" + e.getMessage());
        }

        return result;
    }
}
