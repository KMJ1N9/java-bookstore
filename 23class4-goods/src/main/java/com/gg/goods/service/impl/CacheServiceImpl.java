package com.gg.goods.service.impl;

import com.gg.goods.service.BookService;
import com.gg.goods.service.CacheService;
import com.gg.goods.service.CategoryService;
import com.gg.goods.service.StockService;
import com.github.benmanes.caffeine.cache.stats.CacheStats;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.caffeine.CaffeineCache;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

@Service
public class CacheServiceImpl implements CacheService {

    private static final Logger logger = LoggerFactory.getLogger(CacheServiceImpl.class);

    @Autowired
    private CacheManager cacheManager;

    @Autowired
    private ApplicationContext applicationContext;

    // 服务注入，用于缓存预热
    @Autowired(required = false)
    private CategoryService categoryService;

    @Autowired(required = false)
    private BookService bookService;

    @Autowired(required = false)
    private StockService stockService;

    // 缓存访问计数器，用于更细粒度的性能监控
    private final Map<String, AtomicLong> cacheAccessCounter = new ConcurrentHashMap<>();
    private final Map<String, AtomicLong> cacheHitCounter = new ConcurrentHashMap<>();
    private final Map<String, AtomicLong> cacheMissCounter = new ConcurrentHashMap<>();

    // 缓存操作时间记录
    private final Map<String, AtomicLong> totalOperationTime = new ConcurrentHashMap<>();

    @Override
    public List<String> getCacheNames() {
        long startTime = System.currentTimeMillis();
        try {
            return new ArrayList<>(cacheManager.getCacheNames());
        } finally {
            updateOperationTime("getCacheNames", System.currentTimeMillis() - startTime);
        }
    }

    @Override
    public long getCacheSize(String cacheName) {
        long startTime = System.currentTimeMillis();
        try {
            updateAccessCounter(cacheName);

            Cache cache = cacheManager.getCache(cacheName);
            if (cache instanceof CaffeineCache) {
                CaffeineCache caffeineCache = (CaffeineCache) cache;

                // 获取近似缓存大小
                long estimatedSize = caffeineCache.getNativeCache().estimatedSize();
                updateHitCounter(cacheName);
                return estimatedSize;
            }
            updateMissCounter(cacheName);
            return 0;
        } finally {
            updateOperationTime("getCacheSize", System.currentTimeMillis() - startTime);
        }
    }

    @Override
    public double getHitRate(String cacheName) {
        long startTime = System.currentTimeMillis();
        try {
            updateAccessCounter(cacheName);

            long hits = getCounterValue(cacheName, cacheHitCounter);
            long misses = getCounterValue(cacheName, cacheMissCounter);
            long totalRequests = hits + misses;

            if (totalRequests > 0) {
                return (double) hits / totalRequests;
            }

            // 如果没有自定义计数器数据，尝试从Caffeine统计获取
            Cache cache = cacheManager.getCache(cacheName);
            if (cache instanceof CaffeineCache) {
                CaffeineCache caffeineCache = (CaffeineCache) cache;
                CacheStats stats = caffeineCache.getNativeCache().stats();
                return stats.hitRate();
            }

            return 0;
        } finally {
            updateOperationTime("getHitRate", System.currentTimeMillis() - startTime);
        }
    }

    @Override
    public double getAverageLoadPenalty(String cacheName) {
        long startTime = System.currentTimeMillis();
        try {
            updateAccessCounter(cacheName);

            Cache cache = cacheManager.getCache(cacheName);
            if (cache instanceof CaffeineCache) {
                CaffeineCache caffeineCache = (CaffeineCache) cache;
                CacheStats stats = caffeineCache.getNativeCache().stats();

                double avgLoadPenalty = stats.averageLoadPenalty();
                updateHitCounter(cacheName);
                return avgLoadPenalty;
            }
            updateMissCounter(cacheName);
            return 0;
        } finally {
            updateOperationTime("getAverageLoadPenalty", System.currentTimeMillis() - startTime);
        }
    }

