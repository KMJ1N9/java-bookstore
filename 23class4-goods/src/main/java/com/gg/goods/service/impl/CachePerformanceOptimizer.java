package com.gg.goods.service.impl;

import com.gg.goods.service.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 缓存性能优化器 - 实现智能缓存管理和自动优化
 */
@Component
public class CachePerformanceOptimizer implements CachePerformanceOptimizerService {

    private static final Logger logger = LoggerFactory.getLogger(CachePerformanceOptimizer.class);

    @Autowired
    private CacheService cacheService;

    @Autowired(required = false)
    private CategoryService categoryService;

    @Autowired(required = false)
    private BookService bookService;

    @Autowired(required = false)
    private StockService stockService;

    // 缓存使用模式分析数据
    private final Map<String, CacheUsagePattern> usagePatterns = new ConcurrentHashMap<>();

    // 上次优化时间记录
    private final Map<String, Long> lastOptimizationTime = new ConcurrentHashMap<>();

    // 优化间隔时间（毫秒）
    private static final long OPTIMIZATION_INTERVAL = 30 * 60 * 1000; // 30分钟

    /**
     * 缓存使用模式数据结构
     */
    private static class CacheUsagePattern {
        long accessCount = 0;
        long hitCount = 0;
        long missCount = 0;
        long evictionCount = 0;
        long lastAccessTime = System.currentTimeMillis();
        List<Double> hitRateHistory = new ArrayList<>();
        List<Long> sizeHistory = new ArrayList<>();

        public double getHitRate() {
            long total = hitCount + missCount;
            return total > 0 ? (double) hitCount / total : 0;
        }

        public void update(double currentHitRate, long currentSize) {
            hitRateHistory.add(currentHitRate);
            sizeHistory.add(currentSize);

            // 保留最近10条记录
            if (hitRateHistory.size() > 10) {
                hitRateHistory.remove(0);
            }
            if (sizeHistory.size() > 10) {
                sizeHistory.remove(0);
            }
        }

        public double getHitRateTrend() {
            if (hitRateHistory.size() < 2) return 0;

            double recent = hitRateHistory.get(hitRateHistory.size() - 1);
            double previous = hitRateHistory.get(hitRateHistory.size() - 2);
            return recent - previous;
        }
    }

    /**
     * 执行缓存性能优化
     */
    @Override
    public void optimizeCachePerformance() {
        logger.info("Starting cache performance optimization...");

        try {
            // 分析所有缓存的使用模式
            analyzeUsagePatterns();

            // 根据使用模式优化各个缓存
            optimizeIndividualCaches();

            // 执行智能缓存预热
            performIntelligentWarmup();

            // 清理低效率缓存
            cleanUpInefficientCaches();

            // 记录优化结果
            logOptimizationResults();

        } catch (Exception e) {
            logger.error("Error during cache performance optimization: {}", e.getMessage(), e);
        }

        logger.info("Cache performance optimization completed");
    }

    /**
     * 分析缓存使用模式
     */
    private void analyzeUsagePatterns() {
        List<String> cacheNames = cacheService.getCacheNames();

        for (String cacheName : cacheNames) {
            try {
                Map<String, Object> stats = cacheService.getCacheStatistics(cacheName);
                CacheUsagePattern pattern = usagePatterns.computeIfAbsent(cacheName, k -> new CacheUsagePattern());

                // 更新使用模式数据
                pattern.accessCount = (long) stats.getOrDefault("totalRequests", 0L);
                pattern.hitCount = (long) stats.getOrDefault("hits", 0L);
                pattern.missCount = (long) stats.getOrDefault("misses", 0L);
                pattern.evictionCount = (long) stats.getOrDefault("evictionCount", 0L);
                pattern.lastAccessTime = System.currentTimeMillis();

                // 更新历史数据
                double currentHitRate = (double) stats.getOrDefault("hitRate", 0.0);
                long currentSize = (long) stats.getOrDefault("size", 0L);
                pattern.update(currentHitRate, currentSize);

                logger.debug("Cache {} usage pattern analysis: hit rate={:.2f}%, trend={:.4f}",
                        cacheName, currentHitRate * 100, pattern.getHitRateTrend());

            } catch (Exception e) {
                logger.error("Error analyzing usage pattern for cache {}: {}", cacheName, e.getMessage(), e);
            }
        }
    }

