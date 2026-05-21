package com.gg.goods.service;

import com.gg.goods.entity.Admin;

public interface AdminService {

    /**
     * 管理员登录
     *
     * @param admin 管理员对象，包含用户名和密码
     * @return 登录成功的管理员对象，失败返回null
     */
    Admin login(Admin admin);

    /**
     * 根据管理员用户名查找管理员
     *
     * @param adminname 管理员用户名
     * @return 管理员对象
     */
    Admin findByAdminname(String adminname);

    /**
     * 添加管理员
     *
     * @param admin 管理员对象，包含用户名和密码
     * @return 添加成功的管理员对象
     */
    Admin addAdmin(Admin admin);

    /**
     * 更新管理员
     *
     * @param admin 管理员对象，包含用户名和密码
     * @return 更新成功的管理员对象
     */
    Admin updateAdmin(Admin admin);
}