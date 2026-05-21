package com.gg.goods.exception;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * 全局异常处理器
 * 用于统一捕获和处理系统中的所有异常
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * 处理业务异常
     */
    @ExceptionHandler(BusinessException.class)
    public ModelAndView handleBusinessException(BusinessException e, HttpServletRequest request, HttpServletResponse response) {
        logger.error("业务异常: {}", e.getMessage(), e);

        // 判断是否为Ajax请求
        if (isAjaxRequest(request)) {
            handleAjaxException(response, e.getMessage(), e.getErrorCode());
            return null;
        }

        ModelAndView mav = new ModelAndView("jsps/error/error");
        mav.addObject("errorMessage", e.getMessage());
        mav.addObject("errorCode", e.getErrorCode());
        return mav;
    }

    /**
     * 处理权限异常
     */
    @ExceptionHandler(PermissionException.class)
    public ModelAndView handlePermissionException(PermissionException e, HttpServletRequest request, HttpServletResponse response) {
        logger.error("权限异常: {}", e.getMessage(), e);

        // 判断是否为Ajax请求
        if (isAjaxRequest(request)) {
            handleAjaxException(response, "您没有权限执行此操作", e.getErrorCode());
            return null;
        }

        ModelAndView mav = new ModelAndView("error/error");
        mav.addObject("errorMessage", "您没有权限执行此操作");
        mav.addObject("errorCode", e.getErrorCode());
        return mav;
    }

    /**
     * 处理数据库异常
     */
    @ExceptionHandler(DatabaseException.class)
    public ModelAndView handleDatabaseException(DatabaseException e, HttpServletRequest request, HttpServletResponse response) {
        logger.error("数据库异常: {}", e.getMessage(), e);

        // 判断是否为Ajax请求
        if (isAjaxRequest(request)) {
            handleAjaxException(response, "数据库操作失败，请稍后重试", e.getErrorCode());
            return null;
        }

        ModelAndView mav = new ModelAndView("error/error");
        mav.addObject("errorMessage", "数据库操作失败，请稍后重试");
        mav.addObject("errorCode", e.getErrorCode());
        return mav;
    }

    /**
     * 处理空指针异常
     */
    @ExceptionHandler(NullPointerException.class)
    public ModelAndView handleNullPointerException(NullPointerException e, HttpServletRequest request, HttpServletResponse response) {
        logger.error("空指针异常: {}", e.getMessage(), e);

        // 判断是否为Ajax请求
        if (isAjaxRequest(request)) {
            handleAjaxException(response, "系统内部错误，请联系管理员", "500");
            return null;
        }

        ModelAndView mav = new ModelAndView("error/error");
        mav.addObject("errorMessage", "系统内部错误，请联系管理员");
        mav.addObject("errorCode", "500");
        return mav;
    }

    /**
     * 处理404异常
     */
    @ExceptionHandler(NoHandlerFoundException.class)
    public ModelAndView handleNoHandlerFoundException(NoHandlerFoundException e, HttpServletRequest request, HttpServletResponse response) {
        logger.error("404异常: {}", e.getMessage(), e);

        ModelAndView mav = new ModelAndView("jsps/error/404");
        mav.addObject("errorMessage", "您访问的页面不存在");
        mav.addObject("errorCode", "404");
        return mav;
    }

    /**
     * 处理所有其他异常
     */
    @ExceptionHandler(Exception.class)
    public ModelAndView handleException(Exception e, HttpServletRequest request, HttpServletResponse response) {
        logger.error("未捕获的异常: {}", e.getMessage(), e);

        // 判断是否为Ajax请求
        if (isAjaxRequest(request)) {
            handleAjaxException(response, "系统发生未知错误，请联系管理员", "500");
            return null;
        }

        ModelAndView mav = new ModelAndView("error/error");
        mav.addObject("errorMessage", "系统发生未知错误，请联系管理员");
        mav.addObject("errorCode", "500");
        return mav;
    }

    /**
     * 判断是否为Ajax请求
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String header = request.getHeader("X-Requested-With");
        return header != null && "XMLHttpRequest".equals(header);
    }

    /**
     * 处理Ajax请求的异常
     */
    private void handleAjaxException(HttpServletResponse response, String message, String errorCode) {
        response.setContentType("application/json;charset=UTF-8");
        try (PrintWriter writer = response.getWriter()) {
            writer.write("{\"success\":false,\"errorCode\":\"" + errorCode + "\",\"errorMsg\":\"" + message + "\"}");
            writer.flush();
        } catch (IOException e) {
            logger.error("处理Ajax异常失败", e);
        }
    }
}