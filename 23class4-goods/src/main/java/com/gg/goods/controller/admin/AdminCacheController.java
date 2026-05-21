package com.gg.goods.controller.admin;

import com.gg.goods.service.CacheStatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * 缓存管理控制器
 * 提供缓存监控和管理的REST API接口
 */
@RestController
@RequestMapping("/admin/cache")
public class AdminCacheController {

    @Autowired
    private CacheStatisticsService cacheStatisticsService;

    /**
     * 获取所有缓存的统计信息
     *
     * @return 缓存统计信息Map
     */
    @GetMapping("/stats")
    public Map<String, Object> getCacheStats() {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> stats = cacheStatisticsService.getCacheStats();
            result.put("success", true);
            result.put("data", stats);
            result.put("message", "获取缓存统计信息成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取缓存统计信息失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 获取单个缓存的详细信息
     *
     * @param cacheName 缓存名称
     * @return 缓存详细信息Map
     */
    @GetMapping("/stats/{cacheName}")
    public Map<String, Object> getCacheInfo(@PathVariable String cacheName) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> info = cacheStatisticsService.getCacheInfo(cacheName);
            if (info != null) {
                result.put("success", true);
                result.put("data", info);
                result.put("message", "获取缓存信息成功");
            } else {
                result.put("success", false);
                result.put("message", "缓存不存在: " + cacheName);
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取缓存信息失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 获取所有缓存名称
     *
     * @return 缓存名称列表
     */
    @GetMapping("/names")
    public Map<String, Object> getCacheNames() {
        Map<String, Object> result = new HashMap<>();
        try {
            Collection<String> cacheNames = cacheStatisticsService.getAllCacheNames();
            result.put("success", true);
            result.put("data", cacheNames);
            result.put("message", "获取缓存名称列表成功");
            result.put("count", cacheNames.size());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取缓存名称列表失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 清除指定缓存
     *
     * @param cacheName 缓存名称
     * @return 操作结果
     */
    @DeleteMapping("/{cacheName}")
    public Map<String, Object> clearCache(@PathVariable String cacheName) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = cacheStatisticsService.clearCache(cacheName);
            if (success) {
                result.put("success", true);
                result.put("message", "清除缓存成功: " + cacheName);
            } else {
                result.put("success", false);
                result.put("message", "缓存不存在或清除失败: " + cacheName);
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "清除缓存失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 清除所有缓存
     *
     * @return 操作结果
     */
    @DeleteMapping("/clearAll")
    public Map<String, Object> clearAllCaches() {
        Map<String, Object> result = new HashMap<>();
        try {
            int clearedCount = cacheStatisticsService.clearAllCaches();
            result.put("success", true);
            result.put("message", "清除所有缓存成功");
            result.put("clearedCount", clearedCount);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "清除所有缓存失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 刷新指定缓存
     *
     * @param cacheName 缓存名称
     * @return 操作结果
     */
    @PutMapping("/refresh/{cacheName}")
    public Map<String, Object> refreshCache(@PathVariable String cacheName) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = cacheStatisticsService.refreshCache(cacheName);
            if (success) {
                result.put("success", true);
                result.put("message", "刷新缓存成功: " + cacheName);
            } else {
                result.put("success", false);
                result.put("message", "缓存不存在或刷新失败: " + cacheName);
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "刷新缓存失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 获取缓存管理系统状态
     *
     * @return 系统状态信息
     */
    @GetMapping("/status")
    public Map<String, Object> getSystemStatus() {
        Map<String, Object> result = new HashMap<>();
        try {
            Collection<String> cacheNames = cacheStatisticsService.getAllCacheNames();
            Map<String, Object> stats = cacheStatisticsService.getCacheStats();

            // 计算总体统计
            long totalHits = 0;
            long totalMisses = 0;
            for (Object cacheStats : stats.values()) {
                if (cacheStats instanceof Map) {
                    Map<?, ?> cacheStatMap = (Map<?, ?>) cacheStats;
                    // 安全地获取并转换值
                    Object hitCountObj = cacheStatMap.get("hitCount");
                    Object missCountObj = cacheStatMap.get("missCount");

                    if (hitCountObj instanceof Number) {
                        totalHits += ((Number) hitCountObj).longValue();
                    }
                    if (missCountObj instanceof Number) {
                        totalMisses += ((Number) missCountObj).longValue();
                    }
                }
            }
            double totalHitRate = (totalHits + totalMisses) > 0 ?
                    (double) totalHits / (totalHits + totalMisses) : 0.0;

            // 使用HashMap替代Map.of避免类型推断问题
            Map<String, Object> data = new HashMap<>();
            data.put("cacheCount", Integer.valueOf(cacheNames.size()));
            data.put("cacheNames", cacheNames);
            data.put("totalHits", Long.valueOf(totalHits));
            data.put("totalMisses", Long.valueOf(totalMisses));
            data.put("totalHitRate", Double.valueOf(totalHitRate));

            result.put("success", Boolean.TRUE);
            result.put("message", "获取缓存系统状态成功");
            result.put("data", data);
        } catch (Exception e) {
            result.put("success", Boolean.FALSE);
            result.put("message", "获取缓存系统状态失败: " + e.getMessage());
        }
        return result;
    }
}