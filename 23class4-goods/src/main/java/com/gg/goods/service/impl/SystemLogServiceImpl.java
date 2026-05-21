package com.gg.goods.service.impl;

import com.gg.goods.entity.SystemLog;
import com.gg.goods.mapper.SystemLogMapper;
import com.gg.goods.service.SystemLogService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * 系统日志服务实现类
 */
@Service
@Slf4j
public class SystemLogServiceImpl implements SystemLogService {

    @Autowired
    private SystemLogMapper systemLogMapper;

    @Override
    public void recordLog(SystemLog systemLog) {
        try {
            // 生成日志ID
            if (systemLog.getId() == null) {
                systemLog.setId(UUID.randomUUID().toString().replace("-", ""));
            }
            // 设置操作时间
            if (systemLog.getOperateTime() == null) {
                systemLog.setOperateTime(new Date());
            }
            // 保存日志
            systemLogMapper.insert(systemLog);
        } catch (Exception e) {
            // 记录日志失败时不影响主流程，只打印错误信息
            log.error("记录系统日志失败: {}", e.getMessage());
        }
    }

    @Override
    public void recordLog(String operator, String action, String status, String businessId, HttpServletRequest request) {
        try {
            SystemLog systemLog = new SystemLog();
            systemLog.setId(UUID.randomUUID().toString().replace("-", ""));
            systemLog.setOperateTime(new Date());
            systemLog.setOperator(operator);
            systemLog.setAction(action);
            systemLog.setStatus(status);
            systemLog.setBusinessId(businessId);

            // 从请求中获取IP地址
            if (request != null) {
                String ip = request.getHeader("X-Forwarded-For");
                if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
                    ip = request.getHeader("Proxy-Client-IP");
                }
                if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
                    ip = request.getHeader("WL-Proxy-Client-IP");
                }
                if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
                    ip = request.getRemoteAddr();
                }
                // 处理多个IP的情况
                if (ip != null && ip.contains(",")) {
                    ip = ip.split(",")[0].trim();
                }
                systemLog.setIp(ip);
            }

            systemLogMapper.insert(systemLog);
        } catch (Exception e) {
            // 记录日志失败时不影响主流程，只打印错误信息
            log.error("记录系统日志失败: {}", e.getMessage());
        }
    }

    @Override
    public List<SystemLog> getRecentLogs(int limit) {
        return systemLogMapper.selectRecentLogs(limit);
    }

    @Override
    public List<SystemLog> getLogsByDateRange(Date startDate, Date endDate, int limit) {
        return systemLogMapper.selectByDateRange(startDate, endDate, limit);
    }
}