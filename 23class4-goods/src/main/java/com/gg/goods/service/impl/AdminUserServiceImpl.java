package com.gg.goods.service.impl;

import com.gg.goods.entity.Order;
import com.gg.goods.entity.User;
import com.gg.goods.mapper.CartitemMapper;
import com.gg.goods.mapper.OrderMapper;
import com.gg.goods.mapper.UserMapper;
import com.gg.goods.service.AdminUserService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

/**
 * 管理员用户管理服务实现类
 */
@Service("adminUserService")
public class AdminUserServiceImpl implements AdminUserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private CartitemMapper cartitemMapper;

    @Override
    public PageInfo<User> findAllUsers(Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<User> users = userMapper.selectAllUsers();
        return new PageInfo<>(users);
    }

    @Override
    public User findUserByUid(String uid) {
        return userMapper.selectByPrimaryKey(uid);
    }

    /**
     * 添加用户
     *
     * @param user 用户对象
     * @return 受影响的行数
     */
    @Override
    public Integer addUser(User user) {
        // 生成更短的唯一用户ID（截取UUID前16位）
        String shortUid = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        user.setUid(shortUid);
        // 设置默认密码"123456"
        user.setLoginpass("123456");
        // 设置用户状态为1（已激活）
        user.setStatus(1);
        // 直接返回插入结果
        return userMapper.insertSelective(user);
    }

    @Override
    public boolean updateUser(User user) {
        return userMapper.updateByPrimaryKeySelective(user) > 0;
    }

    @Override
    public boolean deleteUser(String uid) {
        // 先检查用户是否有相关订单
        List<Order> orders = orderMapper.selectByUid(uid);
        if (orders != null && !orders.isEmpty()) {
            // 如果用户有订单，不允许删除
            return false;
        }

        // 检查用户是否有购物车项目
        List cartBookPovos = cartitemMapper.selectCartitemBookByUid(uid);
        if (cartBookPovos != null && !cartBookPovos.isEmpty()) {
            // 如果用户有购物车项目，不允许删除
            return false;
        }

        // 如果没有订单和购物车项目，执行删除操作
        return userMapper.deleteByPrimaryKey(uid) > 0;
    }

    @Override
    public PageInfo<User> findUsersByLoginname(String loginname, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<User> users = userMapper.selectUsersByLoginname(loginname);
        return new PageInfo<>(users);
    }

    @Override
    public boolean updateUserStatus(String uid, Integer status) {
        User user = new User();
        user.setUid(uid);
        user.setStatus(status);
        return userMapper.updateByPrimaryKeySelective(user) > 0;
    }
}