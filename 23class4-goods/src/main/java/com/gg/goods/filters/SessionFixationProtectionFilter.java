package com.gg.goods.filters;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * 会话固定保护过滤器
 * 防止会话固定攻击，在用户登录时重新生成会话ID
 */
@Slf4j
public class SessionFixationProtectionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        log.info("会话固定保护过滤器已初始化");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String requestURI = httpRequest.getRequestURI();
        String method = httpRequest.getMethod();

        // 设置防缓存响应头
        addNoCacheHeaders(httpResponse);

        HttpSession session = httpRequest.getSession(false);

        // 1. 在会话存在但没有创建时间时，补充设置创建时间
        if (session != null) {
            Long createdTime = (Long) session.getAttribute("sessionCreatedTime");
            if (createdTime == null) {
                // 补充设置会话创建时间
                session.setAttribute("sessionCreatedTime", System.currentTimeMillis());
                log.debug("为现有会话补充设置创建时间: {}", session.getId());
            }
        }

        // 2. 检查是否需要重新生成会话ID（登录操作）
        if (shouldRegenerateSession(httpRequest)) {
            // 登录请求，需要重新生成会话ID以防止会话固定攻击
            regenerateSessionId(httpRequest, httpResponse);
            log.info("登录请求时重新生成了会话ID");
        }

        // 3. 如果是管理员路径，确保有正确的会话状态
        if (requestURI.contains("/admin") && !requestURI.contains("/admin/login.jsp")) {
            HttpSession adminSession = httpRequest.getSession(false);
            if (adminSession != null) {
                // 确保管理员会话有创建时间
                Long adminCreatedTime = (Long) adminSession.getAttribute("sessionCreatedTime");
                if (adminCreatedTime == null) {
                    adminSession.setAttribute("sessionCreatedTime", System.currentTimeMillis());
                    log.debug("为管理员会话补充设置创建时间: {}", adminSession.getId());
                }
            }
        }

        // 继续过滤器链
        chain.doFilter(request, response);
    }

    /**
     * 判断是否需要重新生成会话ID
     * 当用户执行登录操作时需要重新生成会话ID
     */
    private boolean shouldRegenerateSession(HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        String method = request.getMethod();
        boolean isLoginRequest = false;

        // 检查是否为普通用户登录请求
        isLoginRequest |= requestURI.contains("/login") && "POST".equals(method);

        // 检查是否为管理员登录请求
        isLoginRequest |= requestURI.contains("/admin/login") && "POST".equals(method);

        // 检查是否有会话
        HttpSession session = request.getSession(false);
        boolean hasSession = (session != null);

        // 当有会话且是登录请求时，需要重新生成会话ID
        boolean result = (hasSession && isLoginRequest);

        // 调试日志
        if (result) {
            log.debug("检测到需要重新生成会话的条件：会话存在且是登录请求，URI={}, 方法={}", requestURI, method);
        }

        return result;
    }

    /**
     * 重新生成会话ID，并保持原有的会话属性
     */
    private void regenerateSessionId(HttpServletRequest request, HttpServletResponse response) {
        HttpSession oldSession = request.getSession(false);
        if (oldSession == null) {
            return;
        }

        // 保存旧会话的所有属性
        Map<String, Object> attributes = new HashMap<>();
        Enumeration<String> attributeNames = oldSession.getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String name = attributeNames.nextElement();
            attributes.put(name, oldSession.getAttribute(name));
        }

        // 销毁旧会话
        oldSession.invalidate();

        // 创建新会话
        HttpSession newSession = request.getSession(true);

        // 将会话创建时间设置为当前时间
        long currentTime = System.currentTimeMillis();
        attributes.put("sessionCreatedTime", currentTime);

        // 恢复会话属性到新会话
        for (Map.Entry<String, Object> entry : attributes.entrySet()) {
            newSession.setAttribute(entry.getKey(), entry.getValue());
        }

        log.info("会话ID重新生成完成: 旧ID={}, 新ID={}", oldSession.getId(), newSession.getId());
        log.debug("新会话创建时间: {}", currentTime);
    }

    /**
     * 添加防止缓存的响应头
     */
    private void addNoCacheHeaders(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    @Override
    public void destroy() {
        log.info("会话固定保护过滤器已销毁");
    }
}