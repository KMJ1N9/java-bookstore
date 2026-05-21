package com.gg.goods.validator;

import java.util.regex.Pattern;

/**
 * 数据验证工具类
 * 提供常用的输入参数验证方法
 */
public class ValidationUtils {

    // 邮箱正则表达式
    private static final String EMAIL_PATTERN = "^[A-Za-z0-9+_.-]+@(.+)$";
    // 用户名正则表达式（字母数字下划线，3-20位）
    private static final String USERNAME_PATTERN = "^[a-zA-Z0-9_]{3,20}$";
    // 密码正则表达式（至少8位，包含字母和数字）
    private static final String PASSWORD_PATTERN = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d@$!%*#?&]{8,}$";
    // 手机号正则表达式
    private static final String PHONE_PATTERN = "^1[3-9]\\d{9}$";

    /**
     * 验证字符串是否为空
     *
     * @param str 待验证的字符串
     * @return 如果为空返回true，否则返回false
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * 验证字符串长度
     *
     * @param str 待验证的字符串
     * @param min 最小长度
     * @param max 最大长度
     * @return 如果长度在范围内返回true，否则返回false
     */
    public static boolean isLengthValid(String str, int min, int max) {
        if (isEmpty(str)) {
            return false;
        }
        int length = str.trim().length();
        return length >= min && length <= max;
    }

    /**
     * 验证邮箱格式
     *
     * @param email 待验证的邮箱
     * @return 如果邮箱格式正确返回true，否则返回false
     */
    public static boolean isEmailValid(String email) {
        if (isEmpty(email)) {
            return false;
        }
        return Pattern.matches(EMAIL_PATTERN, email);
    }

    /**
     * 验证用户名格式
     *
     * @param username 待验证的用户名
     * @return 如果用户名格式正确返回true，否则返回false
     */
    public static boolean isUsernameValid(String username) {
        if (isEmpty(username)) {
            return false;
        }
        return Pattern.matches(USERNAME_PATTERN, username);
    }

    /**
     * 验证密码强度
     *
     * @param password 待验证的密码
     * @return 如果密码强度符合要求返回true，否则返回false
     */
    public static boolean isPasswordValid(String password) {
        if (isEmpty(password)) {
            return false;
        }
        return Pattern.matches(PASSWORD_PATTERN, password);
    }

    /**
     * 验证手机号格式
     *
     * @param phone 待验证的手机号
     * @return 如果手机号格式正确返回true，否则返回false
     */
    public static boolean isPhoneValid(String phone) {
        if (isEmpty(phone)) {
            return false;
        }
        return Pattern.matches(PHONE_PATTERN, phone);
    }

    /**
     * 验证数字范围
     *
     * @param num 待验证的数字
     * @param min 最小值
     * @param max 最大值
     * @return 如果数字在范围内返回true，否则返回false
     */
    public static boolean isNumberInRange(Number num, Number min, Number max) {
        if (num == null) {
            return false;
        }
        double value = num.doubleValue();
        return value >= min.doubleValue() && value <= max.doubleValue();
    }

    /**
     * 验证是否为正整数
     *
     * @param num 待验证的数字
     * @return 如果是正整数返回true，否则返回false
     */
    public static boolean isPositiveInteger(String num) {
        if (isEmpty(num)) {
            return false;
        }
        try {
            int value = Integer.parseInt(num);
            return value > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * 验证是否为有效金额（最多两位小数的正数）
     *
     * @param amount 待验证的金额字符串
     * @return 如果是有效金额返回true，否则返回false
     */
    public static boolean isAmountValid(String amount) {
        if (isEmpty(amount)) {
            return false;
        }
        try {
            double value = Double.parseDouble(amount);
            if (value <= 0) {
                return false;
            }
            // 检查小数位数，最多两位
            String[] parts = amount.split("\\.");
            if (parts.length > 1 && parts[1].length() > 2) {
                return false;
            }
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}