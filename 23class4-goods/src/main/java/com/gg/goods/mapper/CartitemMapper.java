package com.gg.goods.mapper;

import com.gg.goods.entity.Cartitem;
import com.gg.goods.povos.CartBookPovo;

import java.util.List;

/**
 * @Entity com.gg.goods.entity.Cartitem
 */
public interface CartitemMapper {

    int deleteByPrimaryKey(String id);

    int insert(Cartitem record);

    int insertSelective(Cartitem record);

    Cartitem selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Cartitem record);

    int updateByPrimaryKey(Cartitem record);

    /*
        * SELECT
        cartitem.cartItemId,
        cartitem.quantity,
        cartitem.bid,
        book.image_b,
        book.bname,
        book.currPrice
        FROM  cartitem ,  book
        WHERE cartitem.bid = book.bid
        AND cartitem.uid = ?
    *
    * */
    List<CartBookPovo> selectCartitemBookByUid(String uid);

    Cartitem selectCartitemByUidAndBid(Cartitem cartitem);

    /**
     * 根据cartitemid删除购物车项
     */
    int removeCartItem(String cartitemid);

    /**
     * 批量删除购物车项
     */
    int batchRemoveCartItems(List<String> cartitemIds);

    /**
     * 根据用户ID清空购物车
     */
    int clearCartByUserId(String uid);

    /**
     * 更新购物车项数量
     */
    int updateCartItemQuantity(Cartitem cartitem);

    /**
     * 根据购物车项ID列表查询购物车项和图书信息
     */
    List<CartBookPovo> selectCartitemBookByIds(List<String> cartitemIds);
}
