package com.gg.goods.exception;

/**
 * 业务异常类
 * 用于处理业务逻辑相关的异常
 */
public class BusinessException extends BaseException {
    private static final long serialVersionUID = 1L;

    /**
     * 构造函数
     */
    public BusinessException() {
        super();
    }

    /**
     * 构造函数
     *
     * @param message 错误消息
     */
    public BusinessException(String message) {
        super(message);
    }

    /**
     * 构造函数
     *
     * @param message 错误消息
     * @param cause   异常原因
     */
    public BusinessException(String message, Throwable cause) {
        super(message, cause);
    }

    /**
     * 构造函数
     *
     * @param message   错误消息
     * @param errorCode 错误码
     */
    public BusinessException(String message, String errorCode) {
        super(message, errorCode);
    }

    /**
     * 构造函数
     *
     * @param message   错误消息
     * @param errorCode 错误码
     * @param cause     异常原因
     */
    public BusinessException(String message, String errorCode, Throwable cause) {
        super(message, errorCode, cause);
    }
}