package com.gg.goods.service.impl;

import com.gg.goods.entity.Admin;
import com.gg.goods.exception.BusinessException;
import com.gg.goods.exception.DatabaseException;
import com.gg.goods.helpers.PasswordHelper;
import com.gg.goods.mapper.AdminMapper;
import com.gg.goods.service.AdminService;
import com.gg.goods.validator.ValidationUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminMapper adminMapper;

    @Override
    public Admin login(Admin admin) {
        try {
            // 输入参数验证
            if (admin == null) {
                throw new BusinessException("管理员对象不能为空");
            }

            String adminname = admin.getAdminname();
            String password = admin.getAdminpwd();

            if (ValidationUtils.isEmpty(adminname)) {
                throw new BusinessException("用户名不能为空");
            }
            if (!ValidationUtils.isLengthValid(adminname, 3, 20)) {
                throw new BusinessException("用户名长度必须在3-20个字符之间");
            }
            if (ValidationUtils.isEmpty(password)) {
                throw new BusinessException("密码不能为空");
            }
            if (!ValidationUtils.isLengthValid(password, 6, 20)) {
                throw new BusinessException("密码长度必须在6-20个字符之间");
            }

            // 使用selectByAdminname获取管理员对象
            Admin dbAdmin = adminMapper.selectByAdminname(adminname);

            // 检查管理员是否存在
            if (dbAdmin == null) {
                return null;
            }

            // 验证密码
            boolean passwordMatched = PasswordHelper.matches(password, dbAdmin.getAdminpwd());

            if (!passwordMatched) {
                return null;
            }

            return dbAdmin;
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            // 其他异常包装为数据库异常
            throw new DatabaseException("登录过程中发生错误", e);
        }
    }

    @Override
    public Admin findByAdminname(String adminname) {
        try {
            // 输入参数验证
            if (ValidationUtils.isEmpty(adminname)) {
                throw new BusinessException("用户名不能为空");
            }
            if (!ValidationUtils.isLengthValid(adminname, 3, 20)) {
                throw new BusinessException("用户名长度必须在3-20个字符之间");
            }

            // 使用selectByAdminname获取管理员对象
            Admin admin = adminMapper.selectByAdminname(adminname);

            if (admin == null) {
                throw new BusinessException("管理员不存在");
            }

            return admin;
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            throw new DatabaseException("查询管理员信息失败", e);
        }
    }

    @Override
    public Admin addAdmin(Admin admin) {
        try {
            // 输入参数验证
            if (admin == null) {
                throw new BusinessException("管理员对象不能为空");
            }

            String adminname = admin.getAdminname();
            String password = admin.getAdminpwd();

            if (ValidationUtils.isEmpty(adminname)) {
                throw new BusinessException("用户名不能为空");
            }
            if (!ValidationUtils.isLengthValid(adminname, 3, 20)) {
                throw new BusinessException("用户名长度必须在3-20个字符之间");
            }
            if (ValidationUtils.isEmpty(password)) {
                throw new BusinessException("密码不能为空");
            }
            if (!ValidationUtils.isLengthValid(password, 6, 20)) {
                throw new BusinessException("密码长度必须在6-20个字符之间");
            }

            // 检查用户名是否已存在
            Admin existingAdmin = adminMapper.selectByAdminname(adminname);
            if (existingAdmin != null) {
                throw new BusinessException("用户名已存在");
            }

            // 对密码进行BCrypt加密
            admin.setAdminpwd(PasswordHelper.encrypt(password));

            // 插入管理员记录
            int result = adminMapper.insert(admin);
            if (result == 0) {
                throw new DatabaseException("添加管理员失败");
            }

            return admin;
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            throw new DatabaseException("添加管理员失败", e);
        }
    }

    @Override
    public Admin updateAdmin(Admin admin) {
        try {
            // 输入参数验证
            if (admin == null) {
                throw new BusinessException("管理员对象不能为空");
            }

            String adminId = admin.getAdminId();
            if (ValidationUtils.isEmpty(adminId)) {
                throw new BusinessException("管理员ID不能为空");
            }

            // 检查管理员是否存在
            Admin existingAdmin = adminMapper.selectByPrimaryKey(adminId);
            if (existingAdmin == null) {
                throw new BusinessException("管理员不存在");
            }

            // 如果密码不为空，则进行BCrypt加密
            String password = admin.getAdminpwd();
            if (!ValidationUtils.isEmpty(password)) {
                if (!ValidationUtils.isLengthValid(password, 6, 20)) {
                    throw new BusinessException("密码长度必须在6-20个字符之间");
                }
                admin.setAdminpwd(PasswordHelper.encrypt(password));
            } else {
                // 如果密码为空，则保留原有密码
                admin.setAdminpwd(existingAdmin.getAdminpwd());
            }

            // 更新管理员记录
            int result = adminMapper.updateByPrimaryKey(admin);
            if (result == 0) {
                throw new DatabaseException("更新管理员失败");
            }

            return admin;
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            throw new DatabaseException("更新管理员失败", e);
        }
    }
}