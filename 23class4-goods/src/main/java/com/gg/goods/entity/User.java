package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * @TableName user
 */
@Data  //直接提供给你get set   toString
@NoArgsConstructor  //无参构造器
@AllArgsConstructor  //有参构造器
public class User implements Serializable {
    /**
     *
     */
    private String uid;

    /**
     *
     */
    private String loginname;

    /**
     *
     */
    private String loginpass;

    /**
     *
     */
    private String email;

    /**
     *
     */
    private Integer status;

    /**
     * 激活码
     */
    private String activationcode;
}