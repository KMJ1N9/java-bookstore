package com.gg.goods.service;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 缓存服务接口
 * 提供缓存管理、监控和性能优化功能
 */
public interface CacheService {

    /**
     * 获取所有缓存名称
     *
     * @return 缓存名称列表
     */
    List<String> getCacheNames();

    /**
     * 获取指定缓存的大小
     *
     * @param cacheName 缓存名称
     * @return 缓存大小
     */
    long getCacheSize(String cacheName);

    /**
     * 获取指定缓存的命中率
     *
     * @param cacheName 缓存名称
     * @return 命中率（0.0-1.0）
     */
    double getHitRate(String cacheName);

    /**
     * 获取指定缓存的平均加载时间
     *
     * @param cacheName 缓存名称
     * @return 平均加载时间（纳秒）
     */
    double getAverageLoadPenalty(String cacheName);

    /**
     * 获取指定缓存的驱逐数量
     *
     * @param cacheName 缓存名称
     * @return 驱逐数量
     */
    long getEvictionCount(String cacheName);

    /**
     * 清除指定缓存
     *
     * @param cacheName 缓存名称
     * @return 是否清除成功
     */
    boolean clearCache(String cacheName);

    /**
     * 清除所有缓存
     */
    void clearAllCaches();

    /**
     * 获取指定缓存的详细统计信息
     *
     * @param cacheName 缓存名称
     * @return 缓存统计信息
     */
    Map<String, Object> getCacheStatistics(String cacheName);

    /**
     * 获取所有缓存的详细统计信息
     *
     * @return 所有缓存的统计信息列表
     */
    List<Map<String, Object>> getAllCacheStatistics();

    /**
     * 获取指定缓存的最大容量
     *
     * @param cacheName 缓存名称
     * @return 最大容量
     */
    long getMaximumSize(String cacheName);

    /**
     * 获取指定缓存的过期时间
     *
     * @param cacheName 缓存名称
     * @param timeUnit  时间单位
     * @return 过期时间
     */
    long getExpireAfterWrite(String cacheName, TimeUnit timeUnit);

    /**
     * 刷新指定缓存（重新加载数据）
     *
     * @param cacheName 缓存名称
     * @return 是否刷新成功
     */
    boolean refreshCache(String cacheName);

    /**
     * 获取缓存系统的健康状态
     *
     * @return 系统健康状态信息
     */
    Map<String, Object> getSystemHealthStatus();

    /**
     * 预热指定缓存
     *
     * @param cacheName 缓存名称
     * @return 是否预热成功
     */
    boolean warmupCache(String cacheName);

    /**
     * 检查缓存是否存在
     *
     * @param cacheName 缓存名称
     * @return 是否存在
     */
    boolean cacheExists(String cacheName);

    /**
     * 获取缓存内存使用估算
     *
     * @param cacheName 缓存名称
     * @return 内存使用估算（字节）
     */
    long estimateMemoryUsage(String cacheName);

    /**
     * 获取缓存中的值
     *
     * @param cacheName 缓存名称
     * @param key       缓存键
     * @return 缓存的值，如果不存在返回null
     */
    <T> T getCacheValue(String cacheName, Object key);
}