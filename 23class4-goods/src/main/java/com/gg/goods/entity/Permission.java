package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 权限实体类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Permission implements Serializable {
    /**
     * 权限ID
     */
    private String permissionId;

    /**
     * 权限名称
     */
    private String permissionName;

    /**
     * 权限标识（用于权限检查）
     */
    private String permissionCode;

    /**
     * 权限描述
     */
    private String description;

    /**
     * 所属模块
     */
    private String module;

    private static final long serialVersionUID = 1L;
}