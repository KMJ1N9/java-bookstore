package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 管理员角色关联实体类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdminRole implements Serializable {
    /**
     * 管理员ID
     */
    private String adminId;

    /**
     * 角色ID
     */
    private String roleId;

    private static final long serialVersionUID = 1L;
}