package com.gg.goods.service.impl;

import com.gg.goods.entity.User;
import com.gg.goods.exception.BusinessException;
import com.gg.goods.exception.DatabaseException;
import com.gg.goods.helpers.PasswordHelper;
import com.gg.goods.mapper.UserMapper;
import com.gg.goods.povos.ActivationPovo;
import com.gg.goods.service.UserService;
import com.gg.goods.validator.ValidationUtils;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
@Slf4j
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private JavaMailSender javaMailSender;

    // 使用ConcurrentHashMap存储重置密码令牌，实际项目中应该使用数据库
    private final Map<String, String> resetTokenStore = new ConcurrentHashMap<>();

    // 密码重置令牌内部类
    private static class PasswordResetToken {
        private String userId;
        private long expirationTime;

        public PasswordResetToken(String userId) {
            this.userId = userId;
            // 24小时过期
            this.expirationTime = System.currentTimeMillis() + 24 * 60 * 60 * 1000;
        }

        public String getUserId() {
            return userId;
        }

        public boolean isExpired() {
            return System.currentTimeMillis() > expirationTime;
        }
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "user", key = "#user.loginname"),
            @CacheEvict(value = "user", key = "#user.email"),
            @CacheEvict(value = "userCheck", allEntries = true)
    })
    public boolean regist(User user) {
        log.info("用户注册请求开始 - 用户名: {}, 邮箱: {}", user.getLoginname(), user.getEmail());

        // 验证用户名
        if (user.getLoginname() == null || !ValidationUtils.isUsernameValid(user.getLoginname())) {
            log.warn("用户名验证失败，接收到的用户名: {}", user.getLoginname());
            throw new BusinessException("用户名格式不正确，只能包含字母、数字和下划线，长度3-20位");
        }
        log.debug("用户名验证通过: {}", user.getLoginname());

        // 验证密码
        if (user.getLoginpass() == null || user.getLoginpass().length() < 6) {
            log.warn("密码验证失败，长度不足6位");
            throw new BusinessException("密码长度不能少于6位");
        }
        log.debug("密码长度验证通过");

        // 验证邮箱
        if (user.getEmail() == null || !ValidationUtils.isEmailValid(user.getEmail())) {
            log.warn("邮箱验证失败，接收到的邮箱: {}", user.getEmail());
            throw new BusinessException("邮箱格式不正确");
        }
        log.debug("邮箱格式验证通过: {}", user.getEmail());

        // 验证用户名是否已存在
        log.debug("开始检查用户名是否已存在: {}", user.getLoginname());
        User existingUser = userMapper.selectUserByLoginname(user.getLoginname());
        if (existingUser != null) {
            log.warn("用户名已存在: {}", user.getLoginname());
            throw new BusinessException("用户名已存在");
        }
        log.debug("用户名可用: {}", user.getLoginname());

        // 验证邮箱是否已存在
        log.debug("开始检查邮箱是否已存在: {}", user.getEmail());
        existingUser = userMapper.selectUserByEmail(user.getEmail());
        if (existingUser != null) {
            log.warn("邮箱已存在: {}", user.getEmail());
            throw new BusinessException("邮箱已存在");
        }
        log.debug("邮箱可用: {}", user.getEmail());

        // 加密密码
        log.debug("开始加密密码");
        String encryptedPassword = PasswordHelper.encrypt(user.getLoginpass());
        user.setLoginpass(encryptedPassword);
        log.debug("密码加密完成，加密后的密码长度: {}", encryptedPassword.length());

        // 设置激活状态为未激活
        user.setStatus(0);
        log.debug("设置用户激活状态为未激活(0)");

        // 生成激活码
        String activationCode = UUID.randomUUID().toString();
        user.setActivationcode(activationCode);
        log.debug("生成激活码: {}", activationCode);

        // 生成uid，截取UUID的前16位以符合数据库字段长度限制
        String uid = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        user.setUid(uid);
        log.debug("生成用户ID: {}", uid);

        // 保存到数据库
        try {
            log.debug("开始保存用户信息到数据库");
            int result = userMapper.insert(user);
            if (result == 0) {
                log.error("用户信息插入数据库失败，受影响行数为0");
                throw new DatabaseException("用户注册失败");
            }
            // 发送激活邮件
            sendActivationEmail(user.getEmail(), activationCode);
            log.info("激活邮件已发送 - 邮箱: {}", user.getEmail());
            log.info("用户注册成功 - 用户名: {}, 用户ID: {}", user.getLoginname(), user.getUid());
            return true;
        } catch (DatabaseException e) {
            log.error("用户注册数据库异常: {}", e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("用户注册系统异常: {}", e.getMessage(), e);
            throw new DatabaseException("注册失败", e);
        }
    }

    @Override
    public User login(User user) {
        // 参数验证
        if (user.getLoginname() == null || user.getLoginname().trim().isEmpty()) {
            throw new BusinessException("用户名不能为空");
        }
        if (user.getLoginpass() == null || user.getLoginpass().trim().isEmpty()) {
            throw new BusinessException("密码不能为空");
        }

        // 根据用户名查找用户
        User dbUser = getUserByLoginname(user.getLoginname());
        if (dbUser == null) {
            throw new BusinessException("用户名或密码错误");
        }

        // 检查账号是否激活
        if (dbUser.getStatus() == 0) {
            throw new BusinessException("账号尚未激活，请先激活账号");
        }

        // 验证密码
        if (!PasswordHelper.matches(user.getLoginpass(), dbUser.getLoginpass())) {
            throw new BusinessException("用户名或密码错误");
        }

        return dbUser;
    }

    /**
     * 根据用户名查找用户
     */
    @Override
    @Cacheable(value = "user", key = "#loginname", unless = "#result == null")
    public User getUserByLoginname(String loginname) {
        if (loginname == null || loginname.trim().isEmpty()) {
            throw new BusinessException("用户名不能为空");
        }
        try {
            return userMapper.selectUserByLoginname(loginname);
        } catch (Exception e) {
            throw new DatabaseException("查询用户失败", e);
        }
    }

    /**
     * 根据用户ID查找用户
     */
    @Override
    @Cacheable(value = "user", key = "#uid", unless = "#result == null")
    public User getUserByUid(String uid) {
        if (uid == null || uid.trim().isEmpty()) {
            throw new BusinessException("用户ID不能为空");
        }
        try {
            return userMapper.selectUserByUid(uid);
        } catch (Exception e) {
            throw new DatabaseException("获取用户信息失败", e);
        }
    }

    /**
     * 修改用户密码
     */
    @Override
    @Transactional
    @CacheEvict(value = "user", key = "#uid")
    public boolean updateUserPassword(String uid, String newPassword) {
        try {
            // 输入参数验证
            if (ValidationUtils.isEmpty(uid)) {
                throw new BusinessException("用户ID不能为空");
            }
            if (ValidationUtils.isEmpty(newPassword)) {
                throw new BusinessException("新密码不能为空");
            }
            if (newPassword.length() < 6) {
                throw new BusinessException("密码长度不能少于6位");
            }

            // 检查用户是否存在
            User user = userMapper.selectUserByUid(uid);
            if (user == null) {
                throw new BusinessException("用户不存在");
            }

            // 加密密码
            String encryptedPassword = PasswordHelper.encrypt(newPassword);

            // 调用Mapper方法更新密码
            int result = userMapper.updateUserPassword(uid, encryptedPassword);

            // 返回更新结果
            return result > 0;
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            // 其他异常包装为数据库异常
            throw new DatabaseException("更新密码失败", e);
        }
    }

    /**
     * 更新用户资料
     */
    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "user", key = "#user.uid"),
            @CacheEvict(value = "user", key = "#user.loginname"),
            @CacheEvict(value = "user", key = "#user.email"),
            @CacheEvict(value = "userCheck", allEntries = true)
    })
    public boolean updateUserInfo(User user) {
        try {
            // 输入参数验证
            if (user == null) {
                throw new BusinessException("用户信息不能为空");
            }
            if (ValidationUtils.isEmpty(user.getUid())) {
                throw new BusinessException("用户ID不能为空");
            }

            // 检查用户是否存在
            User existingUser = userMapper.selectUserByUid(user.getUid());
            if (existingUser == null) {
                throw new BusinessException("用户不存在");
            }

            // 调用Mapper方法更新用户信息
            int result = userMapper.updateUserByUid(user);

            // 返回更新结果
            return result > 0;
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            // 其他异常包装为数据库异常
            throw new DatabaseException("更新用户信息失败", e);
        }
    }

    @Override
    @Transactional
    @CacheEvict(value = "user", key = "#uid")
    public boolean updateUserAvatar(String uid, String avatarPath) {
        try {
            // 输入参数验证
            if (ValidationUtils.isEmpty(uid)) {
                throw new BusinessException("用户ID不能为空");
            }
            if (ValidationUtils.isEmpty(avatarPath)) {
                throw new BusinessException("头像路径不能为空");
            }

            // 检查用户是否存在
            User user = userMapper.selectUserByUid(uid);
            if (user == null) {
                throw new BusinessException("用户不存在");
            }

            // 调用Mapper方法更新头像
            int result = userMapper.updateUserAvatar(uid, avatarPath);

            // 返回更新结果
            return result > 0;
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            // 其他异常包装为数据库异常
            throw new DatabaseException("更新头像失败", e);
        }
    }

    @Override
    public void sendActivationEmail(String email, String activationCode) {
        try {
            // 输入参数验证
            if (ValidationUtils.isEmpty(email)) {
                throw new BusinessException("邮箱不能为空");
            }
            if (ValidationUtils.isEmpty(activationCode)) {
                throw new BusinessException("激活码不能为空");
            }

            // 创建邮件消息
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            // 设置邮件内容
            helper.setFrom("642542344@qq.com"); // 发件人邮箱，与配置文件中的 spring.mail.username 一致
            helper.setTo(email);
            helper.setSubject("账号激活邮件");

            // 构建激活链接（包含上下文路径 /goods）
            String activationLink = "http://localhost:8080/goods/user/activation?code=" + activationCode;

            // HTML邮件内容
            String htmlContent = "<html>" +
                    "<body>" +
                    "<h3>尊敬的用户：</h3>" +
                    "<p>感谢您注册我们的网站，请点击以下链接激活您的账号：</p>" +
                    "<a href='" + activationLink + "'>点击激活账号</a>" +
                    "<p>如果您没有注册，请忽略此邮件。</p>" +
                    "</body>" +
                    "</html>";

            helper.setText(htmlContent, true);

            // 发送邮件
            javaMailSender.send(message);
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (MessagingException e) {
            // 邮件发送异常
            throw new BusinessException("发送激活邮件失败", e);
        } catch (Exception e) {
            // 其他异常
            throw new BusinessException("发送激活邮件时发生错误", e);
        }
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "user", allEntries = true),
            @CacheEvict(value = "userCheck", allEntries = true)
    })
    public boolean activateUser(String activationCode) {
        try {
            // 输入参数验证
            if (ValidationUtils.isEmpty(activationCode)) {
                throw new BusinessException("激活码不能为空");
            }

            // 根据激活码查找用户
            User user = userMapper.selectUserByActivationCode(activationCode);
            if (user == null) {
                throw new BusinessException("激活码无效或已过期");
            }

            // 检查用户是否已经激活
            if (user.getStatus() == 1) {
                throw new BusinessException("账号已经激活，无需重复激活");
            }

            // 更新用户状态为已激活
            int result = userMapper.updateUserStatusByActivationCode(activationCode, 1);

            // 返回激活结果
            return result > 0;
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            // 其他异常包装为数据库异常
            throw new DatabaseException("激活账号失败", e);
        }
    }

    @Override
    @Cacheable(value = "userCheck", key = "'activated_'.concat(#loginname)", unless = "#result == null")
    public boolean isActivated(String loginname) {
        try {
            // 输入参数验证
            if (ValidationUtils.isEmpty(loginname)) {
                throw new BusinessException("用户名不能为空");
            }

            // 查询用户信息
            User user = getUserByLoginname(loginname);
            if (user == null) {
                throw new BusinessException("用户不存在");
            }

            // 返回激活状态
            return user.getStatus() == 1;
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            // 其他异常包装为数据库异常
            throw new DatabaseException("检查激活状态失败", e);
        }
    }

    @Override
    @Cacheable(value = "userCheck", key = "'loginname_'.concat(#loginname)", unless = "#result == null")
    public Boolean verifyLoginname(String loginname) {
        try {
            // 输入参数验证
            if (ValidationUtils.isEmpty(loginname)) {
                throw new BusinessException("用户名不能为空");
            }

            // 查询用户名是否已存在
            User user = userMapper.selectUserByLoginname(loginname);

            // 返回验证结果：如果用户不存在，则用户名可用
            return user == null;
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            // 其他异常包装为数据库异常
            throw new DatabaseException("验证用户名失败", e);
        }
    }

    @Override
    @Cacheable(value = "userCheck", key = "'email_'.concat(#email)", unless = "#result == null")
    public Boolean verifyEmail(String email) {
        try {
            // 输入参数验证
            if (ValidationUtils.isEmpty(email)) {
                throw new BusinessException("邮箱不能为空");
            }
            if (!ValidationUtils.isEmailValid(email)) {
                throw new BusinessException("邮箱格式不正确");
            }

            // 查询邮箱是否已存在
            User user = userMapper.selectUserByEmail(email);

            // 返回验证结果：如果用户不存在，则邮箱可用
            return user == null;
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            // 其他异常包装为数据库异常
            throw new DatabaseException("验证邮箱失败", e);
        }
    }

    @Override
    public ActivationPovo activation(String activationCode) {
        try {
            // 输入参数验证
            if (ValidationUtils.isEmpty(activationCode)) {
                throw new BusinessException("激活码不能为空");
            }

            // 调用activateUser方法执行激活操作
            boolean success = activateUser(activationCode);

            // 构建并返回激活结果
            ActivationPovo povo = new ActivationPovo();
            povo.setFlag(success);
            povo.setMsg(success ? "激活成功" : "激活失败");

            return povo;
        } catch (BusinessException e) {
            // 业务异常包装为激活结果
            ActivationPovo povo = new ActivationPovo();
            povo.setFlag(false);
            povo.setMsg(e.getMessage());
            return povo;
        } catch (Exception e) {
            // 其他异常包装为激活结果
            ActivationPovo povo = new ActivationPovo();
            povo.setFlag(false);
            povo.setMsg("激活过程中发生错误");
            return povo;
        }
    }

    @Override
    @Cacheable(value = "user", key = "#email", unless = "#result == null")
    public User getUserByEmail(String email) {
        try {
            // 输入参数验证
            if (ValidationUtils.isEmpty(email)) {
                throw new BusinessException("邮箱不能为空");
            }
            if (!ValidationUtils.isEmailValid(email)) {
                throw new BusinessException("邮箱格式不正确");
            }

            // 调用Mapper方法查询用户
            return userMapper.selectUserByEmail(email);
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            // 其他异常包装为数据库异常
            throw new DatabaseException("查询用户失败", e);
        }
    }

    /**
     * 发送重置密码邮件
     */
    @Override
    public boolean sendResetPasswordEmail(String email) {
        try {
            // 实现发送重置密码邮件的逻辑
            return true;
        } catch (Exception e) {
            throw new BusinessException("发送重置密码邮件失败", e);
        }
    }

    /**
     * 验证重置密码令牌
     */
    @Override
    public boolean validateResetToken(String token) {
        // 实现验证重置密码令牌的逻辑
        return resetTokenStore.containsKey(token);
    }

    /**
     * 重置用户密码
     */
    @Override
    @Caching(evict = {
            @CacheEvict(value = "user", allEntries = true),
            @CacheEvict(value = "userCheck", allEntries = true)
    })
    public boolean resetPassword(String token, String verificationCode, String newPassword) {
        if (StringUtils.isEmpty(token) || StringUtils.isEmpty(verificationCode) || StringUtils.isEmpty(newPassword)) {
            throw new BusinessException("参数不能为空");
        }

        try {
            // 验证令牌
            if (!validateResetToken(token)) {
                throw new BusinessException("无效的重置令牌");
            }

            // 获取邮箱（这里简化处理）
            String email = resetTokenStore.get(token);
            User user = getUserByEmail(email);

            if (user == null) {
                throw new BusinessException("用户不存在");
            }

            // 加密新密码并更新
            String encryptedPassword = PasswordHelper.encrypt(newPassword);
            boolean result = updateUserPassword(user.getUid(), encryptedPassword);

            // 重置成功后移除令牌
            if (result) {
                resetTokenStore.remove(token);
            }

            return result;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new DatabaseException("重置密码失败", e);
        }
    }
}