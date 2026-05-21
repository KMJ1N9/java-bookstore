package com.gg.goods.service;

import java.util.Map;

/**
 * 管理员仪表盘服务接口
 * 提供仪表盘所需的实时数据
 */
public interface AdminDashboardService {

    /**
     * 获取仪表盘统计数据
     *
     * @return 包含统计数据和最近活动的Map
     */
    Map<String, Object> getDashboardStats();
}
