package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * @TableName category
 */
@Data  //直接提供给你get set   toString
@NoArgsConstructor  //无参构造器
@AllArgsConstructor  //有参构造器
public class Category implements Serializable {
    /**
     *
     */
    private String cid;

    /**
     *
     */
    private String cname;

    /**
     *
     */
    private String pid;

    /**
     *
     */
    private String miaoshu;

    /**
     *
     */
    private Integer shunxu;

    private static final long serialVersionUID = 1L;
}