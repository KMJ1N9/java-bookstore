package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * @TableName cartitem
 */
@Data  //直接提供给你get set   toString
@NoArgsConstructor  //无参构造器
@AllArgsConstructor  //有参构造器
public class Cartitem implements Serializable {
    /**
     *
     */
    private String cartitemid;

    /**
     *
     */
    private Integer quantity;

    /**
     *
     */
    private String bid;

    /**
     *
     */
    private String uid;

    /**
     *
     */
    private Integer shunxu;

    private static final long serialVersionUID = 1L;
}