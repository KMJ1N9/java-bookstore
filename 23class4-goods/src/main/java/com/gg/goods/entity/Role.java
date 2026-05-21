package com.gg.goods.entity;

import lombok.Data;

import java.util.List;

/**
 * 角色实体类
 */
@Data
public class Role {
    private String roleId;         // 角色ID
    private String roleName;       // 角色名称
    private String description;    // 角色描述

    // 一对多关系：一个角色拥有多个权限
    private List<Permission> permissions;
}