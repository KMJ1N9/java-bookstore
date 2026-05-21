package com.gg.goods.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import lombok.extern.slf4j.Slf4j;

/**
 * 应用启动监听器
 * 用于在应用启动时记录启动时间，以便验证会话是否在应用重启后创建
 */
@WebListener
@Slf4j
public class AppStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // 记录应用启动时间
        long startupTime = System.currentTimeMillis();
        sce.getServletContext().setAttribute("appStartupTime", startupTime);
        log.info("应用启动时间已记录: {}", startupTime);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 应用关闭时的清理工作（如果需要）
    }
}
