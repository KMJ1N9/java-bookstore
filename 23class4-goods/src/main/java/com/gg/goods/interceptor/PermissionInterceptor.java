package com.gg.goods.interceptor;

import com.gg.goods.annotation.RequirePermission;
import com.gg.goods.entity.Admin;
import com.gg.goods.entity.Permission;
import com.gg.goods.entity.Role;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

/**
 * 权限拦截器
 * 用于验证管理员是否有相应的操作权限
 */
public class PermissionInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 判断handler是否为HandlerMethod类型
        if (handler instanceof HandlerMethod) {
            HandlerMethod handlerMethod = (HandlerMethod) handler;
            // 获取方法上的RequirePermission注解
            RequirePermission permission = handlerMethod.getMethodAnnotation(RequirePermission.class);

            // 如果方法上有RequirePermission注解，则进行权限验证
            if (permission != null) {
                String requiredPermission = permission.value();

                // 从session中获取当前登录的管理员
                Admin admin = (Admin) request.getSession().getAttribute("admin");

                // 如果管理员未登录，重定向到登录页面
                if (admin == null) {
                    redirectToLogin(request, response);
                    return false;
                }

                // 检查管理员是否拥有所需权限
                if (!hasPermission(admin, requiredPermission)) {
                    response.setContentType("text/html;charset=UTF-8");
                    try {
                        response.getWriter().write("<script>alert('无权限访问此功能！');window.history.back();</script>");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    return false;
                }
            }
        }

        // 没有权限要求或者有权限，允许访问
        return true;
    }

    /**
     * 检查管理员是否拥有指定权限
     */
    private boolean hasPermission(Admin admin, String requiredPermission) {
        if (admin == null || admin.getRoles() == null) {
            return false;
        }

        // 收集管理员的所有权限码
        Set<String> permissionCodes = new HashSet<>();

        for (Role role : admin.getRoles()) {
            if (role.getPermissions() != null) {
                for (Permission permission : role.getPermissions()) {
                    if (permission != null && permission.getPermissionCode() != null) {
                        permissionCodes.add(permission.getPermissionCode());
                    }
                }
            }
        }

        // 检查是否包含所需权限
        return permissionCodes.contains(requiredPermission);
    }

    /**
     * 重定向到登录页面
     */
    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String contextPath = request.getContextPath();
        response.sendRedirect(contextPath + "/admin/login.jsp");
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        // 不需要实现
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        // 不需要实现
    }
}