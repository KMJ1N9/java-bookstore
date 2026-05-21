package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * @TableName orderitem
 */
@Data  //直接提供给你get set   toString
@NoArgsConstructor  //无参构造器
@AllArgsConstructor  //有参构造器
public class Orderitem implements Serializable {
    /**
     *
     */
    private String orderitemid;

    /**
     *
     */
    private Integer quantity;

    /**
     *
     */
    private BigDecimal subtotal;

    /**
     *
     */
    private String bid;

    /**
     *
     */
    private String bname;

    /**
     *
     */
    private BigDecimal currprice;

    /**
     *
     */
    private String imageB;

    /**
     *
     */
    private String oid;

    private static final long serialVersionUID = 1L;
}