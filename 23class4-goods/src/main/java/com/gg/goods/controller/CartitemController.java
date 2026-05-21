package com.gg.goods.controller;

import com.gg.goods.entity.Cartitem;
import com.gg.goods.povos.CartBookPovo;
import com.gg.goods.service.CartitemService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/cart")
@Slf4j
public class CartitemController {
    @Autowired
    private CartitemService cartitemService;

    /*添加购物车*/
    @RequestMapping("/addCart")
    public String addCart(Cartitem cartitem) {
        // 生成购物车项ID
        cartitem.setCartitemid(UUID.randomUUID().toString().replace("-", ""));
        log.debug("添加购物车项: {}", cartitem);
        /*调用业务层实现添加购物车业务*/
        cartitemService.addCart(cartitem);
        /*重新请求查询全部购物车条目显示*/
        return "redirect:/cart/getCartitemsByUid?uid=" + cartitem.getUid();
    }

    /*查询当前用户的购物车条目们*/
    @RequestMapping("/getCartitemsByUid")
    public String getCartitemsByUid(Model model, String uid) {
        List<CartBookPovo> cartBookPovos = cartitemService.getCartitemsByUid(uid);
        model.addAttribute("cartBookPovos", cartBookPovos);
        model.addAttribute("uid", uid);
        return "jsps/cart/list";
    }

    /*删除单个购物车项*/
    @RequestMapping("/deleteCartitem")
    public String deleteCartitem(String cartitemid, String uid) {
        cartitemService.deleteCartitem(cartitemid);
        return "redirect:/cart/getCartitemsByUid?uid=" + uid;
    }

    /*批量删除购物车项*/
    @RequestMapping("/batchDeleteCartitems")
    public String batchDeleteCartitems(@RequestParam("cartitemIds") String[] cartitemIds, String uid) {
        List<String> ids = Arrays.asList(cartitemIds);
        cartitemService.batchDeleteCartitems(ids);
        return "redirect:/cart/getCartitemsByUid?uid=" + uid;
    }

    /*清空购物车*/
    @RequestMapping("/clearCart")
    public String clearCart(String uid) {
        cartitemService.clearCart(uid);
        return "redirect:/cart/getCartitemsByUid?uid=" + uid;
    }

    /*更新购物车项数量*/
    @RequestMapping("/updateQuantity")
    public String updateQuantity(String cartitemid, Integer quantity, String uid) {
        Cartitem cartitem = new Cartitem();
        cartitem.setCartitemid(cartitemid);
        cartitem.setQuantity(quantity);
        cartitemService.updateCartitemQuantity(cartitem);
        return "redirect:/cart/getCartitemsByUid?uid=" + uid;
    }
}