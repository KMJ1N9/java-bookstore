package com.gg.goods.service.impl;

import com.gg.goods.entity.Cartitem;
import com.gg.goods.mapper.CartitemMapper;
import com.gg.goods.povos.CartBookPovo;
import com.gg.goods.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CartServiceImpl implements CartService {

    @Autowired
    private CartitemMapper cartitemMapper;

    @Override
    public void addToCart(Cartitem cartitem) {
        // 检查购物车中是否已存在该商品
        Cartitem existingItem = getCartItemByUidAndBid(cartitem.getUid(), cartitem.getBid());
        if (existingItem != null) {
            // 已存在，更新数量
            existingItem.setQuantity(existingItem.getQuantity() + cartitem.getQuantity());
            cartitemMapper.updateCartItemQuantity(existingItem);
        } else {
            // 不存在，新增购物车项
            cartitemMapper.insert(cartitem);
        }
    }

    @Override
    public List<CartBookPovo> getCartByUid(String uid) {
        return cartitemMapper.selectCartitemBookByUid(uid);
    }

    @Override
    public void updateCartItemQuantity(String cartitemid, Integer quantity) {
        Cartitem cartitem = new Cartitem();
        cartitem.setCartitemid(cartitemid);
        cartitem.setQuantity(quantity);
        cartitemMapper.updateCartItemQuantity(cartitem);
    }

    @Override
    public void removeCartItem(String cartitemid) {
        cartitemMapper.removeCartItem(cartitemid);
    }

    @Override
    public void batchRemoveCartItems(List<String> cartitemIds) {
        cartitemMapper.batchRemoveCartItems(cartitemIds);
    }

    @Override
    public void clearCart(String uid) {
        cartitemMapper.clearCartByUserId(uid);
    }

    @Override
    public Cartitem getCartItemByUidAndBid(String uid, String bid) {
        Cartitem cartitem = new Cartitem();
        cartitem.setUid(uid);
        cartitem.setBid(bid);
        return cartitemMapper.selectCartitemByUidAndBid(cartitem);
    }
}