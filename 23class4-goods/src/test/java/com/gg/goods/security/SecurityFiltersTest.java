package com.gg.goods.security;

import com.gg.goods.config.WebMvcConfig;
import com.gg.goods.filters.CSRFFilter;
import com.gg.goods.filters.SessionFixationProtectionFilter;
import com.gg.goods.filters.SessionValidationFilter;
import com.gg.goods.filters.XSSFilter;
import org.junit.jupiter.api.Test;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 安全过滤器测试类
 * 验证所有安全过滤器是否正确配置和注册
 */
public class SecurityFiltersTest {

    @Test
    public void testSecurityFiltersRegistration() {
        // 创建Spring上下文
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(WebMvcConfig.class);

        // 验证XSS过滤器
        FilterRegistrationBean<XSSFilter> xssFilterBean = context.getBean("xssFilter", FilterRegistrationBean.class);
        assertNotNull(xssFilterBean, "XSS过滤器应该被注册");
        assertTrue(xssFilterBean.isEnabled(), "XSS过滤器应该被启用");
        assertEquals(0, xssFilterBean.getOrder(), "XSS过滤器应该有最高优先级");
        assertTrue(xssFilterBean.getUrlPatterns().contains("/*"), "XSS过滤器应该应用于所有URL");
        System.out.println("✓ XSS过滤器验证通过");

        // 验证会话固定保护过滤器
        FilterRegistrationBean<SessionFixationProtectionFilter> sessionFixationFilterBean =
                context.getBean("sessionFixationProtectionFilter", FilterRegistrationBean.class);
        assertNotNull(sessionFixationFilterBean, "会话固定保护过滤器应该被注册");
        assertTrue(sessionFixationFilterBean.isEnabled(), "会话固定保护过滤器应该被启用");
        assertEquals(1, sessionFixationFilterBean.getOrder(), "会话固定保护过滤器应该有次高优先级");
        System.out.println("✓ 会话固定保护过滤器验证通过");

        // 验证会话验证过滤器
        FilterRegistrationBean<SessionValidationFilter> sessionValidationFilterBean =
                context.getBean("sessionValidationFilter", FilterRegistrationBean.class);
        assertNotNull(sessionValidationFilterBean, "会话验证过滤器应该被注册");
        assertTrue(sessionValidationFilterBean.isEnabled(), "会话验证过滤器应该被启用");
        assertEquals(2, sessionValidationFilterBean.getOrder(), "会话验证过滤器应该有适中优先级");
        System.out.println("✓ 会话验证过滤器验证通过");

        // 验证CSRF过滤器
        FilterRegistrationBean<CSRFFilter> csrfFilterBean =
                context.getBean("csrfFilter", FilterRegistrationBean.class);
        assertNotNull(csrfFilterBean, "CSRF过滤器应该被注册");
        assertTrue(csrfFilterBean.isEnabled(), "CSRF过滤器应该被启用");
        assertEquals(3, csrfFilterBean.getOrder(), "CSRF过滤器应该有较低优先级");
        assertTrue(csrfFilterBean.getUrlPatterns().contains("/*"), "CSRF过滤器应该应用于所有URL");
        System.out.println("✓ CSRF过滤器验证通过");

        // 关闭上下文
        context.close();
        System.out.println("所有安全过滤器验证通过！");
    }
}