    /**
     * 优化各个缓存
     */
    private void optimizeIndividualCaches() {
        for (Map.Entry<String, CacheUsagePattern> entry : usagePatterns.entrySet()) {
            String cacheName = entry.getKey();
            CacheUsagePattern pattern = entry.getValue();

            try {
                // 检查是否需要优化
                if (shouldOptimize(cacheName, pattern)) {
                    // 基于使用模式执行优化
                    optimizeCache(cacheName, pattern);
                    // 记录优化时间
                    lastOptimizationTime.put(cacheName, System.currentTimeMillis());
                }
            } catch (Exception e) {
                logger.error("Error optimizing cache {}: {}", cacheName, e.getMessage(), e);
            }
        }
    }

    /**
     * 检查是否需要优化缓存
     */
    private boolean shouldOptimize(String cacheName, CacheUsagePattern pattern) {
        // 检查优化间隔
        Long lastTime = lastOptimizationTime.get(cacheName);
        if (lastTime != null && (System.currentTimeMillis() - lastTime < OPTIMIZATION_INTERVAL)) {
            return false;
        }

        // 检查缓存健康状态
        Map<String, Object> stats = cacheService.getCacheStatistics(cacheName);
        String healthStatus = (String) stats.getOrDefault("healthStatus", "EXCELLENT");

        // 如果缓存状态为警告或严重，或者命中率趋势明显下降，需要优化
        return "WARNING".equals(healthStatus) || "CRITICAL".equals(healthStatus) ||
                pattern.getHitRateTrend() < -0.05; // 命中率下降超过5%
    }

    /**
     * 执行具体的缓存优化
     */
    private void optimizeCache(String cacheName, CacheUsagePattern pattern) {
        logger.info("Optimizing cache: {}, current hit rate: {:.2f}%, trend: {:.4f}",
                cacheName, pattern.getHitRate() * 100, pattern.getHitRateTrend());

        // 根据不同的缓存类型和使用模式执行不同的优化策略
        if (pattern.getHitRate() < 0.5) {
            // 低命中率缓存优化 - 刷新和预热
            optimizeLowHitRateCache(cacheName);
        } else if (pattern.evictionCount > 100) {
            // 高频驱逐缓存优化
            optimizeHighEvictionCache(cacheName);
        } else if (pattern.getHitRateTrend() < -0.1) {
            // 命中率快速下降的缓存
            optimizeDecliningHitRateCache(cacheName);
        }
    }

    /**
     * 优化低命中率缓存
     */
    private void optimizeLowHitRateCache(String cacheName) {
        logger.info("Optimizing low hit rate cache: {}", cacheName);

        // 清除旧缓存并重新预热
        cacheService.clearCache(cacheName);
        cacheService.warmupCache(cacheName);

        // 对于特别低效的缓存，可以考虑降低容量以减少内存使用
        // 注意：实际应用中需要根据具体业务需求调整
    }

    /**
     * 优化高频驱逐缓存
     */
    private void optimizeHighEvictionCache(String cacheName) {
        logger.info("Optimizing high eviction cache: {}", cacheName);

        // 高频驱逐通常意味着缓存容量不足
        // 在实际应用中，这里应该调整缓存配置以增加容量
        logger.info("Cache {} has high eviction rate, suggesting increasing max capacity", cacheName);

        // 执行选择性预热，只预热最常用的数据
        performTargetedWarmup(cacheName);
    }

    /**
     * 优化命中率下降的缓存
     */
    private void optimizeDecliningHitRateCache(String cacheName) {
        logger.info("Optimizing declining hit rate cache: {}", cacheName);

        // 刷新缓存以获取最新数据
        cacheService.refreshCache(cacheName);

        // 分析访问模式并调整预热策略
        analyzeAccessPatternAndAdjustWarmup(cacheName);
    }

