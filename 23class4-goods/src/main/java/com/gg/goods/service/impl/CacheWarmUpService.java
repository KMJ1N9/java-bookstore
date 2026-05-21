package com.gg.goods.service.impl;

import com.gg.goods.entity.Book;
import com.gg.goods.entity.Category;
import com.gg.goods.service.BookService;
import com.gg.goods.service.CacheService;
import com.gg.goods.service.CategoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 缓存预热服务
 */
@Service
public class CacheWarmUpService implements CommandLineRunner {
    private static final Logger logger = LoggerFactory.getLogger(CacheWarmUpService.class);

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private BookService bookService;

    @Autowired
    private CacheService cacheService;

    // 预热配置
    private boolean warmupEnabled = true;
    private boolean warmupCategories = true;
    private boolean warmupBooks = true;
    private int warmupPriority = 5;
    private int warmupTimeout = 60;
    private int warmupThreads = 2;

    @Override
    public void run(String... args) throws Exception {
        if (warmupEnabled) {
            logger.info("开始执行缓存预热任务");
            long startTime = System.currentTimeMillis();

            // 在新线程中执行预热，避免阻塞应用启动
            ExecutorService executorService = Executors.newFixedThreadPool(warmupThreads);

            // 预热分类缓存
            if (warmupCategories) {
                executorService.submit(this::warmupCategoryCache);
            }

            // 预热图书缓存
            if (warmupBooks) {
                executorService.submit(this::warmupBookCache);
            }

            executorService.shutdown();
            long endTime = System.currentTimeMillis();
            logger.info("缓存预热任务提交完成，耗时: {}ms", endTime - startTime);
        } else {
            logger.info("缓存预热功能已禁用");
        }
    }

    /**
     * 预热分类缓存
     */
    private void warmupCategoryCache() {
        long cacheWarmupStartTime = System.currentTimeMillis();
        logger.info("开始预热分类缓存...");

        try {
            // 预热根分类（一级分类）
            categoryService.getFirstLevelCategories();

            // 预热热门分类（假设前10个分类为热门）
            List<Category> firstLevelCategories = categoryService.getFirstLevelCategories();
            for (Category category : firstLevelCategories) {
                try {
                    // 预热每个一级分类下的二级分类
                    categoryService.getSecondLevelCategories(category.getCid());
                    // 预热单个分类信息
                    categoryService.getCategoryByCid(category.getCid());
                } catch (Exception e) {
                    logger.warn("预热分类ID {} 时出错: {}", category.getCid(), e.getMessage());
                }
            }
        } catch (Exception e) {
            logger.error("预热分类缓存时出错: {}", e.getMessage(), e);
        } finally {
            long cacheWarmupEndTime = System.currentTimeMillis();
            logger.info("分类缓存预热完成，耗时: {}ms", cacheWarmupEndTime - cacheWarmupStartTime);
        }
    }

    /**
     * 预热图书缓存
     */
    private void warmupBookCache() {
        long cacheWarmupStartTime = System.currentTimeMillis();
        logger.info("开始预热图书缓存...");

        try {
            // 预热热门图书
            List<Book> hotBooks = bookService.getHotBooks(8);
            logger.info("预热热门图书 {} 本", hotBooks.size());

            // 预热最新图书
            List<Book> newestBooks = bookService.getNewestBooks(8);
            logger.info("预热最新图书 {} 本", newestBooks.size());

            // 预热各分类图书（包括一级和二级分类）
            List<Category> allCategories = categoryService.getAllCategories();
            for (Category category : allCategories) {
                try {
                    String cid = category.getCid();
                    List<Book> booksByCid = bookService.getBooksByCid(cid);
                    logger.info("预热分类 {} (名称: {}) 的图书 {} 本", cid, category.getCname(), booksByCid.size());
                } catch (Exception e) {
                    logger.warn("预热分类ID {} 的图书时出错: {}", category.getCid(), e.getMessage());
                }
            }
        } catch (Exception e) {
            logger.error("预热图书缓存时出错: {}", e.getMessage(), e);
        } finally {
            long cacheWarmupEndTime = System.currentTimeMillis();
            logger.info("图书缓存预热完成，耗时: {}ms", cacheWarmupEndTime - cacheWarmupStartTime);
        }
    }
}

