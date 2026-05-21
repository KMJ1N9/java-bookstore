package com.gg.goods.exception;

/**
 * 权限异常类
 * 用于处理权限验证相关的异常
 */
public class PermissionException extends BaseException {
    private static final long serialVersionUID = 1L;

    /**
     * 构造函数
     */
    public PermissionException() {
        super();
    }

    /**
     * 构造函数
     *
     * @param message 错误消息
     */
    public PermissionException(String message) {
        super(message);
    }

    /**
     * 构造函数
     *
     * @param message 错误消息
     * @param cause   异常原因
     */
    public PermissionException(String message, Throwable cause) {
        super(message, cause);
    }

    /**
     * 构造函数
     *
     * @param message   错误消息
     * @param errorCode 错误码
     */
    public PermissionException(String message, String errorCode) {
        super(message, errorCode);
    }

    /**
     * 构造函数
     *
     * @param message   错误消息
     * @param errorCode 错误码
     * @param cause     异常原因
     */
    public PermissionException(String message, String errorCode, Throwable cause) {
        super(message, errorCode, cause);
    }
}