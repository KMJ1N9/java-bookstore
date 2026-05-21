package com.gg.goods.config;

import com.gg.goods.filters.*;
import com.gg.goods.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private CategoryService categoryService;

    // 注册XSS过滤器（最高优先级，清理所有输入）
    @Bean
    public FilterRegistrationBean<XSSFilter> xssFilter() {
        FilterRegistrationBean<XSSFilter> registrationBean =
                new FilterRegistrationBean<>(new XSSFilter());
        registrationBean.addUrlPatterns("/*");
        registrationBean.setOrder(0); // 优先级最高，最先执行
        registrationBean.setName("xssFilter");
        registrationBean.setEnabled(true);
        return registrationBean;
    }

    // 注册会话固定保护过滤器（优先级高）
    @Bean
    public FilterRegistrationBean<SessionFixationProtectionFilter> sessionFixationProtectionFilter() {
        FilterRegistrationBean<SessionFixationProtectionFilter> registrationBean =
                new FilterRegistrationBean<>(new SessionFixationProtectionFilter());
        registrationBean.addUrlPatterns("/*");
        registrationBean.setOrder(1); // 优先级次之
        registrationBean.setName("sessionFixationProtectionFilter");
        registrationBean.setEnabled(true);
        return registrationBean;
    }

    // 注册会话验证过滤器（优先级次之）
    @Bean
    public FilterRegistrationBean<SessionValidationFilter> sessionValidationFilter() {
        FilterRegistrationBean<SessionValidationFilter> registrationBean =
                new FilterRegistrationBean<>(new SessionValidationFilter());
        registrationBean.addUrlPatterns("/*");
        registrationBean.setOrder(2); // 优先级次之
        registrationBean.setName("sessionValidationFilter");
        registrationBean.setEnabled(true);
        return registrationBean;
    }

    // 注册CSRF过滤器（在会话过滤器之后，业务逻辑过滤器之前）
    @Bean
    public FilterRegistrationBean<CSRFFilter> csrfFilter() {
        FilterRegistrationBean<CSRFFilter> registrationBean =
                new FilterRegistrationBean<>(new CSRFFilter());
        registrationBean.addUrlPatterns("/*");
        registrationBean.setOrder(3); // 优先级低于会话过滤器
        registrationBean.setName("csrfFilter");
        registrationBean.setEnabled(true);
        return registrationBean;
    }

    // 注册分类加载过滤器（优先级最低）
    @Bean
    public FilterRegistrationBean<LoadCategoryFilter> loadCategoryFilter() {
        // 使用构造函数注入CategoryService
        FilterRegistrationBean<LoadCategoryFilter> registrationBean =
                new FilterRegistrationBean<>(new LoadCategoryFilter(categoryService));
        registrationBean.addUrlPatterns("/*");
        registrationBean.setOrder(4); // 优先级最低
        registrationBean.setName("loadCategoryFilter");
        registrationBean.setEnabled(true);
        return registrationBean;
    }

    @Bean
    public MultipartResolver multipartResolver() {
        // 使用StandardServletMultipartResolver，这是Spring Boot 3.x推荐的方式
        StandardServletMultipartResolver resolver = new StandardServletMultipartResolver();
        // 注意：文件大小限制在application.properties或application.yaml中配置
        return resolver;
    }
}