package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

/**
 * 管理员实体类
 */
@Data  // 提供get set toString方法
@NoArgsConstructor  // 无参构造器
@AllArgsConstructor  // 有参构造器
public class Admin implements Serializable {
    /**
     * 管理员ID
     */
    private String adminId;

    /**
     * 管理员用户名
     */
    private String adminname;

    /**
     * 管理员密码
     */
    private String adminpwd;

    /**
     * 管理员角色列表
     */
    private List<Role> roles;

    private static final long serialVersionUID = 1L;
}