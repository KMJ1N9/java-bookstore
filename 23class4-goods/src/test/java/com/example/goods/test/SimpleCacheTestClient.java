package com.example.goods.test;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class SimpleCacheTestClient {

    public static void main(String[] args) {
        try {
            // 创建URL对象，注意路径要包含context-path
            URL url = new URL("http://localhost:8080/goods/api/cache/performance/test");

            // 打开连接
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            // 设置请求方法为POST
            conn.setRequestMethod("POST");

            // 设置请求头
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setRequestProperty("Accept", "application/json");

            // 允许输入输出
            conn.setDoOutput(true);
            conn.setDoInput(true);

            // 构建请求参数
            String urlParameters = "cacheName=categories&threadCount=10&operationsPerThread=100";

            // 发送请求
            try (DataOutputStream wr = new DataOutputStream(conn.getOutputStream())) {
                wr.writeBytes(urlParameters);
                wr.flush();
            }

            // 获取响应码
            int responseCode = conn.getResponseCode();
            System.out.println("响应码: " + responseCode);

            // 获取响应头
            System.out.println("\n响应头:");
            conn.getHeaderFields().forEach((key, values) -> {
                if (key != null) {
                    System.out.println(key + ": " + values);
                }
            });

            // 获取响应体
            System.out.println("\n响应体:");
            try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                String inputLine;
                StringBuilder response = new StringBuilder();

                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }

                // 检查响应是否为HTML
                String responseStr = response.toString();
                boolean isHtml = responseStr.toLowerCase().contains("<!doctype html>") ||
                        responseStr.toLowerCase().contains("<html") ||
                        responseStr.toLowerCase().contains("<head") ||
                        responseStr.toLowerCase().contains("<body");

                System.out.println(responseStr);
                System.out.println("\n是否为HTML响应: " + isHtml);
            }

            conn.disconnect();

        } catch (Exception e) {
            System.err.println("测试时出错: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
