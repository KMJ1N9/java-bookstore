package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * @TableName order
 */
@Data  //直接提供给你get set   toString
@NoArgsConstructor  //无参构造器
@AllArgsConstructor  //有参构造器
public class Order implements Serializable {
    /**
     *
     */
    private String oid;

    /**
     *
     */
    private Date ordertime;

    /**
     *
     */
    private BigDecimal total;

    /**
     *
     */
    private Integer status;

    /**
     *
     */
    private String address;

    /**
     *
     */
    private String uid;

    /**
     * 订单项列表
     */
    private List<Orderitem> orderItems;

    private static final long serialVersionUID = 1L;

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

}