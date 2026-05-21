package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;

/**
 * 图书库存实体类
 *
 * @TableName stock
 */
@Data  //直接提供get set toString
@NoArgsConstructor  //无参构造器
@AllArgsConstructor  //有参构造器
public class Stock implements Serializable {
    /**
     * 库存ID
     */
    private String sid;

    /**
     * 图书ID
     */
    private String bid;

    /**
     * 书名，方便查看
     */
    private String bname;

    /**
     * 当前库存量
     */
    private Integer quantity;

    /**
     * 最低库存预警
     */
    private Integer minQuantity;

    /**
     * 库存状态（1:不足 0:正常）
     */
    private Integer status;

    /**
     * 最后更新时间
     */
    private Date updateTime;

    private static final long serialVersionUID = 1L;
}