    /**
     * 执行智能缓存预热
     */
    @Override
    public void performIntelligentWarmup() {
        logger.info("Performing intelligent cache warmup...");

        // 对重要缓存执行预热
        List<String> cacheNamesToWarmup = Arrays.asList("categories", "books", "stocks");

        for (String cacheName : cacheNamesToWarmup) {
            try {
                if (!cacheService.warmupCache(cacheName)) {
                    logger.warn("Cache {} warmup failed", cacheName);
                }
            } catch (Exception e) {
                logger.error("Error during cache {} warmup: {}", cacheName, e.getMessage(), e);
            }
        }
    }

    /**
     * 执行针对性预热
     */
    private void performTargetedWarmup(String cacheName) {
        logger.info("Performing targeted warmup for cache {}", cacheName);

        switch (cacheName) {
            case "books":
                if (bookService != null) {
                    // 只预热热门书籍
                    bookService.getHotBooks(50);
                    logger.info("Warmed up hot books cache");
                }
                break;
            case "categories":
                // 预热分类缓存
                if (categoryService != null) {
                    List<?> categories = categoryService.loadCategories();
                    logger.info("Preloading categories data: {} items", categories != null ? categories.size() : 0);
                }
                break;
            case "stocks":
                // 预热库存缓存
                if (stockService != null) {
                    stockService.getAllStocks();
                    logger.info("Preloading stocks data");
                }
                break;
        }
    }

    /**
     * 分析访问模式并调整预热策略
     */
    @Override
    public void analyzeAccessPatternAndAdjustWarmup(String cacheName) {
        // 在实际应用中，这里应该分析缓存的访问模式（如时间模式、访问频率等）
        // 并据此调整预热策略
        logger.info("Analyzing access pattern for cache {} and adjusting warmup strategy", cacheName);
    }

    /**
     * 清理低效率缓存
     */
    @Override
    public void cleanUpInefficientCaches() {
        logger.info("Starting cleanup of inefficient caches...");

        long thresholdTime = System.currentTimeMillis() - 24 * 60 * 60 * 1000; // 24小时

        for (Map.Entry<String, CacheUsagePattern> entry : usagePatterns.entrySet()) {
            String cacheName = entry.getKey();
            CacheUsagePattern pattern = entry.getValue();

            // 清理长时间未访问且效率低的缓存
            if (pattern.lastAccessTime < thresholdTime && pattern.getHitRate() < 0.3) {
                logger.info("Cleaning up inefficient cache: {}, last access time: {}, hit rate: {:.2f}%",
                        cacheName, new Date(pattern.lastAccessTime), pattern.getHitRate() * 100);

                cacheService.clearCache(cacheName);
            }
        }
    }

    /**
     * 记录优化结果
     */
    private void logOptimizationResults() {
        try {
            Map<String, Object> healthStatus = cacheService.getSystemHealthStatus();
            logger.info("Cache optimization results - overall hit rate: {:.2f}%, health status: {}",
                    (double) healthStatus.getOrDefault("overallHitRate", 0.0) * 100,
                    healthStatus.getOrDefault("overallStatus", "UNKNOWN"));

            // 输出优化建议
            List<String> suggestions = (List<String>) healthStatus.getOrDefault("optimizationSuggestions", Collections.emptyList());
            if (!suggestions.isEmpty()) {
                logger.info("Optimization suggestions:");
                for (String suggestion : suggestions) {
                    logger.info("- {}", suggestion);
                }
            }
        } catch (Exception e) {
            logger.error("Error logging optimization results: {}", e.getMessage(), e);
        }
    }

