package com.gg.goods.mapper;

import com.gg.goods.entity.AdminRole;

import java.util.List;

/**
 * 管理员角色关联Mapper接口
 */
public interface AdminRoleMapper {
    /**
     * 根据管理员ID和角色ID删除关联
     */
    int deleteByAdminIdAndRoleId(AdminRole adminRole);

    /**
     * 根据管理员ID删除所有关联
     */
    int deleteByAdminId(String adminId);

    /**
     * 插入管理员角色关联
     */
    int insert(AdminRole adminRole);

    /**
     * 批量插入管理员角色关联
     */
    int insertBatch(List<AdminRole> adminRoles);

    /**
     * 根据管理员ID查询角色关联列表
     */
    List<AdminRole> selectByAdminId(String adminId);

    /**
     * 根据角色ID查询管理员关联列表
     */
    List<AdminRole> selectByRoleId(String roleId);
}