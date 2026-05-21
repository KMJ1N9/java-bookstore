<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <title>库存详情 - 管理员后台</title>
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

        .info-card {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .info-item {
            display: flex;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .info-item:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }

        .info-label {
            width: 150px;
            font-weight: bold;
            color: #555;
        }

        .info-value {
            flex: 1;
            color: #333;
        }

        .status-normal {
            color: #4CAF50;
            font-weight: bold;
        }

        .status-low {
            color: #f44336;
            font-weight: bold;
        }

        .warning-status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 4px;
            font-weight: bold;
            font-size: 14px;
        }

        .warning-normal {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .warning-warning {
            background-color: #fff3e0;
            color: #ef6c00;
        }

        .warning-danger {
            background-color: #ffebee;
            color: #c62828;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            margin-right: 10px;
            margin-top: 20px;
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

        .stock-graph {
            margin: 20px 0;
            text-align: center;
        }

        .stock-bar {
            height: 30px;
            background-color: #4CAF50;
            border-radius: 4px;
            position: relative;
            transition: width 0.5s ease;
        }

        .stock-bar.low {
            background-color: #f44336;
        }

        .stock-bar.warning {
            background-color: #ff9800;
        }

        .stock-bar-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-weight: bold;
        }

        .stock-percentage {
            margin-top: 10px;
            color: #666;
            font-size: 14px;
        }

        .quick-actions {
            margin-top: 30px;
            padding: 15px;
            background-color: #f0f0f0;
            border-radius: 6px;
        }

        .quick-actions h3 {
            margin-top: 0;
            color: #333;
        }
    </style>
    <script>
        // 快速更新库存数量
        function updateStockQuantity(bid) {
            const quantity = prompt('请输入新的库存数量（必须为非负数）：');

            if (quantity === null) return;

            const numQuantity = parseInt(quantity);
            if (isNaN(numQuantity) || numQuantity < 0) {
                alert('请输入有效的非负数！');
                return;
            }

            if (confirm('确定要将库存数量更新为 ' + numQuantity + ' 吗？')) {
                window.location.href = '/goods/admin/stock/update/quantity?bid=' + bid + '&quantity=' + numQuantity;
            }
        }
    </script>
</head>

<body>
<div class="container">
    <h1>库存详情</h1>

    <!-- 库存信息卡片 -->
    <div class="info-card">
        <div class="info-item">
            <div class="info-label">图书名称：</div>
            <div class="info-value">${stockVO.bname}</div>
        </div>
        <div class="info-item">
            <div class="info-label">图书ID：</div>
            <div class="info-value">${stockVO.bid}</div>
        </div>
        <div class="info-item">
            <div class="info-label">当前库存：</div>
            <div class="info-value">${stockVO.quantity}</div>
        </div>
        <div class="info-item">
            <div class="info-label">最低预警值：</div>
            <div class="info-value">${stockVO.minQuantity}</div>
        </div>
        <div class="info-item">
            <div class="info-label">库存状态：</div>
            <div class="info-value">
                            <span class="<c:choose>
                        <c:when test=" ${stockVO.status eq 1}">status-normal</c:when>
                                <c:otherwise>status-low</c:otherwise>
                                </c:choose>">
                                ${stockVO.statusDesc}
                            </span>
            </div>
        </div>
        <div class="info-item">
            <div class="info-label">预警状态：</div>
            <div class="info-value">
                            <span class="warning-status <c:choose>
                        <c:when test=" ${stockVO.warningStatus eq '库存充足' }">warning-normal</c:when>
                                <c:when test="${stockVO.warningStatus eq '即将不足'}">warning-warning</c:when>
                                <c:otherwise>warning-danger</c:otherwise>
                                </c:choose>">
                                ${stockVO.warningStatus}
                            </span>
            </div>
        </div>
        <div class="info-item">
            <div class="info-label">最后更新时间：</div>
            <div class="info-value">${stockVO.updateTime}</div>
        </div>
        <div class="info-item">
            <div class="info-label">库存ID：</div>
            <div class="info-value">${stockVO.sid}</div>
        </div>
    </div>

    <!-- 库存可视化图表 -->
    <div class="stock-graph">
        <h3>库存状态可视化</h3>
        <div
                style="width: 100%; height: 50px; background-color: #e0e0e0; border-radius: 4px; overflow: hidden;">
            <c:set var="percentage"
                   value="${(stockVO.quantity * 1.0 / stockVO.minQuantity * 1.00) gt 100 ? 100 : (stockVO.quantity * 1.0 / stockVO.minQuantity * 100)}">
            </c:set>
            <div class="stock-bar <c:choose>
                    <c:when test=" ${stockVO.quantity < stockVO.minQuantity}">low</c:when>
                            <c:when test="${stockVO.quantity < stockVO.minQuantity * 2}">warning</c:when>
                            <c:otherwise></c:otherwise>
                            </c:choose>" style="width: ${percentage}%">
                <div class="stock-bar-text">${stockVO.quantity} / ${stockVO.minQuantity}</div>
            </div>
        </div>
        <div class="stock-percentage">
            库存占最低预警值的 ${Math.round(percentage * 1.0)}%
            <c:if test="${percentage lt 100}">
                （<span class="status-low">低于预警值</span>）
            </c:if>
            <c:if test="${percentage ge 100 and percentage lt 200}">
                （<span style="color: #ff9800; font-weight: bold;">接近预警值</span>）
            </c:if>
            <c:if test="${percentage ge 200}">
                （<span class="status-normal">库存充足</span>）
            </c:if>
        </div>
    </div>

    <!-- 快速操作区域 -->
    <div class="quick-actions">
        <h3>快速操作</h3>
        <a href="/goods/admin/stock/edit/${stockVO.bid}" class="btn btn-primary">编辑库存信息</a>
        <button onclick="updateStockQuantity('${stockVO.bid}')" class="btn btn-warning">快速更新数量</button>
        <a href="/goods/admin/stock/list" class="btn btn-secondary">返回列表</a>
    </div>
</div>
</body>

</html>