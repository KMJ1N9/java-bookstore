package com.gg.goods.service;

import com.gg.goods.entity.SystemLog;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Date;
import java.util.List;

/**
 * 系统日志服务接口
 * 提供系统日志的记录和查询功能
 */
public interface SystemLogService {

    /**
     * 记录系统日志
     *
     * @param log 日志对象
     */
    void recordLog(SystemLog log);

    /**
     * 便捷方法：记录系统日志
     *
     * @param operator   操作人
     * @param action     操作内容
     * @param status     状态
     * @param businessId 业务ID
     * @param request    HTTP请求（用于获取IP）
     */
    void recordLog(String operator, String action, String status, String businessId, HttpServletRequest request);

    /**
     * 获取最近的系统日志
     *
     * @param limit 数量限制
     * @return 日志列表
     */
    List<SystemLog> getRecentLogs(int limit);

    /**
     * 根据日期范围获取系统日志
     *
     * @param startDate 开始日期
     * @param endDate   结束日期
     * @param limit     数量限制
     * @return 日志列表
     */
    List<SystemLog> getLogsByDateRange(Date startDate, Date endDate, int limit);
}

