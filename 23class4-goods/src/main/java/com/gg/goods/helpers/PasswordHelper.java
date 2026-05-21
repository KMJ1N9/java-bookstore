package com.gg.goods.helpers;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * 密码加密工具类
 * 使用BCrypt算法对密码进行加密
 */
public class PasswordHelper {

    // 创建BCrypt密码编码器实例
    private static final BCryptPasswordEncoder PASSWORD_ENCODER = new BCryptPasswordEncoder();

    /**
     * 对密码进行BCrypt加密
     *
     * @param password 原始密码
     * @return 加密后的密码
     */
    public static String encrypt(String password) {
        return PASSWORD_ENCODER.encode(password);
    }

    /**
     * 验证密码是否匹配
     *
     * @param rawPassword     原始密码
     * @param encodedPassword 加密后的密码
     * @return 如果密码匹配返回true，否则返回false
     */
    public static boolean matches(String rawPassword, String encodedPassword) {
        // 检查是否为空
        if (rawPassword == null) {
            return false;
        }
        if (encodedPassword == null || encodedPassword.isEmpty()) {
            // 密码为空，只有原始密码也为空时才匹配
            return rawPassword.isEmpty();
        }

        // 检查是否是MD5加密的密码（32位十六进制字符串）
        if (encodedPassword.length() == 32) {
            // 尝试将密码转换为小写后验证MD5
            String lowerEncodedPassword = encodedPassword.toLowerCase();
            if (lowerEncodedPassword.matches("^[0-9a-f]{32}$")) {
                // 旧的MD5密码验证
                return encryptMD5(rawPassword).equals(lowerEncodedPassword);
            }
        }

        // 检查是否是BCrypt加密的密码（以$2a$、$2b$、$2y$开头）
        if (encodedPassword.startsWith("$2a$") || encodedPassword.startsWith("$2b$") || encodedPassword.startsWith("$2y$")) {
            // BCrypt密码验证
            return PASSWORD_ENCODER.matches(rawPassword, encodedPassword);
        }

        // 对明文密码的支持（直接比较）
        return rawPassword.equals(encodedPassword);
    }

    /**
     * 兼容旧的MD5加密方法
     *
     * @param password 原始密码
     * @return MD5加密后的密码
     */
    private static String encryptMD5(String password) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                String hex = Integer.toHexString(0xFF & b);
                if (hex.length() == 1) {
                    sb.append('0');
                }
                sb.append(hex);
            }
            return sb.toString();
        } catch (java.security.NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5加密失败", e);
        }
    }

    /**
     * 验证密码格式是否符合要求
     * 密码要求：至少8位，包含字母和数字
     *
     * @param password 待验证的密码
     * @return 如果密码格式正确返回true，否则返回false
     */
    public static boolean isValidPassword(String password) {
        // 检查密码是否为null或空
        if (password == null || password.isEmpty()) {
            return false;
        }

        // 检查密码长度是否至少为8位
        if (password.length() < 8) {
            return false;
        }

        // 检查是否包含字母
        boolean hasLetter = false;
        // 检查是否包含数字
        boolean hasDigit = false;

        for (char c : password.toCharArray()) {
            if (Character.isLetter(c)) {
                hasLetter = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            }

            // 如果同时包含字母和数字，可以提前返回
            if (hasLetter && hasDigit) {
                return true;
            }
        }

        // 必须同时包含字母和数字
        return hasLetter && hasDigit;
    }

    /**
     * 获取密码格式要求的提示信息
     *
     * @return 密码格式要求的提示信息
     */
    public static String getPasswordFormatHint() {
        return "密码必须至少8位，且同时包含字母和数字";
    }
}
