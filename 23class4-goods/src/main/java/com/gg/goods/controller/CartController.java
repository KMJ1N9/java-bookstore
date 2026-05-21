package com.gg.goods.controller;

import com.gg.goods.entity.Cartitem;
import com.gg.goods.povos.CartBookPovo;
import com.gg.goods.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    /**
     * 添加商品到购物车
     */
    @PostMapping("/add")
    public Map<String, Object> addToCart(@RequestBody Cartitem cartitem) {
        Map<String, Object> result = new HashMap<>();
        try {
            cartService.addToCart(cartitem);
            result.put("success", true);
            result.put("message", "添加购物车成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "添加购物车失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 获取购物车列表
     */
    @GetMapping("/list")
    public Map<String, Object> getCartList(@RequestParam String uid) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<CartBookPovo> cartList = cartService.getCartByUid(uid);
            result.put("success", true);
            result.put("data", cartList);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取购物车失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 更新购物车商品数量
     */
    @PostMapping("/update/quantity")
    public Map<String, Object> updateQuantity(@RequestParam String cartitemid, @RequestParam Integer quantity) {
        Map<String, Object> result = new HashMap<>();
        try {
            cartService.updateCartItemQuantity(cartitemid, quantity);
            result.put("success", true);
            result.put("message", "更新成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "更新失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 删除购物车项
     */
    @GetMapping("/deleteCartitem")
    public Map<String, Object> removeCartItem(@RequestParam String cartitemid, @RequestParam String uid) {
        Map<String, Object> result = new HashMap<>();
        try {
            cartService.removeCartItem(cartitemid);
            result.put("success", true);
            result.put("message", "删除成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "删除失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 批量删除购物车项
     */
    @PostMapping("/batchDeleteCartitems")
    public Map<String, Object> batchRemoveCartItems(@RequestParam List<String> cartitemIds, @RequestParam String uid) {
        Map<String, Object> result = new HashMap<>();
        try {
            cartService.batchRemoveCartItems(cartitemIds);
            result.put("success", true);
            result.put("message", "批量删除成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "批量删除失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 清空购物车
     */
    @DeleteMapping("/clear/{uid}")
    public Map<String, Object> clearCart(@PathVariable String uid) {
        Map<String, Object> result = new HashMap<>();
        try {
            cartService.clearCart(uid);
            result.put("success", true);
            result.put("message", "清空购物车成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "清空购物车失败：" + e.getMessage());
        }
        return result;
    }
}