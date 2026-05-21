package com.gg.goods.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.web.SecurityFilterChain;

/**
 * 安全配置类
 * 提供密码加密器等安全相关的Bean
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    /**
     * 注意：项目已实现自定义的PasswordHelper工具类处理密码加密和验证
     * 不提供PasswordEncoder Bean，避免与自定义认证系统冲突
     */

    /**
     * 配置安全过滤链
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                // 允许所有请求访问，不进行Spring Security认证
                // 因为项目已经有自己的认证系统
                .authorizeHttpRequests(authorize -> authorize
                        .anyRequest().permitAll()
                )
                // 禁用表单登录
                .formLogin(form -> form.disable())
                // 禁用CSRF保护（如果项目自己实现了）
                .csrf(csrf -> csrf.disable())
                // 禁用HTTP Basic认证
                .httpBasic(httpBasic -> httpBasic.disable())
                // 禁用记住我功能
                .rememberMe(rememberMe -> rememberMe.disable())
                // 允许iframe嵌入，解决'X-Frame-Options'限制问题
                .headers(headers -> headers.frameOptions(frameOptions -> frameOptions.disable()));

        return http.build();
    }

    /**
     * 配置Web安全自定义
     */
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        // 忽略静态资源的认证
        return (web) -> web.ignoring().requestMatchers("/css/**", "/js/**", "/images/**", "/fonts/**");
    }
}
