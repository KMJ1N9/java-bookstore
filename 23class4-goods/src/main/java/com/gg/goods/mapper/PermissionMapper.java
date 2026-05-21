package com.gg.goods.mapper;

import com.gg.goods.entity.Permission;

import java.util.List;

/**
 * 权限Mapper接口
 */
public interface PermissionMapper {
    /**
     * 根据主键删除权限
     */
    int deleteByPrimaryKey(String permissionId);

    /**
     * 插入权限
     */
    int insert(Permission record);

    /**
     * 选择性插入权限
     */
    int insertSelective(Permission record);

    /**
     * 根据主键查询权限
     */
    Permission selectByPrimaryKey(String permissionId);

    /**
     * 选择性更新权限
     */
    int updateByPrimaryKeySelective(Permission record);

    /**
     * 更新权限
     */
    int updateByPrimaryKey(Permission record);

    /**
     * 查询所有权限
     */
    List<Permission> selectAllPermissions();

    /**
     * 根据角色ID查询权限列表
     */
    List<Permission> selectPermissionsByRoleId(String roleId);

    /**
     * 根据管理员ID查询权限列表
     */
    List<Permission> selectPermissionsByAdminId(String adminId);

    /**
     * 根据模块查询权限
     */
    List<Permission> selectPermissionsByModule(String module);
}