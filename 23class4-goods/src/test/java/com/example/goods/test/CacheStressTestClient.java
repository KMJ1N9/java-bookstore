package com.example.goods.test;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

public class CacheStressTestClient {

    private static final String API_URL = "http://localhost:8080/goods/api/cache/performance/test";
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");

    public static void main(String[] args) {
        // Test configurations: different concurrency levels and operations per thread
        int[][] testConfigurations = {
                {10, 100},  // 10 threads, 100 operations per thread
                {50, 500},  // 50 threads, 500 operations per thread
                {100, 1000} // 100 threads, 1000 operations per thread
        };

        System.out.println("Starting cache stress test...");
        System.out.println("Current time: " + LocalDateTime.now().format(formatter));
        System.out.println("==========================================");

        // Execute tests with different configurations
        for (int[] config : testConfigurations) {
            int threadCount = config[0];
            int operationsPerThread = config[1];

            System.out.println("\nExecuting test configuration: threadCount=" + threadCount + ", operationsPerThread=" + operationsPerThread);
            System.out.println("Test start time: " + LocalDateTime.now().format(formatter));

            try {
                // Run multi-threaded stress test
                runMultiThreadTest(threadCount, operationsPerThread);
            } catch (Exception e) {
                System.err.println("Test execution failed: " + e.getMessage());
                e.printStackTrace();
            }

            System.out.println("Test end time: " + LocalDateTime.now().format(formatter));
            System.out.println("------------------------------------------");

            // Short break between tests
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }

        System.out.println("\nAll stress tests completed!");
        System.out.println("End time: " + LocalDateTime.now().format(formatter));
    }

    /**
     * Run multi-threaded stress test
     */
    private static void runMultiThreadTest(int threadCount, int operationsPerThread) throws Exception {
        ExecutorService executor = Executors.newFixedThreadPool(threadCount);
        CountDownLatch latch = new CountDownLatch(threadCount);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failureCount = new AtomicInteger(0);
        List<Long> responseTimes = new ArrayList<>();

        long startTime = System.currentTimeMillis();

        // Create and start test threads
        for (int i = 0; i < threadCount; i++) {
            final int threadId = i;
            executor.submit(() -> {
                try {
                    for (int j = 0; j < operationsPerThread; j++) {
                        long requestStartTime = System.currentTimeMillis();
                        try {
                            String response = sendPostRequest(API_URL,
                                    "cacheName=categories&threadCount=1&operationsPerThread=1");
                            successCount.incrementAndGet();
                            long responseTime = System.currentTimeMillis() - requestStartTime;
                            synchronized (responseTimes) {
                                responseTimes.add(responseTime);
                            }

                            // Output progress every 100 requests
                            if (j % 100 == 0) {
                                System.out.println("Thread[" + threadId + "] completed request: " + j + "/" + operationsPerThread);
                            }
                        } catch (Exception e) {
                            failureCount.incrementAndGet();
                            System.err.println("Thread[" + threadId + "] request failed: " + e.getMessage());
                        }
                    }
                } finally {
                    latch.countDown();
                }
            });
        }

        // Wait for all threads to complete
        latch.await();
        long endTime = System.currentTimeMillis();

        // Calculate and output test results
        long totalTime = endTime - startTime;
        int totalRequests = threadCount * operationsPerThread;
        double throughput = (double) totalRequests / (totalTime / 1000.0);

        // Calculate average response time
        double avgResponseTime = responseTimes.stream()
                .mapToLong(Long::valueOf)
                .average()
                .orElse(0);

        // Calculate max response time
        long maxResponseTime = responseTimes.stream()
                .mapToLong(Long::valueOf)
                .max()
                .orElse(0);

        // Calculate min response time
        long minResponseTime = responseTimes.stream()
                .mapToLong(Long::valueOf)
                .min()
                .orElse(0);

        System.out.println("\n===== Test Results Statistics =====");
        System.out.println("Total requests: " + totalRequests);
        System.out.println("Successful requests: " + successCount.get());
        System.out.println("Failed requests: " + failureCount.get());
        System.out.println("Total time: " + totalTime + " ms");
        System.out.println("Throughput: " + String.format("%.2f", throughput) + " requests/second");
        System.out.println("Average response time: " + String.format("%.2f", avgResponseTime) + " ms");
        System.out.println("Max response time: " + maxResponseTime + " ms");
        System.out.println("Min response time: " + minResponseTime + " ms");

        executor.shutdown();
    }

    /**
     * Send POST request to specified URL
     */
    private static String sendPostRequest(String url, String params) throws Exception {
        URL obj = new URL(url);
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();

        // Set request method and headers
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        con.setRequestProperty("Accept", "application/json");
        con.setDoOutput(true);

        // Send request body
        try (DataOutputStream wr = new DataOutputStream(con.getOutputStream())) {
            wr.writeBytes(params);
            wr.flush();
        }

        // Read response
        int responseCode = con.getResponseCode();
        if (responseCode != 200) {
            throw new Exception("Request failed, response code: " + responseCode);
        }

        StringBuilder response = new StringBuilder();
        try (BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"))) {
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
        }

        con.disconnect();
        return response.toString();
    }
}