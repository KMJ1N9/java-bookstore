package com.gg.goods.service;

import com.gg.goods.entity.User;
import com.github.pagehelper.PageInfo;

/**
 * 管理员用户管理服务接口
 */
public interface AdminUserService {

    /**
     * 分页查询所有用户
     *
     * @param pageNum  页码
     * @param pageSize 每页大小
     * @return 分页用户列表
     */
    PageInfo<User> findAllUsers(Integer pageNum, Integer pageSize);

    /**
     * 根据ID查询用户
     *
     * @param uid 用户ID
     * @return 用户对象
     */
    User findUserByUid(String uid);

    /**
     * 添加新用户
     *
     * @param user 用户对象
     * @return 添加结果
     */
    Integer addUser(User user);

    /**
     * 更新用户信息
     *
     * @param user 用户对象
     * @return 更新结果
     */
    boolean updateUser(User user);

    /**
     * 删除用户
     *
     * @param uid 用户ID
     * @return 删除结果
     */
    boolean deleteUser(String uid);

    /**
     * 根据用户名模糊查询用户
     *
     * @param loginname 用户名
     * @param pageNum   页码
     * @param pageSize  每页大小
     * @return 分页用户列表
     */
    PageInfo<User> findUsersByLoginname(String loginname, Integer pageNum, Integer pageSize);

    /**
     * 启用或禁用用户
     *
     * @param uid    用户ID
     * @param status 状态值（0：未激活，1：已激活）
     * @return 操作结果
     */
    boolean updateUserStatus(String uid, Integer status);
}