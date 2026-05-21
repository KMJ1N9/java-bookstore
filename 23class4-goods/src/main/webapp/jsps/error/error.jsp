<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>系统错误 - 500</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background-color: #f8f9fa;
        }

        .error-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .error-icon {
            font-size: 60px;
            color: #dc3545;
            margin-bottom: 20px;
        }

        .error-message {
            font-size: 18px;
            color: #333;
            margin-bottom: 20px;
        }

        .error-code {
            font-size: 14px;
            color: #666;
            margin-bottom: 30px;
        }

        .action-buttons {
            margin-top: 20px;
        }

        .action-button {
            display: inline-block;
            padding: 10px 20px;
            margin: 0 10px;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .retry-button {
            background-color: #28a745;
            color: white;
        }

        .retry-button:hover {
            background-color: #218838;
        }

        .home-button {
            background-color: #007bff;
            color: white;
        }

        .home-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-icon">⚠</div>
    <div class="error-message">
        <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "系统发生错误，请稍后重试" %>
    </div>
    <div class="error-code">
        错误代码: <%= request.getAttribute("errorCode") != null ? request.getAttribute("errorCode") : "500" %>
    </div>
    <div class="action-buttons">
        <a href="javascript:location.reload();" class="action-button retry-button">重试</a>
        <a href="/goods" class="action-button home-button">返回首页</a>
    </div>
</div>
</body>
</html>