    @Override
    public long getEvictionCount(String cacheName) {
        long startTime = System.currentTimeMillis();
        try {
            updateAccessCounter(cacheName);

            Cache cache = cacheManager.getCache(cacheName);
            if (cache instanceof CaffeineCache) {
                CaffeineCache caffeineCache = (CaffeineCache) cache;
                CacheStats stats = caffeineCache.getNativeCache().stats();

                long evictionCount = stats.evictionCount();
                updateHitCounter(cacheName);
                return evictionCount;
            }
            updateMissCounter(cacheName);
            return 0;
        } finally {
            updateOperationTime("getEvictionCount", System.currentTimeMillis() - startTime);
        }
    }

    @Override
    public boolean clearCache(String cacheName) {
        long startTime = System.currentTimeMillis();
        try {
            updateAccessCounter(cacheName);

            Cache cache = cacheManager.getCache(cacheName);
            if (cache != null) {
                cache.clear();
                logger.info("已清除缓存: {}", cacheName);

                // 重置统计计数器
                resetCacheCounters(cacheName);
                updateHitCounter(cacheName);
                return true;
            }
            updateMissCounter(cacheName);
            return false;
        } catch (Exception e) {
            logger.error("清除缓存 {} 时出错: {}", cacheName, e.getMessage(), e);
            return false;
        } finally {
            updateOperationTime("clearCache", System.currentTimeMillis() - startTime);
        }
    }

    @Override
    public void clearAllCaches() {
        long startTime = System.currentTimeMillis();
        try {
            List<String> cacheNames = new ArrayList<>(cacheManager.getCacheNames());
            for (String cacheName : cacheNames) {
                clearCache(cacheName);
            }
            logger.info("已清除所有缓存，共 {} 个缓存", cacheNames.size());
        } catch (Exception e) {
            logger.error("清除所有缓存时出错: {}", e.getMessage(), e);
        } finally {
            updateOperationTime("clearAllCaches", System.currentTimeMillis() - startTime);
        }
    }

    @Override
    public Map<String, Object> getCacheStatistics(String cacheName) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("cacheName", cacheName);

        try {
            Cache cache = cacheManager.getCache(cacheName);
            if (cache != null) {
                stats.put("size", getCacheSize(cacheName));
                stats.put("maxSize", getMaximumSize(cacheName));
                stats.put("expireTime", getExpireAfterWrite(cacheName, TimeUnit.SECONDS));
                stats.put("evictionCount", getEvictionCount(cacheName));

                // 添加内存使用估算
                stats.put("estimatedMemoryUsageBytes", estimateMemoryUsage(cacheName));

                // 添加缓存访问统计
                long hits = getCounterValue(cacheName, cacheHitCounter);
                long misses = getCounterValue(cacheName, cacheMissCounter);
                long totalRequests = hits + misses;
                double hitRate = getHitRate(cacheName);

                stats.put("hits", hits);
                stats.put("misses", misses);
                stats.put("totalRequests", totalRequests);
                stats.put("hitRate", hitRate);

                // 添加健康状态
                String healthStatus = "EXCELLENT";
                if (hitRate < 0.7) {
                    healthStatus = "WARNING";
                }
                if (hitRate < 0.5) {
                    healthStatus = "CRITICAL";
                }
                stats.put("healthStatus", healthStatus);

                // 添加效率评分
                int efficiencyScore = (int) (hitRate * 100);
                stats.put("efficiencyScore", efficiencyScore);

                // 添加配置信息
                Map<String, Object> configMap = new HashMap<>();
                configMap.put("maximumSize", getMaximumSize(cacheName));
                configMap.put("expireAfterWrite", getExpireAfterWrite(cacheName, TimeUnit.SECONDS));
                configMap.put("recordStats", true);
                stats.put("config", configMap);

            } else {
                stats.put("error", "缓存不存在");
            }
        } catch (Exception e) {
            logger.error("获取缓存 {} 统计信息时出错: {}", cacheName, e.getMessage(), e);
            stats.put("error", e.getMessage());
        }

