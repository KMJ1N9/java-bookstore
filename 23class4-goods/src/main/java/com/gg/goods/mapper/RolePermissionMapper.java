package com.gg.goods.mapper;

import com.gg.goods.entity.RolePermission;

import java.util.List;

/**
 * 角色权限关联Mapper接口
 */
public interface RolePermissionMapper {
    /**
     * 根据角色ID和权限ID删除关联
     */
    int deleteByRoleIdAndPermissionId(RolePermission rolePermission);

    /**
     * 根据角色ID删除所有关联
     */
    int deleteByRoleId(String roleId);

    /**
     * 根据权限ID删除所有关联
     */
    int deleteByPermissionId(String permissionId);

    /**
     * 插入角色权限关联
     */
    int insert(RolePermission rolePermission);

    /**
     * 批量插入角色权限关联
     */
    int insertBatch(List<RolePermission> rolePermissions);

    /**
     * 根据权限ID查询角色关联列表
     */
    List<RolePermission> selectByPermissionId(String permissionId);
}