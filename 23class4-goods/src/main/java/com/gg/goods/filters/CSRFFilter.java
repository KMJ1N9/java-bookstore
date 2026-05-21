package com.gg.goods.filters;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * CSRF过滤器，用于防止跨站请求伪造攻击
 */
public class CSRFFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化方法，暂不做特殊处理
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession();

        // 生成并获取CSRF令牌
        String token = CSRFTokenManager.getTokenForSession(session);

        // 将令牌添加到请求属性中，供JSP页面使用
        request.setAttribute(CSRFTokenManager.CSRF_TOKEN_ATTR_NAME, token);

        // 检查是否为需要保护的请求方法
        if (CSRFTokenManager.isProtectedMethod(httpRequest.getMethod())) {
            // 验证CSRF令牌
            String requestToken = CSRFTokenManager.getTokenFromRequest(httpRequest);

            // 如果令牌不存在或不匹配，拒绝请求
            if (token == null || !token.equals(requestToken)) {
                httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                httpResponse.getWriter().write("CSRF令牌验证失败，请求被拒绝");
                return;
            }
        }

        // 继续过滤器链
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 销毁方法，暂不做特殊处理
    }
}