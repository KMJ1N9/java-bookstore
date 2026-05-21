package com.gg.goods.config;

import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

/**
 * 缓存配置类
 * 配置Caffeine缓存实现
 */
@Configuration
@EnableCaching  // 开启缓存支持
public class CacheConfig {

    // 分类缓存配置
    @Value("${cache.categories.max-size:200}")
    private int categoriesMaxSize;
    @Value("${cache.categories.expire-time:7200}")
    private int categoriesExpireTime;

    // 图书缓存配置
    @Value("${cache.books.max-size:2000}")
    private int booksMaxSize;
    @Value("${cache.books.expire-time:1800}")
    private int booksExpireTime;

    // 库存缓存配置
    @Value("${cache.stocks.max-size:3000}")
    private int stocksMaxSize;
    @Value("${cache.stocks.expire-time:180}")
    private int stocksExpireTime;

    // 用户缓存配置
    @Value("${cache.users.max-size:1500}")
    private int usersMaxSize;
    @Value("${cache.users.expire-time:1800}")
    private int usersExpireTime;

    // 订单缓存配置
    @Value("${cache.orders.max-size:6000}")
    private int ordersMaxSize;
    @Value("${cache.orders.expire-time:600}")
    private int ordersExpireTime;

    // 页面缓存配置
    @Value("${cache.pages.max-size:1000}")
    private int pagesMaxSize;
    @Value("${cache.pages.expire-time:900}")
    private int pagesExpireTime;

    /**
     * 配置Caffeine缓存管理器
     *
     * @return 缓存管理器
     */
    @Bean
    public CacheManager cacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager(
                "categories", "books", "stocks", "users", "orders", "pages",
                "orderById", "ordersByUid", "orderItemsByOid", "allOrders",
                "cacheNames", "dashboard", "stock", "stockList", "user", "userCheck"
        );

        // 允许空值
        cacheManager.setAllowNullValues(false);

        // 设置默认缓存配置
        Caffeine<Object, Object> defaultCaffeine = Caffeine.newBuilder()
                .maximumSize(1000)
                .expireAfterWrite(300, TimeUnit.SECONDS)
                .initialCapacity(100)
                .recordStats();
        cacheManager.setCaffeine(defaultCaffeine);

        // 注册各个缓存并配置特定的参数
        cacheManager.registerCustomCache("categories",
                Caffeine.newBuilder()
                        .maximumWeight(categoriesMaxSize)
                        .expireAfterWrite(categoriesExpireTime, TimeUnit.SECONDS)
                        .initialCapacity(100)
                        .recordStats()
                        // 添加权重配置，优先保留常用分类
                        .weigher((key, value) -> key.toString().equals("all") ? 2 : 1)
                        .build());

        cacheManager.registerCustomCache("books",
                Caffeine.newBuilder()
                        .maximumSize(booksMaxSize)
                        .expireAfterWrite(booksExpireTime, TimeUnit.SECONDS)
                        .initialCapacity(500)
                        .recordStats()
                        // 图书信息的驱逐策略优化
                        .build());

        cacheManager.registerCustomCache("stocks",
                Caffeine.newBuilder()
                        .maximumSize(stocksMaxSize)
                        .expireAfterWrite(stocksExpireTime, TimeUnit.SECONDS)
                        .initialCapacity(1000)
                        .recordStats()
                        // 库存信息使用更激进的过期策略
                        .expireAfterAccess(stocksExpireTime / 2, TimeUnit.SECONDS)
                        .build());

        cacheManager.registerCustomCache("users",
                Caffeine.newBuilder()
                        .maximumSize(usersMaxSize)
                        .expireAfterWrite(usersExpireTime, TimeUnit.SECONDS)
                        .initialCapacity(500)
                        .recordStats()
                        .build());

        cacheManager.registerCustomCache("orders",
                Caffeine.newBuilder()
                        .maximumSize(ordersMaxSize)
                        .expireAfterWrite(ordersExpireTime, TimeUnit.SECONDS)
                        .initialCapacity(2000)
                        .recordStats()
                        // 订单信息使用访问后过期，提高热点订单的可用性
                        .expireAfterAccess(ordersExpireTime / 2, TimeUnit.SECONDS)
                        .build());

        cacheManager.registerCustomCache("pages",
                Caffeine.newBuilder()
                        .maximumWeight(pagesMaxSize)
                        .expireAfterWrite(pagesExpireTime, TimeUnit.SECONDS)
                        .initialCapacity(300)
                        .recordStats()
                        // 页面缓存添加权重，首页等重要页面权重更高
                        .weigher((key, value) -> key.toString().equals("index") ? 3 :
                                key.toString().contains("category-list") ? 2 : 1)
                        .build());

        return cacheManager;
    }
}