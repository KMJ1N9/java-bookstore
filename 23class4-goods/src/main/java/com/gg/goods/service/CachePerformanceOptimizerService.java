package com.gg.goods.service;

import java.util.List;
import java.util.Map;

/**
 * 缓存性能优化器服务接口
 * 提供智能缓存管理和性能优化功能
 */
public interface CachePerformanceOptimizerService {

    /**
     * 执行缓存性能优化
     * 分析缓存使用模式，优化缓存配置，并执行缓存预热
     */
    void optimizeCachePerformance();

    /**
     * 执行智能缓存预热
     * 根据缓存重要性和使用模式进行优先级预热
     */
    void performIntelligentWarmup();

    /**
     * 分析访问模式并调整预热策略
     *
     * @param cacheName 缓存名称
     */
    void analyzeAccessPatternAndAdjustWarmup(String cacheName);

    /**
     * 清理低效率缓存
     * 移除长时间未访问且命中率低的缓存数据
     */
    void cleanUpInefficientCaches();

    /**
     * 获取缓存优化报告
     *
     * @return 包含缓存系统性能指标和优化建议的报告
     */
    Map<String, Object> getOptimizationReport();

    /**
     * 执行缓存批量优化操作
     *
     * @param cacheNames 需要优化的缓存名称列表
     */
    void batchOptimizeCaches(List<String> cacheNames);

    /**
     * 获取缓存使用模式分析
     *
     * @param cacheName 缓存名称
     * @return 缓存使用模式数据
     */
    Map<String, Object> getCacheUsagePattern(String cacheName);
}