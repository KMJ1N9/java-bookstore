package com.gg.goods.filters;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.HashSet;
import java.util.Set;

/**
 * CSRF令牌管理器，用于生成和验证CSRF令牌
 */
public class CSRFTokenManager {

    // CSRF令牌参数名
    public static final String CSRF_PARAM_NAME = "_csrf_token";

    // CSRF令牌请求头名
    public static final String CSRF_HEADER_NAME = "X-CSRF-Token";

    // CSRF令牌会话属性名
    public static final String CSRF_TOKEN_ATTR_NAME = "CSRF_TOKEN";

    // 需要保护的HTTP方法
    private static final Set<String> PROTECTED_METHODS = new HashSet<String>() {
        {
            add("POST");
            add("PUT");
            add("DELETE");
        }
    };

    // 安全的随机数生成器
    private static final SecureRandom RANDOM = new SecureRandom();

    // 令牌长度（字节）
    private static final int TOKEN_LENGTH = 24;

    /**
     * 为会话生成CSRF令牌
     */
    public static String getTokenForSession(HttpSession session) {
        String token = (String) session.getAttribute(CSRF_TOKEN_ATTR_NAME);
        if (token == null) {
            // 生成新的随机令牌
            byte[] randomBytes = new byte[TOKEN_LENGTH];
            RANDOM.nextBytes(randomBytes);
            token = Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
            // 存储令牌到会话中
            session.setAttribute(CSRF_TOKEN_ATTR_NAME, token);
        }
        return token;
    }

    /**
     * 从请求中获取CSRF令牌（支持从参数或请求头中获取）
     */
    public static String getTokenFromRequest(HttpServletRequest request) {
        // 首先尝试从请求头中获取令牌
        String token = request.getHeader(CSRF_HEADER_NAME);
        if (token == null) {
            // 如果请求头中没有，则从请求参数中获取令牌
            token = request.getParameter(CSRF_PARAM_NAME);
        }
        return token;
    }

    /**
     * 检查指定的HTTP方法是否需要CSRF保护
     */
    public static boolean isProtectedMethod(String method) {
        return PROTECTED_METHODS.contains(method);
    }

    /**
     * 获取当前会话的CSRF令牌
     */
    public static String getToken(HttpServletRequest request) {
        HttpSession session = request.getSession();
        return getTokenForSession(session);
    }

    /**
     * 验证请求中的CSRF令牌
     */
    public static boolean validateToken(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_ATTR_NAME);
        String requestToken = getTokenFromRequest(request);

        return sessionToken != null && sessionToken.equals(requestToken);
    }
}