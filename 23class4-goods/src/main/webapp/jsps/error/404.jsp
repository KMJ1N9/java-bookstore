<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>页面不存在 - 404</title>
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

        .error-code {
            font-size: 80px;
            font-weight: bold;
            color: #dc3545;
            margin-bottom: 20px;
        }

        .error-message {
            font-size: 20px;
            color: #333;
            margin-bottom: 30px;
        }

        .back-button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .back-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-code">404</div>
    <div class="error-message">您访问的页面不存在或已被删除</div>
    <a href="javascript:history.back();" class="back-button">返回上一页</a>
</div>
</body>
</html>