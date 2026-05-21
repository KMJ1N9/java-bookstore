package com.gg.goods.filters;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;

/**
 * 会话验证过滤器
 * 用于项目重启后验证会话有效性，强制未登录用户退出到首页
 */
@Slf4j
public class SessionValidationFilter implements Filter {

    // 保存FilterConfig，用于获取ServletContext
    private FilterConfig filterConfig;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 在初始化时保存FilterConfig，以便后续获取ServletContext
        this.filterConfig = filterConfig;
        log.info("会话验证过滤器已初始化");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // 设置防缓存响应头，防止用户通过浏览器后退按钮访问已登录页面
        setNoCacheHeaders(httpResponse);

        // 对于公开路径、静态资源或未登录的用户，直接放行
        if (isPublicPath(requestURI, contextPath) || isStaticResource(requestURI)) {
            chain.doFilter(request, response);
            return;
        }

        // 检查是否为AJAX请求
        boolean isAjaxRequest = "XMLHttpRequest".equals(httpRequest.getHeader("X-Requested-With"));

        HttpSession session = httpRequest.getSession(false);
        if (session == null) {
            // 没有会话，对于AJAX请求返回401，否则重定向到登录页面
            log.debug("没有找到会话");
            if (isAjaxRequest) {
                httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            } else if (requestURI.contains("/admin")) {
                httpResponse.sendRedirect(contextPath + "/admin/loginPage");
            } else {
                // 重定向到首页而不是不存在的login.jsp
                httpResponse.sendRedirect(contextPath + "/");
            }
            return;
        }

        // 获取会话创建时间
        Long sessionCreatedTime = (Long) session.getAttribute("sessionCreatedTime");
        if (sessionCreatedTime == null) {
            // 会话没有创建时间，需要重新登录
            log.debug("检测到没有创建时间的会话，强制用户重新登录");
            session.invalidate();
            if (isAjaxRequest) {
                httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            } else if (requestURI.contains("/admin")) {
                httpResponse.sendRedirect(contextPath + "/admin/loginPage");
            } else {
                // 重定向到首页而不是不存在的login.jsp
                httpResponse.sendRedirect(contextPath + "/");
            }
            return;
        }

        // 从ServletContext获取应用启动时间
        ServletContext servletContext = null;
        if (filterConfig != null) {
            servletContext = filterConfig.getServletContext();
        } else {
            // 备选方案：从request获取ServletContext
            servletContext = httpRequest.getServletContext();
        }

        if (servletContext != null) {
            Long appStartupTime = (Long) servletContext.getAttribute("appStartupTime");
            if (appStartupTime != null && sessionCreatedTime < appStartupTime) {
                // 会话创建时间早于应用启动时间，说明是应用重启前创建的会话，需要重新登录
                log.debug("检测到应用重启前创建的会话，强制用户重新登录");
                session.invalidate();
                if (isAjaxRequest) {
                    httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                } else if (requestURI.contains("/admin")) {
                    httpResponse.sendRedirect(contextPath + "/admin/loginPage");
                } else {
                    // 修复：重定向到首页而不是不存在的login.jsp
                    httpResponse.sendRedirect(contextPath + "/");
                }
                return;
            }
        } else {
            log.warn("无法获取ServletContext，跳过应用启动时间验证");
        }

        // 验证用户或管理员会话的有效性
        Object user = session.getAttribute("user");
        Object admin = session.getAttribute("admin");

        // 判断是否为管理员路径
        boolean isAdminPath = requestURI.contains("/admin");

        // 如果访问的是管理员路径
        if (isAdminPath) {
            if (admin == null) {
                log.warn("访问管理员路径但没有管理员会话");
                session.invalidate(); // 确保旧会话被销毁
                if (isAjaxRequest) {
                    httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                } else {
                    httpResponse.sendRedirect(contextPath + "/admin/loginPage");
                }
                return;
            } else {
                // 管理员会话有效，记录访问信息
                log.debug("管理员会话验证通过，继续访问：{}", requestURI);
            }
        } else {
            // 普通用户路径
            if (user == null && admin == null) {
                log.warn("访问用户路径但没有有效会话");
                session.invalidate(); // 确保旧会话被销毁
                if (isAjaxRequest) {
                    httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                } else {
                    // 重定向到首页而不是不存在的login.jsp
                    httpResponse.sendRedirect(contextPath + "/");
                }
                return;
            } else {
                // 用户或管理员会话有效，记录访问信息
                log.debug("用户会话验证通过，继续访问：{}", requestURI);
            }
        }

        // 会话验证通过，继续过滤器链
        chain.doFilter(request, response);
    }

    /**
     * 检查路径是否为公开路径
     */
    private boolean isPublicPath(String requestURI, String contextPath) {
        // 确保正确处理上下文路径
        String normalizedURI = requestURI.replaceFirst("^" + contextPath, "");

        // 登录页面、注册页面和忘记密码相关页面是公开的
        if (normalizedURI.contains("/login.jsp") ||
                normalizedURI.contains("/admin/login.jsp") ||
                normalizedURI.equals("/admin/login") || // 添加控制器登录路径
                normalizedURI.equals("/admin/loginPage") || // 添加控制器登录页面路径
                normalizedURI.equals("/user/login") || // 添加用户控制器登录路径
                normalizedURI.contains("/regist") ||
                normalizedURI.contains("/logout") ||
                // 添加忘记密码相关的公开路径
                normalizedURI.equals("/user/forgotPassword") ||
                normalizedURI.equals("/user/sendResetEmail") ||
                normalizedURI.startsWith("/user/resetPassword") ||
                normalizedURI.equals("/user/doResetPassword") ||
                // 添加验证码生成路径
                normalizedURI.equals("/user/createVerifycode")) {
            return true;
        }

        // 首页和商品列表页是公开的
        if (normalizedURI.equals("/") ||
                normalizedURI.equals("/index.jsp") ||
                normalizedURI.equals("/goods/index.jsp") ||
                normalizedURI.startsWith("/goods?") ||
                // 添加商品浏览相关的公开路径
                normalizedURI.startsWith("/book/getBooksByCase") ||
                normalizedURI.startsWith("/book/getBooksByCid") ||
                normalizedURI.startsWith("/book/getBookByBid") ||
                normalizedURI.startsWith("/book/getNewestBooks") ||
                normalizedURI.startsWith("/book/getHotBooks") ||
                normalizedURI.startsWith("/book/searchBooks") ||
                normalizedURI.startsWith("/category/getAll")) {
            return true;
        }

        return false;
    }

    /**
     * 检查路径是否为静态资源
     */
    private boolean isStaticResource(String requestURI) {
        return requestURI.contains(".css") ||
                requestURI.contains(".js") ||
                requestURI.contains(".jpg") ||
                requestURI.contains(".png") ||
                requestURI.contains(".gif") ||
                requestURI.contains(".ico") ||
                requestURI.contains(".woff") ||
                requestURI.contains(".ttf") ||
                requestURI.contains(".svg") ||
                requestURI.contains("/images/") ||
                requestURI.contains("/css/") ||
                requestURI.contains("/js/");
    }

    /**
     * 设置防止缓存的响应头，防止用户通过浏览器后退按钮访问已登录页面
     */
    private void setNoCacheHeaders(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    @Override
    public void destroy() {
        // 销毁方法
        log.info("会话验证过滤器已销毁");
    }
}