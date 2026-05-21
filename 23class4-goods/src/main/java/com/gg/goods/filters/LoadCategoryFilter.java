package com.gg.goods.filters;

import com.gg.goods.povos.CategoryPovo;
import com.gg.goods.service.CategoryService;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.util.List;

@Slf4j
public class LoadCategoryFilter implements Filter {

    private final CategoryService categoryService;

    // 使用构造函数注入，避免在过滤器初始化时依赖问题
    public LoadCategoryFilter(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // 跳过API路径，特别是缓存性能测试相关的API
        String requestUri = req.getRequestURI();
        if (requestUri.startsWith("/goods/api/cache/performance")) {
            // 直接放行API请求
            chain.doFilter(req, res);
            return;
        }

        // 跳过其他不需要类别数据的路径
        if (requestUri.endsWith(".css") ||
                requestUri.endsWith(".js") ||
                requestUri.endsWith(".jpg") ||
                requestUri.endsWith(".png") ||
                requestUri.endsWith(".gif") ||
                requestUri.contains("/api/") ||
                requestUri.contains("/admin/")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = req.getSession();
        List<CategoryPovo> categorypovos = (List<CategoryPovo>) session.getAttribute("categories");

        if (categorypovos == null) {
            /*没加载过*/
            /*1. 调用业务层，得到最终结果  是一个 类别的集合，每个元素都是1个爸爸+多个孩子们*/
            categorypovos = categoryService.loadCategories();
            /*测试*/
            log.debug("加载分类数据: {}", categorypovos);
            /*2. 把结果放到Session里*/
            session.setAttribute("categories", categorypovos);
            /*3. 继续过滤器链，让请求前往原本的目标页面*/
        }

        /*加载过或已加载，继续执行过滤器链*/
        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}