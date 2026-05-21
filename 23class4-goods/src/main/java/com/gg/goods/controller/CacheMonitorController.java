package com.gg.goods.controller;

import com.gg.goods.service.CacheService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 缓存监控控制器
 * 提供缓存监控的API端点
 */
@RestController
@RequestMapping("/api/cache/monitor")
public class CacheMonitorController {

    @Autowired
    private CacheService cacheService;

    /**
     * 获取所有缓存名称
     */
    @GetMapping("/caches")
    public Map<String, Object> getAllCaches() {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        // 临时提供固定的缓存名称列表
        List<String> cacheNames = Arrays.asList("categories", "books", "pages");
        result.put("data", cacheNames);
        return result;
    }

    /**
     * 获取缓存统计信息
     */
    @GetMapping("/stats")
    public Map<String, Object> getCacheStatistics() {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        // 临时提供空的统计信息
        Map<String, Object> stats = new HashMap<>();
        result.put("data", stats);
        return result;
    }

    /**
     * 获取指定缓存的大小
     */
    @GetMapping("/{cacheName}/size")
    public Map<String, Object> getCacheSize(@PathVariable String cacheName) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", cacheService.getCacheSize(cacheName));
        return result;
    }

    /**
     * 获取指定缓存的命中率
     */
    @GetMapping("/{cacheName}/hit-rate")
    public Map<String, Object> getHitRate(@PathVariable String cacheName) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", cacheService.getHitRate(cacheName));
        return result;
    }

    /**
     * 清除指定缓存
     */
    @DeleteMapping("/{cacheName}")
    public Map<String, Object> clearCache(@PathVariable String cacheName) {
        Map<String, Object> result = new HashMap<>();
        cacheService.clearCache(cacheName);
        result.put("success", true);
        result.put("message", "缓存清除成功");
        return result;
    }

    /**
     * 清除所有缓存
     */
    @DeleteMapping("/all")
    public Map<String, Object> clearAllCaches() {
        Map<String, Object> result = new HashMap<>();
        cacheService.clearAllCaches();
        result.put("success", true);
        result.put("message", "所有缓存清除成功");
        return result;
    }

    /**
     * 获取缓存详情
     */
    @GetMapping("/{cacheName}")
    public Map<String, Object> getCacheDetails(@PathVariable String cacheName) {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> details = new HashMap<>();

        details.put("size", cacheService.getCacheSize(cacheName));
        details.put("hitRate", cacheService.getHitRate(cacheName));
        details.put("averageLoadPenalty", cacheService.getAverageLoadPenalty(cacheName));
        details.put("maximumSize", cacheService.getMaximumSize(cacheName));
        details.put("expireAfterWriteMinutes", cacheService.getExpireAfterWrite(cacheName, TimeUnit.MINUTES));

        result.put("success", true);
        result.put("data", details);
        return result;
    }
}