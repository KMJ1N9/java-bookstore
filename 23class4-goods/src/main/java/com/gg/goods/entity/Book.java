package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * @TableName book
 */
@Data  //直接提供给你get set   toString
@NoArgsConstructor  //无参构造器
@AllArgsConstructor  //有参构造器
public class Book implements Serializable {


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
    private String author;

    /**
     *
     */
    private BigDecimal price;

    /**
     *
     */
    private BigDecimal currprice;

    /**
     *
     */
    private BigDecimal discount;

    /**
     *
     */
    private String press;

    /**
     *
     */
    private String publishtime;

    /**
     *
     */
    private Integer edition;

    /**
     *
     */
    private Integer pagenum;

    /**
     *
     */
    private Integer wordnum;

    /**
     *
     */
    private String printtime;

    /**
     *
     */
    private String booksize;

    /**
     *
     */
    private String paper;

    /**
     *
     */
    private String cid;

    /**
     *
     */
    private String imageW;

    /**
     *
     */
    private String imageB;

    /**
     *
     */
    private Integer shunxu;

    private static final long serialVersionUID = 1L;
}