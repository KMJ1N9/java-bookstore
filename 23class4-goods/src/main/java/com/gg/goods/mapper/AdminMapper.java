package com.gg.goods.mapper;

import com.gg.goods.entity.Admin;

/**
 * @author AdminMapper
 */
public interface AdminMapper {

    /**
     * 根据主键删除管理员
     */
    int deleteByPrimaryKey(String adminId);

    /**
     * 插入管理员
     */
    int insert(Admin record);

    /**
     * 选择性插入管理员
     */
    int insertSelective(Admin record);

    /**
     * 根据主键查询管理员
     */
    Admin selectByPrimaryKey(String adminId);

    /**
     * 选择性更新管理员
     */
    int updateByPrimaryKeySelective(Admin record);

    /**
     * 更新管理员
     */
    int updateByPrimaryKey(Admin record);

    /**
     * 根据管理员用户名查询管理员
     */
    Admin selectByAdminname(String adminname);

    /**
     * 根据管理员ID查询管理员信息（包含角色）
     */
    Admin selectByAdminIdWithRoles(String adminId);

    /**
     * 根据用户名查询管理员信息（包含角色）
     */
    Admin selectByAdminnameWithRoles(String adminname);
}