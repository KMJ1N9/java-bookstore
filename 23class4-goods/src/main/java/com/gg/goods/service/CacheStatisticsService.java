package com.gg.goods.service;

import com.github.benmanes.caffeine.cache.stats.CacheStats;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * 缓存统计服务
 * 提供缓存状态监控、统计和管理功能
 */
@Service
public class CacheStatisticsService {

    @Autowired
    private CacheManager cacheManager;

    /**
     * 获取所有缓存的统计信息
     *
     * @return 缓存统计信息Map
     */
    public Map<String, Object> getCacheStats() {
        Map<String, Object> stats = new HashMap<>();

        Collection<String> cacheNames = cacheManager.getCacheNames();
        for (String cacheName : cacheNames) {
            Cache cache = cacheManager.getCache(cacheName);
            if (cache != null) {
                stats.put(cacheName, getCacheInfo(cache));
            }
        }

        return stats;
    }

    /**
     * 获取单个缓存的详细信息
     *
     * @param cacheName 缓存名称
     * @return 缓存详细信息Map
     */
    public Map<String, Object> getCacheInfo(String cacheName) {
        Cache cache = cacheManager.getCache(cacheName);
        if (cache != null) {
            return getCacheInfo(cache);
        }
        return null;
    }

    /**
     * 获取缓存的详细信息
     *
     * @param cache 缓存对象
     * @return 缓存详细信息Map
     */
    private Map<String, Object> getCacheInfo(Cache cache) {
        Map<String, Object> info = new HashMap<>();
        info.put("name", cache.getName());
        info.put("type", cache.getClass().getSimpleName());

        try {
            // 获取Caffeine缓存统计信息
            if (cache.getNativeCache() instanceof com.github.benmanes.caffeine.cache.Cache) {
                com.github.benmanes.caffeine.cache.Cache nativeCache =
                        (com.github.benmanes.caffeine.cache.Cache) cache.getNativeCache();
                CacheStats stats = nativeCache.stats();

                info.put("hitCount", stats.hitCount());
                info.put("missCount", stats.missCount());
                info.put("hitRate", Math.round(stats.hitRate() * 100.0)); // 转换为百分比
                info.put("missRate", Math.round(stats.missRate() * 100.0)); // 转换为百分比
                info.put("requestCount", stats.requestCount());
                info.put("evictionCount", stats.evictionCount());
                info.put("loadSuccessCount", stats.loadSuccessCount());
                info.put("loadFailureCount", stats.loadFailureCount());
                info.put("averageLoadPenalty", stats.averageLoadPenalty());
                info.put("avgLoadPenalty", Math.round(stats.averageLoadPenalty() / 1000000.0 * 100.0) / 100.0); // 转换为毫秒并保留两位小数
                info.put("size", nativeCache.estimatedSize());

                // 添加最大容量信息
                long maxSize = 1000; // 默认最大值
                switch (cache.getName()) {
                    case "categories":
                        maxSize = 200;
                        break;
                    case "books":
                        maxSize = 2000;
                        break;
                    case "stocks":
                        maxSize = 3000;
                        break;
                    case "users":
                        maxSize = 1500;
                        break;
                    case "orders":
                        maxSize = 6000;
                        break;
                    case "pages":
                        maxSize = 1000;
                        break;
                }
                info.put("maxSize", maxSize);
            }
        } catch (Exception e) {
            info.put("statsError", e.getMessage());
        }

        return info;
    }

    /**
     * 清除指定缓存
     *
     * @param cacheName 缓存名称
     * @return 是否清除成功
     */
    public boolean clearCache(String cacheName) {
        Cache cache = cacheManager.getCache(cacheName);
        if (cache != null) {
            cache.clear();
            return true;
        }
        return false;
    }

    /**
     * 清除所有缓存
     *
     * @return 清除的缓存数量
     */
    public int clearAllCaches() {
        int clearedCount = 0;
        Collection<String> cacheNames = cacheManager.getCacheNames();
        for (String cacheName : cacheNames) {
            Cache cache = cacheManager.getCache(cacheName);
            if (cache != null) {
                cache.clear();
                clearedCount++;
            }
        }
        return clearedCount;
    }

    /**
     * 刷新指定缓存（清除后重新加载）
     *
     * @param cacheName 缓存名称
     * @return 是否刷新成功
     */
    public boolean refreshCache(String cacheName) {
        // 在Caffeine中，刷新就是清除后等待下次请求重新加载
        return clearCache(cacheName);
    }

    /**
     * 获取所有缓存名称
     *
     * @return 缓存名称集合
     */
    public Collection<String> getAllCacheNames() {
        return cacheManager.getCacheNames();
    }
}
