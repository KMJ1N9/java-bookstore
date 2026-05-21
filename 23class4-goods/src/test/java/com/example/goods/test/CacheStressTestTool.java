package com.example.goods.test;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 缓存压力测试工具类
 * 用于模拟高并发场景下的缓存访问
 */
public class CacheStressTestTool {

    private static final int CONCURRENCY_LEVEL = 100;  // 并发线程数
    private static final int REQUEST_PER_THREAD = 100; // 每个线程请求次数
    private static final String BASE_URL = "http://localhost:8080/goods/api/cache/performance";
    private static final String CACHE_NAME = "categories";

    public static void main(String[] args) throws InterruptedException {
        System.out.println("开始执行缓存压力测试...");
        System.out.println("并发级别: " + CONCURRENCY_LEVEL + "线程");
        System.out.println("每个线程请求次数: " + REQUEST_PER_THREAD);
        System.out.println("总请求数: " + (CONCURRENCY_LEVEL * REQUEST_PER_THREAD));
        System.out.println("缓存名称: " + CACHE_NAME);

        long startTime = System.currentTimeMillis();

        ExecutorService executor = Executors.newFixedThreadPool(CONCURRENCY_LEVEL);
        CountDownLatch latch = new CountDownLatch(CONCURRENCY_LEVEL);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failCount = new AtomicInteger(0);

        for (int i = 0; i < CONCURRENCY_LEVEL; i++) {
            executor.submit(() -> {
                try {
                    RestTemplate restTemplate = new RestTemplate();
                    HttpHeaders headers = new HttpHeaders();
                    headers.setContentType(MediaType.APPLICATION_JSON);
                    HttpEntity<String> entity = new HttpEntity<>("", headers);

                    for (int j = 0; j < REQUEST_PER_THREAD; j++) {
                        try {
                            // 调用缓存性能测试API
                            String url = BASE_URL + "/test?cacheName=" + CACHE_NAME;
                            String response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class).getBody();
                            if (response != null && !response.isEmpty()) {
                                successCount.incrementAndGet();
                            } else {
                                failCount.incrementAndGet();
                            }
                        } catch (Exception e) {
                            failCount.incrementAndGet();
                            System.err.println("请求失败: " + e.getMessage());
                        }
                    }
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await();
        long endTime = System.currentTimeMillis();
        long totalTime = endTime - startTime;

        System.out.println("\n===== 压力测试结果 =====");
        System.out.println("总耗时: " + totalTime + "ms");
        System.out.println("成功请求数: " + successCount.get());
        System.out.println("失败请求数: " + failCount.get());
        System.out.println("吞吐量: " + (successCount.get() * 1000.0 / totalTime) + " 请求/秒");
        System.out.println("平均响应时间: " + (totalTime * 1.0 / successCount.get()) + "ms");

        executor.shutdown();
        System.out.println("压力测试完成！");
    }
}