    /**
     * 获取缓存优化报告
     */
    @Override
    public Map<String, Object> getOptimizationReport() {
        Map<String, Object> report = new HashMap<>();
        report.put("timestamp", System.currentTimeMillis());
        report.put("cacheCount", usagePatterns.size());

        // 分析各缓存状态
        List<Map<String, Object>> cacheReports = new ArrayList<>();
        for (Map.Entry<String, CacheUsagePattern> entry : usagePatterns.entrySet()) {
            String cacheName = entry.getKey();
            CacheUsagePattern pattern = entry.getValue();

            Map<String, Object> cacheReport = new HashMap<>();
            cacheReport.put("cacheName", cacheName);
            cacheReport.put("hitRate", pattern.getHitRate());
            cacheReport.put("hitRateTrend", pattern.getHitRateTrend());
            cacheReport.put("lastAccessTime", pattern.lastAccessTime);
            cacheReport.put("evictionCount", pattern.evictionCount);

            // 获取当前缓存统计
            try {
                Map<String, Object> stats = cacheService.getCacheStatistics(cacheName);
                cacheReport.put("currentSize", stats.getOrDefault("size", 0L));
                cacheReport.put("maxSize", stats.getOrDefault("maxSize", 0L));
                cacheReport.put("healthStatus", stats.getOrDefault("healthStatus", "UNKNOWN"));
            } catch (Exception e) {
                logger.error("Error getting statistics for cache {}: {}", cacheName, e.getMessage(), e);
            }

            cacheReports.add(cacheReport);
        }

        report.put("cacheReports", cacheReports);

        // 计算整体统计
        double avgHitRate = cacheReports.stream()
                .mapToDouble(r -> (double) r.getOrDefault("hitRate", 0.0))
                .average()
                .orElse(0.0);

        long totalEvictions = cacheReports.stream()
                .mapToLong(r -> (long) r.getOrDefault("evictionCount", 0L))
                .sum();

        report.put("averageHitRate", avgHitRate);
        report.put("totalEvictions", totalEvictions);

        // 获取系统健康状态
        try {
            Map<String, Object> healthStatus = cacheService.getSystemHealthStatus();
            report.put("systemHealth", healthStatus);
        } catch (Exception e) {
            logger.error("Error getting system health status: {}", e.getMessage(), e);
        }

        return report;
    }

    /**
     * 执行缓存批量优化操作
     */
    @Override
    public void batchOptimizeCaches(List<String> cacheNames) {
        logger.info("Starting batch optimization for caches: {}", cacheNames);

        for (String cacheName : cacheNames) {
            try {
                Map<String, Object> stats = cacheService.getCacheStatistics(cacheName);
                double hitRate = (double) stats.getOrDefault("hitRate", 0.0);

                logger.info("Batch optimizing cache {}, current hit rate: {:.2f}%", cacheName, hitRate * 100);

                // 清除并预热缓存
                cacheService.clearCache(cacheName);
                cacheService.warmupCache(cacheName);

            } catch (Exception e) {
                logger.error("Error during batch optimization for cache {}: {}", cacheName, e.getMessage(), e);
            }
        }

        logger.info("Batch cache optimization completed, optimized {} caches", cacheNames.size());
    }

    /**
     * 获取缓存使用模式分析
     */
    @Override
    public Map<String, Object> getCacheUsagePattern(String cacheName) {
        CacheUsagePattern pattern = usagePatterns.get(cacheName);
        if (pattern == null) {
            logger.warn("No usage pattern found for cache: {}", cacheName);
            return Collections.emptyMap();
        }

        Map<String, Object> result = new HashMap<>();
        result.put("hitRate", pattern.getHitRate());
        result.put("hitRateTrend", pattern.getHitRateTrend());
        result.put("accessCount", pattern.accessCount);
        result.put("hitCount", pattern.hitCount);
        result.put("missCount", pattern.missCount);
        result.put("evictionCount", pattern.evictionCount);
        result.put("lastAccessTime", pattern.lastAccessTime);
        result.put("hitRateHistory", pattern.hitRateHistory);
        result.put("sizeHistory", pattern.sizeHistory);

        return result;
    }

    /**
     * 自动执行缓存性能优化的定时任务
     */
    @Scheduled(cron = "0 0 */1 * * *") // 每小时执行一次
    public void scheduledOptimization() {
        logger.info("Executing scheduled cache optimization task");
        optimizeCachePerformance();
    }

    /**
     * 自动执行缓存预热的定时任务
     */
    @Scheduled(cron = "0 */30 * * * *") // 每30分钟执行一次
    public void scheduledWarmup() {
        logger.info("Executing scheduled cache warmup task");
        performIntelligentWarmup();
    }
}