package com.gg.goods.util;

import ch.qos.logback.classic.pattern.ClassicConverter;
import ch.qos.logback.classic.spi.ILoggingEvent;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 日志敏感信息脱敏转换器
 * 用于在日志输出时自动脱敏敏感信息
 */
public class SensitiveDataConverter extends ClassicConverter {

    // 密码正则表达式
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("(password|pwd|passwd|passwords?)[\\s]*[=:][\\s]*([\"']?)([^\"'\\s]+)([\"']?)", Pattern.CASE_INSENSITIVE);

    // 用户名正则表达式
    private static final Pattern USERNAME_PATTERN = Pattern.compile("(username|loginname|userid|account)[\\s]*[=:][\\s]*([\"']?)([^\"'\\s]+)([\"']?)", Pattern.CASE_INSENSITIVE);

    // 邮箱正则表达式
    private static final Pattern EMAIL_PATTERN = Pattern.compile("([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})");

    @Override
    public String convert(ILoggingEvent event) {
        String message = event.getFormattedMessage();
        if (message == null) {
            return "";
        }

        // 对日志消息进行脱敏处理
        String maskedMessage = maskPassword(message);
        maskedMessage = maskUsername(maskedMessage);
        maskedMessage = maskEmail(maskedMessage);

        return maskedMessage;
    }

    /**
     * 脱敏密码
     */
    private String maskPassword(String message) {
        Matcher matcher = PASSWORD_PATTERN.matcher(message);
        StringBuffer sb = new StringBuffer();

        while (matcher.find()) {
            String quote1 = matcher.group(2);
            String password = matcher.group(3);
            String quote2 = matcher.group(4);

            // 替换为掩码
            String maskedPassword = quote1 + "***" + quote2;
            matcher.appendReplacement(sb, matcher.group(1) + ": " + maskedPassword);
        }
        matcher.appendTail(sb);

        return sb.toString();
    }

    /**
     * 脱敏用户名
     */
    private String maskUsername(String message) {
        Matcher matcher = USERNAME_PATTERN.matcher(message);
        StringBuffer sb = new StringBuffer();

        while (matcher.find()) {
            String quote1 = matcher.group(2);
            String username = matcher.group(3);
            String quote2 = matcher.group(4);

            // 脱敏用户名：保留前2位，其余用*替换
            String maskedUsername = maskString(username, 2, 0);
            matcher.appendReplacement(sb, matcher.group(1) + ": " + quote1 + maskedUsername + quote2);
        }
        matcher.appendTail(sb);

        return sb.toString();
    }


    /**
     * 脱敏邮箱：保留用户名前2位和域名
     */
    private String maskEmail(String message) {
        Matcher matcher = EMAIL_PATTERN.matcher(message);
        StringBuffer sb = new StringBuffer();

        while (matcher.find()) {
            String username = matcher.group(1);
            String domain = matcher.group(2);

            String maskedUsername = maskString(username, 2, 0);
            String maskedEmail = maskedUsername + "@" + domain;
            matcher.appendReplacement(sb, maskedEmail);
        }
        matcher.appendTail(sb);

        return sb.toString();
    }


    /**
     * 通用字符串脱敏方法
     *
     * @param str  原始字符串
     * @param head 保留头部字符数
     * @param tail 保留尾部字符数
     * @return 脱敏后的字符串
     */
    private String maskString(String str, int head, int tail) {
        if (str == null || str.length() <= head + tail) {
            return "***";
        }

        StringBuilder sb = new StringBuilder();
        sb.append(str.substring(0, head));

        int maskLength = str.length() - head - tail;
        for (int i = 0; i < maskLength; i++) {
            sb.append('*');
        }

        sb.append(str.substring(str.length() - tail));
        return sb.toString();
    }
}