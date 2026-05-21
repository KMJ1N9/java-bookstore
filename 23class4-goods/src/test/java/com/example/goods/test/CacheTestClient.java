package com.example.goods.test;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class CacheTestClient {

    public static void main(String[] args) {
        try {
            // Test /test endpoint
            System.out.println("=== Testing /test endpoint ===");
            testCachePerformance();

            // Test /health endpoint
            System.out.println("\n=== Testing /health endpoint ===");
            testSystemHealth();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void testCachePerformance() throws Exception {
        URL url = new URL("http://localhost:8080/goods/api/cache/performance/test");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);

        // Prepare request body
        String requestBody = "cacheName=categories&threadCount=10&operationsPerThread=100";

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        // Read response
        int responseCode = conn.getResponseCode();
        System.out.println("Response Code: " + responseCode);

        System.out.println("\nResponse Headers:");
        conn.getHeaderFields().forEach((key, values) -> {
            if (key != null) {
                System.out.println(key + ": " + values);
            }
        });

        System.out.println("\nResponse Body:");
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "utf-8"))) {
            StringBuilder response = new StringBuilder();
            String responseLine = null;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
            System.out.println(response.toString());

            // Check if it's HTML or JSON
            String responseStr = response.toString();
            if (responseStr.startsWith("<!DOCTYPE") || responseStr.contains("<html")) {
                System.out.println("\nWARNING: Received HTML instead of JSON. Controller might not be registered properly.");
            }
        }

        conn.disconnect();
    }

    private static void testSystemHealth() throws Exception {
        URL url = new URL("http://localhost:8080/goods/api/cache/performance/health");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        System.out.println("Response Code: " + responseCode);

        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "utf-8"))) {
            StringBuilder response = new StringBuilder();
            String responseLine = null;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
            System.out.println("\nResponse Body:");
            System.out.println(response.toString());
        }

        conn.disconnect();
    }
}