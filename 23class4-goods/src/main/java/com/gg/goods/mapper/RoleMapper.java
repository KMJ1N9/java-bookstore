package com.gg.goods.mapper;

import com.gg.goods.entity.Role;
import com.gg.goods.entity.RolePermission;

import java.util.List;

/**
 * 角色Mapper接口
 */
public interface RoleMapper {
    /**
     * 根据主键删除角色
     */
    int deleteByPrimaryKey(String roleId);

    /**
     * 插入角色
     */
    int insert(Role record);

    /**
     * 选择性插入角色
     */
    int insertSelective(Role record);

    /**
     * 根据主键查询角色
     */
    Role selectByPrimaryKey(String roleId);

    /**
     * 选择性更新角色
     */
    int updateByPrimaryKeySelective(Role record);

    /**
     * 更新角色
     */
    int updateByPrimaryKey(Role record);

    /**
     * 查询所有角色
     */
    List<Role> selectAllRoles();

    /**
     * 根据管理员ID查询角色列表
     */
    List<Role> selectRolesByAdminId(String adminId);

    /**
     * 给角色分配权限
     */
    int insertRolePermissions(List<RolePermission> rolePermissions);

    /**
     * 根据角色ID删除角色权限关联
     */
    int deleteRolePermissionsByRoleId(String roleId);

    /**
     * 根据角色ID查询角色权限列表
     */
    List<RolePermission> selectRolePermissionsByRoleId(String roleId);
}