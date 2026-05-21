package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

/**
 * 购物车实体类
 */
@Data  //直接提供get set toString
@NoArgsConstructor  //无参构造器
@AllArgsConstructor  //有参构造器
public class Cart implements Serializable {
    /**
     * 用户ID
     */
    private String uid;

    /**
     * 购物车商品总数量
     */
    private Integer totalQuantity;

    /**
     * 购物车商品总金额
     */
    private Double totalPrice;

    /**
     * 购物车商品列表
     */
    private List<Cartitem> cartitems;

    private static final long serialVersionUID = 1L;
}