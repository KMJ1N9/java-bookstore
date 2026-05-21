package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 角色权限关联实体类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RolePermission implements Serializable {
    /**
     * 角色ID
     */
    private String roleId;

    /**
     * 权限ID
     */
    private String permissionId;

    private static final long serialVersionUID = 1L;
}