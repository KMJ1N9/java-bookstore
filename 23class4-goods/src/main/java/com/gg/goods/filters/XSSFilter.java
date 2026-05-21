package com.gg.goods.filters;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;

/**
 * XSS过滤器，用于过滤请求中的XSS攻击代码
 */
public class XSSFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化方法，暂不做特殊处理
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // 使用XSSRequestWrapper包装原始请求，过滤参数中的XSS攻击代码
        XSSRequestWrapper xssRequest = new XSSRequestWrapper((HttpServletRequest) request);

        // 继续过滤器链
        chain.doFilter(xssRequest, response);
    }

    @Override
    public void destroy() {
        // 销毁方法，暂不做特殊处理
    }
}