package com.gg.goods.security;

import com.gg.goods.helpers.PasswordHelper;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * 密码加密测试类
 * 验证BCrypt密码加密和验证功能
 */
public class PasswordEncryptionTest {

    @Test
    public void testBCryptPasswordEncoder() {
        // 测试密码
        String rawPassword = "test123456";

        // 加密密码
        String encodedPassword = PasswordHelper.encrypt(rawPassword);
        System.out.println("原始密码: " + rawPassword);
        System.out.println("加密后密码: " + encodedPassword);
        System.out.println("密码长度: " + encodedPassword.length());

        // 验证密码
        boolean matches = PasswordHelper.matches(rawPassword, encodedPassword);
        System.out.println("密码匹配: " + matches);

        // 断言密码验证成功
        assertTrue(matches, "密码验证应该成功");

        // 验证不同密码不匹配
        boolean wrongMatch = PasswordHelper.matches("wrongPassword", encodedPassword);
        System.out.println("错误密码匹配: " + wrongMatch);
        assertTrue(!wrongMatch, "错误密码应该不匹配");
    }
}