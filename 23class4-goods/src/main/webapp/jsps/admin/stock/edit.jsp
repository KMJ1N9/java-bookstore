<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>
<!DOCTYPE html>
<html>

<head>
    <title>编辑库存信息 - 管理员后台</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #333;
            margin-bottom: 30px;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }

        .form-group input[type="text"]:focus,
        .form-group input[type="number"]:focus,
        .form-group select:focus {
            border-color: #4CAF50;
            outline: none;
            box-shadow: 0 0 5px rgba(76, 175, 80, 0.2);
        }

        .form-group .readonly-field {
            background-color: #f5f5f5;
            cursor: not-allowed;
        }

        .book-info {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .book-info h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #333;
            font-size: 18px;
        }

        .book-info-item {
            display: flex;
            margin-bottom: 10px;
        }

        .book-info-label {
            width: 120px;
            font-weight: bold;
            color: #555;
        }

        .book-info-value {
            flex: 1;
            color: #333;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            margin-right: 10px;
            transition: background-color 0.3s ease;
        }

        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }

        .btn-primary:hover {
            background-color: #45a049;
        }

        .btn-secondary {
            background-color: #f5f5f5;
            color: #333;
            border: 1px solid #ddd;
        }

        .btn-secondary:hover {
            background-color: #e0e0e0;
        }

        .error-message {
            color: #f44336;
            margin-bottom: 15px;
            padding: 10px;
            background-color: #ffebee;
            border-radius: 4px;
            border-left: 4px solid #f44336;
        }

        .success-message {
            color: #2e7d32;
            margin-bottom: 15px;
            padding: 10px;
            background-color: #e8f5e9;
            border-radius: 4px;
            border-left: 4px solid #4CAF50;
        }

        .form-actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .form-note {
            font-size: 14px;
            color: #666;
            font-style: italic;
            margin-top: 5px;
        }
    </style>
    <script>
        // 表单验证
        function validateForm() {
            const quantity = document.getElementById('quantity').value;
            const minQuantity = document.getElementById('minQuantity').value;

            // 检查数值是否为非负数
            if (parseInt(quantity) < 0) {
                alert('库存数量不能为负数！');
                return false;
            }

            if (parseInt(minQuantity) < 0) {
                alert('最低预警值不能为负数！');
                return false;
            }

            // 确保最低预警值有意义
            if (parseInt(minQuantity) < 0) {
                alert('最低预警值必须为非负数！');
                return false;
            }

            return true;
        }
    </script>
</head>

<body>
<div class="container">
    <h1>编辑库存信息</h1>

    <!-- 错误或成功消息显示 -->
    <c:if test="${not empty errorMessage}">
        <div class="error-message">${errorMessage}</div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="success-message">${successMessage}</div>
    </c:if>

    <!-- 图书基本信息 -->
    <div class="book-info">
        <h3>图书信息</h3>
        <div class="book-info-item">
            <div class="book-info-label">图书ID：</div>
            <div class="book-info-value">${stock.bid}</div>
        </div>
        <div class="book-info-item">
            <div class="book-info-label">图书名称：</div>
            <div class="book-info-value">${stock.bname}</div>
        </div>
        <div class="book-info-item">
            <div class="book-info-label">库存ID：</div>
            <div class="book-info-value">${stock.sid}</div>
        </div>
    </div>

    <!-- 库存编辑表单 -->
    <form action="/goods/admin/stock/update/info" method="post" onsubmit="return validateForm();">
        <input type="hidden" name="sid" value="${stock.sid}"/>
        <input type="hidden" name="bid" value="${stock.bid}"/>
        <gg:token/>

        <div class="form-group">
            <label for="quantity">当前库存数量 *</label>
            <input type="number" id="quantity" name="quantity" value="${stock.quantity}" required min="0"/>
            <div class="form-note">请输入当前的库存数量，必须为非负数。</div>
        </div>

        <div class="form-group">
            <label for="minQuantity">最低预警值 *</label>
            <input type="number" id="minQuantity" name="minQuantity" value="${stock.minQuantity}" required
                   min="0"/>
            <div class="form-note">当库存数量低于此值时，系统将标记为低库存状态。</div>
        </div>

        <div class="form-group">
            <label for="status">库存状态</label>
            <select id="status" name="status">
                <option value="1" <c:if test="${stock.status eq 1}">selected="selected"</c:if>>正常</option>
                <option value="0" <c:if test="${stock.status eq 0}">selected="selected"</c:if>>低库存</option>
            </select>
            <div class="form-note">手动设置库存状态，系统也会根据库存数量自动更新此状态。</div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">保存更新</button>
            <a href="/goods/admin/stock/list" class="btn btn-secondary">取消并返回列表</a>
            <a href="/goods/admin/stock/detail/${stock.bid}" class="btn btn-secondary">查看详情</a>
        </div>
    </form>
</div>
</body>

</html>