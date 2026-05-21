package com.gg.goods.config;

import com.gg.goods.service.BookService;
import com.gg.goods.service.CategoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * 缓存预热组件
 * 在应用启动时预加载常用数据到缓存中，避免冷启动问题
 */
@Component
@Order(1)
public class CacheWarmer implements ApplicationRunner {

    private static final Logger logger = LoggerFactory.getLogger(CacheWarmer.class);

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private BookService bookService;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        logger.info("开始执行缓存预热...");

        try {
            // 预热分类缓存
            logger.info("预热分类缓存...");
            categoryService.loadCategories();
            categoryService.getFirstLevelCategories();

            // 预热热门图书和最新图书缓存
            logger.info("预热热门图书和最新图书缓存...");
            int warmupLimit = 10; // 预加载前10条记录
            bookService.getHotBooks(warmupLimit);
            bookService.getNewestBooks(warmupLimit);

            // 预热各分类下的图书缓存（可选，根据实际业务需求）
            // 这里可以根据实际需要预加载特定分类的图书

            logger.info("缓存预热完成！");
        } catch (Exception e) {
            logger.error("缓存预热过程中发生错误: {}", e.getMessage(), e);
        }
    }
}