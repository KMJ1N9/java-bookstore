package com.gg.goods.service;

import com.gg.goods.entity.Cartitem;
import com.gg.goods.mapper.CartitemMapper;
import com.gg.goods.povos.CartBookPovo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CartitemService {
    @Autowired
    private CartitemMapper cartitemMapper;

    /*按uid 查询购物车条目们*/
    public List<CartBookPovo> getCartitemsByUid(String uid) {
        return cartitemMapper.selectCartitemBookByUid(uid);
    }

    /*添加购物车条目业务*/
    @Transactional
    public void addCart(Cartitem cartitem) {
        /*1.先判定该用户之前是否购物车条目中有这本书*/
        /*
         * select  *  from  cartitem  where  uid = ?  and  bid = ?
         * */
        Cartitem cart = cartitemMapper.selectCartitemByUidAndBid(cartitem);
        if (cart == null) {
            /*2.说明之前没有买过， 做 insert 操作*/
            cartitemMapper.insert(cartitem);
        } else {
            /*3. 之前买过， 直接设置为新的数量，不再叠加*/
            cart.setQuantity(cartitem.getQuantity());
            cartitemMapper.updateByPrimaryKey(cart);
        }
    }

    /*删除单个购物车项*/
    @Transactional
    public void deleteCartitem(String cartitemid) {
        cartitemMapper.removeCartItem(cartitemid);
    }

    /*批量删除购物车项*/
    @Transactional
    public void batchDeleteCartitems(List<String> cartitemIds) {
        cartitemMapper.batchRemoveCartItems(cartitemIds);
    }

    /*清空购物车*/
    @Transactional
    public void clearCart(String uid) {
        cartitemMapper.clearCartByUserId(uid);
    }

    /*更新购物车项数量*/
    @Transactional
    public void updateCartitemQuantity(Cartitem cartitem) {
        cartitemMapper.updateCartItemQuantity(cartitem);
    }

    /*根据用户ID和图书ID查询购物车项*/
    public Cartitem getCartitemByUidAndBid(String uid, String bid) {
        Cartitem cartitem = new Cartitem();
        cartitem.setUid(uid);
        cartitem.setBid(bid);
        return cartitemMapper.selectCartitemByUidAndBid(cartitem);
    }

    /*根据购物车项ID列表查询购物车项和图书信息*/
    public List<CartBookPovo> getCartitemsByIds(List<String> cartitemIds) {
        return cartitemMapper.selectCartitemBookByIds(cartitemIds);
    }
}
