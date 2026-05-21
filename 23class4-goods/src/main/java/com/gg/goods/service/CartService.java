package com.gg.goods.service;

import com.gg.goods.entity.Cartitem;
import com.gg.goods.povos.CartBookPovo;

import java.util.List;

public interface CartService {

    /**
     * 添加商品到购物车
     */
    void addToCart(Cartitem cartitem);

    /**
     * 根据用户ID获取购物车列表
     */
    List<CartBookPovo> getCartByUid(String uid);

    /**
     * 更新购物车商品数量
     */
    void updateCartItemQuantity(String cartitemid, Integer quantity);

    /**
     * 删除单个购物车项
     */
    void removeCartItem(String cartitemid);

    /**
     * 批量删除购物车项
     */
    void batchRemoveCartItems(List<String> cartitemIds);

    /**
     * 清空购物车
     */
    void clearCart(String uid);

    /**
     * 根据用户ID和书籍ID查询购物车项
     */
    Cartitem getCartItemByUidAndBid(String uid, String bid);
}