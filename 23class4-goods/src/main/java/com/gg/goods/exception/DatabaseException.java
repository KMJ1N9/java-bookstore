package com.gg.goods.exception;

/**
 * 数据库异常类
 * 用于处理数据库操作相关的异常
 */
public class DatabaseException extends BaseException {
    private static final long serialVersionUID = 1L;

    /**
     * 构造函数
     */
    public DatabaseException() {
        super();
    }

    /**
     * 构造函数
     *
     * @param message 错误消息
     */
    public DatabaseException(String message) {
        super(message);
    }

    /**
     * 构造函数
     *
     * @param message 错误消息
     * @param cause   异常原因
     */
    public DatabaseException(String message, Throwable cause) {
        super(message, cause);
    }

    /**
     * 构造函数
     *
     * @param message   错误消息
     * @param errorCode 错误码
     */
    public DatabaseException(String message, String errorCode) {
        super(message, errorCode);
    }

    /**
     * 构造函数
     *
     * @param message   错误消息
     * @param errorCode 错误码
     * @param cause     异常原因
     */
    public DatabaseException(String message, String errorCode, Throwable cause) {
        super(message, errorCode, cause);
    }
}