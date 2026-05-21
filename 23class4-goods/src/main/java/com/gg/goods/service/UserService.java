package com.gg.goods.service;

import com.gg.goods.entity.User;
import com.gg.goods.povos.ActivationPovo;

public interface UserService {

    /**
     * 用户注册
     */
    boolean regist(User user);

    /**
     * 根据用户名查找用户
     */
    User getUserByLoginname(String loginname);

    /**
     * 根据用户ID查找用户
     */
    User getUserByUid(String uid);

    /**
     * 修改用户密码
     */
    boolean updateUserPassword(String uid, String newPassword);

    /**
     * 更新用户资料
     */
    boolean updateUserInfo(User user);

    /**
     * 更新用户头像
     */
    boolean updateUserAvatar(String uid, String avatarPath);

    /**
     * 发送激活邮件
     */
    void sendActivationEmail(String email, String activationCode);

    /**
     * 激活用户账户
     */
    boolean activateUser(String activationCode);

    /**
     * 检查用户登录状态
     */
    boolean isActivated(String loginname);

    /**
     * 校验用户名是否可用
     */
    Boolean verifyLoginname(String loginname);

    /**
     * 校验邮箱是否可用
     */
    Boolean verifyEmail(String email);

    /**
     * 用户登录
     */
    User login(User user);

    /**
     * 激活用户账户（返回详细信息）
     */
    ActivationPovo activation(String activationCode);

    /**
     * 根据邮箱查找用户
     */
    User getUserByEmail(String email);

    /**
     * 发送重置密码邮件
     */
    boolean sendResetPasswordEmail(String email);

    /**
     * 验证重置密码令牌（仅检查token有效性，不验证验证码）
     */
    boolean validateResetToken(String token);

    /**
     * 重置用户密码（包含验证码验证）
     */
    boolean resetPassword(String token, String verificationCode, String newPassword);
}