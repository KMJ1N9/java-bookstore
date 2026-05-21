<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>操作结果 - 库存管理系统</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            color: #333;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h1 {
            color: #4CAF50;
            margin-bottom: 20px;
        }

        .message {
            font-size: 18px;
            margin: 30px 0;
            padding: 20px;
            background-color: #f0f8ff;
            border-left: 4px solid #4CAF50;
            text-align: center;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        .btn:hover {
            background-color: #45a049;
        }

        .btn-secondary {
            background-color: #777;
        }

        .btn-secondary:hover {
            background-color: #666;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>操作结果</h1>
    <div class="message">
        ${message}
    </div>
    <div>
        <a href="/goods/admin/stock/list" class="btn">返回库存列表</a>
    </div>
</div>
</body>
</html>