        return stats;
    }

    @Override
    public List<Map<String, Object>> getAllCacheStatistics() {
        return cacheManager.getCacheNames().stream()
                .map(this::getCacheStatistics)
                .collect(Collectors.toList());
    }

    @Override
    public long getMaximumSize(String cacheName) {
        // 与CacheConfig.java中的配置保持一致
        switch (cacheName) {
            case "categories":
                return 200;
            case "books":
                return 2000;
            case "stocks":
                return 3000;
            case "users":
                return 1500;
            case "orders":
                return 6000;
            case "pages":
                return 1000;
            default:
                return 1000;
        }
    }

    @Override
    public long getExpireAfterWrite(String cacheName, TimeUnit timeUnit) {
        // 返回不同缓存的过期时间，单位转换为指定的timeUnit
        long expireTimeSeconds;
        switch (cacheName) {
            case "categories":
                expireTimeSeconds = 7200; // 2小时
                break;
            case "books":
                expireTimeSeconds = 1800; // 30分钟
                break;
            case "stocks":
                expireTimeSeconds = 180; // 3分钟
                break;
            case "users":
                expireTimeSeconds = 1800; // 30分钟
                break;
            case "orders":
                expireTimeSeconds = 600; // 10分钟
                break;
            case "pages":
                expireTimeSeconds = 900; // 15分钟
                break;
            default:
                expireTimeSeconds = 600; // 默认10分钟
        }

        return timeUnit.convert(expireTimeSeconds, TimeUnit.SECONDS);
    }

    @Override
    public boolean refreshCache(String cacheName) {
        try {
            Cache cache = cacheManager.getCache(cacheName);
            if (cache != null) {
                cache.clear();
                // 立即预热缓存
                return warmupCache(cacheName);
            }
            return false;
        } catch (Exception e) {
            logger.error("Failed to refresh cache: {}", cacheName, e);
            return false;
        }
    }

    @Override
    public boolean cacheExists(String cacheName) {
        CacheManager cacheManager = (CacheManager) applicationContext.getBean("cacheManager");
        return cacheManager != null && cacheManager.getCache(cacheName) != null;
    }

    @Override
    public boolean warmupCache(String cacheName) {
        try {
            switch (cacheName) {
                case "categories":
                    // 预热分类缓存
                    if (categoryService != null) {
                        // 获取所有分类
                        List<?> categories = categoryService.loadCategories();
                        logger.info("Warming up categories cache with {} items", categories != null ? categories.size() : 0);
                    }
                    break;
                case "books":
                    if (bookService != null) {
                        bookService.getHotBooks(10);
                        bookService.getNewestBooks(10);
                        return true;
                    }
                    break;
                case "stocks":
                    if (stockService != null) {
                        stockService.getAllStocks();
                        return true;
                    }
                    break;
                // 其他缓存的预热逻辑...
            }
            return false;
        } catch (Exception e) {
            logger.error("Failed to warmup cache: {}", cacheName, e);
            return false;
        }
    }

    @Override
    public long estimateMemoryUsage(String cacheName) {
        // 估算每个缓存的内存使用
        // 这是一个近似值，实际使用会根据缓存对象大小有所不同
        try {
            long size = getCacheSize(cacheName);
            // 估算每个缓存项平均大小（字节）
            switch (cacheName) {
                case "categories":
                    return size * 1024; // 约1KB每个分类
                case "books":
                    return size * 4096; // 约4KB每本图书
                case "stocks":
                    return size * 512;  // 约512B每条库存记录
                case "users":
                    return size * 2048; // 约2KB每个用户
                case "orders":
                    return size * 8192; // 约8KB每个订单
                case "pages":
                    return size * 32768; // 约32KB每个页面缓存
                default:
                    return size * 1024;
            }
        } catch (Exception e) {
            logger.error("估算缓存 {} 内存使用时出错: {}", cacheName, e.getMessage(), e);
            return 0;
        }
    }

    /**
     * 估算缓存系统总体内存使用
     *
     * @return 估算的内存使用量（字节）
     */
    private long estimateTotalMemoryUsage() {
        long total = 0;
        for (String cacheName : cacheManager.getCacheNames()) {
            total += estimateMemoryUsage(cacheName);
        }
        return total;
    }

    /**
     * 获取缓存中的值
     */
    @Override
    @SuppressWarnings("unchecked")
    public <T> T getCacheValue(String cacheName, Object key) {
        long startTime = System.currentTimeMillis();
        try {
            updateAccessCounter(cacheName);

            Cache cache = cacheManager.getCache(cacheName);
            if (cache != null) {
                Cache.ValueWrapper wrapper = cache.get(key);
                boolean hit = wrapper != null;

                if (hit) {
                    updateHitCounter(cacheName);
                    return (T) wrapper.get();
                } else {
                    updateMissCounter(cacheName);
                    return null;
                }
            }
            updateMissCounter(cacheName);
            return null;
        } finally {
            updateOperationTime("getCacheValue", System.currentTimeMillis() - startTime);
        }
    }

    /**
     * 计算缓存效率评分
     */
    private int calculateEfficiencyScore(CacheStats stats) {
        double hitRate = stats.hitRate();
        // 使用默认值1.0替代不存在的loadSuccessRate方法
        double loadSuccessRate = 1.0; // stats.loadSuccessRate();
        long evictionCount = stats.evictionCount();
        double avgLoadPenalty = stats.averageLoadPenalty();

        // 命中率占60%权重
        int hitScore = (int) (hitRate * 60);

        // 加载成功率占20%权重
        int loadScore = (int) (loadSuccessRate * 20);

        // 驱逐率评分（驱逐越少越好）
        int evictionScore = Math.max(0, 10 - (int) (Math.log10(Math.max(1, evictionCount)) * 5));

        // 加载时间评分（加载越快越好）
        int loadTimeScore = Math.max(0, 10 - (int) (Math.log10(Math.max(1, avgLoadPenalty))));

        return Math.min(100, hitScore + loadScore + evictionScore + loadTimeScore);
    }

    /**
     * 更新访问计数器
     */
    private void updateAccessCounter(String cacheName) {
        cacheAccessCounter.computeIfAbsent(cacheName, k -> new AtomicLong(0)).incrementAndGet();
    }

    /**
     * 更新命中计数器
     */
    private void updateHitCounter(String cacheName) {
        cacheHitCounter.computeIfAbsent(cacheName, k -> new AtomicLong(0)).incrementAndGet();
    }

    /**
     * 更新未命中计数器
     */
    private void updateMissCounter(String cacheName) {
        cacheMissCounter.computeIfAbsent(cacheName, k -> new AtomicLong(0)).incrementAndGet();
    }

    /**
     * 更新操作时间统计
     */
    private void updateOperationTime(String operation, long timeMs) {
        totalOperationTime.computeIfAbsent(operation, k -> new AtomicLong(0)).addAndGet(timeMs);
    }

    /**
     * 获取计数器值
     */
    private long getCounterValue(String cacheName, Map<String, AtomicLong> counterMap) {
        AtomicLong counter = counterMap.get(cacheName);
        return counter != null ? counter.get() : 0;
    }

    /**
     * 重置缓存计数器
     */
    private void resetCacheCounters(String cacheName) {
        cacheAccessCounter.remove(cacheName);
        cacheHitCounter.remove(cacheName);
        cacheMissCounter.remove(cacheName);
    }

    /**
     * 获取缓存系统整体健康状态
     */
    @Override
    public Map<String, Object> getSystemHealthStatus() {
        Map<String, Object> healthStatus = new HashMap<>();

        try {
            List<Map<String, Object>> allStats = getAllCacheStatistics();

            // 计算整体命中率
            double totalHitRate = allStats.stream()
                    .mapToDouble(stat -> (double) stat.getOrDefault("hitRate", 0.0))
                    .average()
                    .orElse(0.0);

            // 计算平均效率评分
            int avgEfficiencyScore = (int) allStats.stream()
                    .mapToInt(stat -> (int) stat.getOrDefault("efficiencyScore", 0))
                    .average()
                    .orElse(0.0);

            // 统计缓存数量
            int cacheCount = allStats.size();
            int healthyCacheCount = (int) allStats.stream()
                    .filter(stat -> "EXCELLENT".equals(stat.get("healthStatus")))
                    .count();
            int warningCacheCount = (int) allStats.stream()
                    .filter(stat -> "WARNING".equals(stat.get("healthStatus")))
                    .count();
            int criticalCacheCount = (int) allStats.stream()
                    .filter(stat -> "CRITICAL".equals(stat.get("healthStatus")))
                    .count();

            // 估算总内存使用
            long totalEstimatedMemory = allStats.stream()
                    .mapToLong(stat -> (long) stat.getOrDefault("estimatedMemoryUsageBytes", 0L))
                    .sum();

            // 计算内存使用率
            Map<String, Object> memoryUsage = new HashMap<>();
            memoryUsage.put("totalEstimatedMemoryUsageBytes", totalEstimatedMemory);
            memoryUsage.put("totalEstimatedMemoryUsageMB", (double) totalEstimatedMemory / (1024 * 1024));

            // 计算缓存使用率
            Map<String, Double> utilizationRates = new HashMap<>();
            double avgUtilizationRate = 0;
            long totalSize = 0;
            long totalMaxSize = 0;

            for (Map<String, Object> stat : allStats) {
                String cacheName = (String) stat.get("cacheName");
                long size = (long) stat.getOrDefault("size", 0L);
                long maxSize = (long) stat.getOrDefault("maxSize", 1L);
                double utilizationRate = (double) size / maxSize;
                utilizationRates.put(cacheName, utilizationRate);
                totalSize += size;
                totalMaxSize += maxSize;
            }

            if (totalMaxSize > 0) {
                avgUtilizationRate = (double) totalSize / totalMaxSize;
            }

            // 计算平均响应时间（毫秒）
            double avgResponseTime = calculateAverageResponseTime();

            healthStatus.put("timestamp", System.currentTimeMillis());
            healthStatus.put("totalCacheCount", cacheCount);
            healthStatus.put("healthyCacheCount", healthyCacheCount);
            healthStatus.put("warningCacheCount", warningCacheCount);
            healthStatus.put("criticalCacheCount", criticalCacheCount);
            healthStatus.put("overallHitRate", totalHitRate);
            healthStatus.put("averageEfficiencyScore", avgEfficiencyScore);
            healthStatus.put("memoryUsage", memoryUsage);
            healthStatus.put("cacheUtilizationRate", avgUtilizationRate);
            healthStatus.put("averageResponseTimeMs", avgResponseTime);
            healthStatus.put("cacheDistribution", utilizationRates);

            // 整体健康状态
            String overallStatus = "HEALTHY";
            if (totalHitRate < 0.6) {
                overallStatus = "DEGRADED";
            }
            if (totalHitRate < 0.4 || criticalCacheCount > 0) {
                overallStatus = "CRITICAL";
            }
            healthStatus.put("overallStatus", overallStatus);

            // 性能优化建议
            List<String> optimizationSuggestions = new ArrayList<>();
            if (totalHitRate < 0.6) {
                optimizationSuggestions.add("整体缓存命中率低于60%，建议增加缓存容量或优化缓存策略");
            }
            if (avgEfficiencyScore < 60) {
                optimizationSuggestions.add("平均缓存效率评分低于60分，建议检查缓存使用模式");
            }
            if (avgUtilizationRate > 0.8) {
                optimizationSuggestions.add("平均缓存使用率超过80%，可能需要增加缓存容量");
            }
            if (avgResponseTime > 50) {
                optimizationSuggestions.add("平均响应时间超过50ms，建议优化缓存访问模式");
            }
            if (criticalCacheCount > 0) {
                optimizationSuggestions.add("存在" + criticalCacheCount + "个严重状态的缓存，需要立即检查和优化");
            }

            healthStatus.put("optimizationSuggestions", optimizationSuggestions);

        } catch (Exception e) {
            logger.error("获取缓存系统健康状态时出错: {}", e.getMessage(), e);
            healthStatus.put("error", e.getMessage());
            healthStatus.put("overallStatus", "ERROR");
        }

        return healthStatus;
    }

    /**
     * 计算缓存操作的平均响应时间（毫秒）
     */
    private double calculateAverageResponseTime() {
        long totalTime = 0;
        long totalOperations = 0;

        // 统计所有操作的平均响应时间
        for (Map.Entry<String, AtomicLong> entry : totalOperationTime.entrySet()) {
            totalTime += entry.getValue().get();
            // 假设每个操作类型的访问次数
            String operation = entry.getKey();
            switch (operation) {
                case "getCacheNames":
                case "clearAllCaches":
                    // 这类操作通常执行次数较少
                    totalOperations += 10; // 估计值
                    break;
                default:
                    // 其他操作假设执行了更多次数
                    totalOperations += 100; // 估计值
                    break;
            }
        }

        return totalOperations > 0 ? (double) totalTime / totalOperations : 0;
    }
}