<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <title>库存管理列表 - 管理员后台</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }

        .container {
            max-width: 1200px;
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

        .controls {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-bar {
            flex: 1;
            min-width: 300px;
            margin-right: 20px;
            margin-bottom: 10px;
        }

        .search-bar input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }

        .search-bar input:focus {
            border-color: #4CAF50;
            outline: none;
            box-shadow: 0 0 5px rgba(76, 175, 80, 0.2);
        }

        .filter-section {
            display: flex;
            gap: 15px;
            margin-bottom: 10px;
        }

        .filter-section select {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            background-color: #fff;
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
            transition: background-color 0.3s ease;
            margin-left: 5px;
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

        .btn-warning {
            background-color: #ff9800;
            color: white;
        }

        .btn-warning:hover {
            background-color: #e68a00;
        }

        .btn-danger {
            background-color: #f44336;
            color: white;
        }

        .btn-danger:hover {
            background-color: #da190b;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th,
        td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
            font-weight: bold;
            color: #333;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .status-normal {
            color: #4CAF50;
            font-weight: bold;
        }

        .status-low {
            color: #f44336;
            font-weight: bold;
        }

        .status-pill {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }

        .status-pill.normal {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .status-pill.low {
            background-color: #ffebee;
            color: #c62828;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .pagination a {
            padding: 8px 16px;
            margin: 0 4px;
            border: 1px solid #ddd;
            text-decoration: none;
            color: #333;
            border-radius: 4px;
        }

        .pagination a.active {
            background-color: #4CAF50;
            color: white;
            border: 1px solid #4CAF50;
        }

        .pagination a:hover:not(.active) {
            background-color: #ddd;
        }

        .no-data {
            text-align: center;
            padding: 50px;
            color: #999;
            font-size: 18px;
        }

        .stock-progress {
            width: 100px;
            height: 8px;
            background-color: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
            display: inline-block;
            vertical-align: middle;
            margin-right: 8px;
        }

        .stock-progress-bar {
            height: 100%;
            background-color: #4CAF50;
            transition: width 0.5s ease;
        }

        .stock-progress-bar.low {
            background-color: #f44336;
        }

        .stock-progress-bar.warning {
            background-color: #ff9800;
        }

        .status-section {
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .status-section h3 {
            margin: 0;
            color: #333;
        }

        .checkbox-select {
            margin-right: 10px;
        }

        .select-all-section {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .select-all-section label {
            margin-left: 5px;
            font-weight: bold;
            color: #333;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }

        .alert-success {
            background-color: #e8f5e9;
            color: #2e7d32;
            border-left: 4px solid #4CAF50;
        }

        .alert-danger {
            background-color: #ffebee;
            color: #c62828;
            border-left: 4px solid #f44336;
        }

        .stock-percentage {
            font-size: 12px;
            color: #666;
        }
    </style>
    <script>
        // 全选/取消全选功能
        function toggleSelectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('.checkbox-select');

            checkboxes.forEach(checkbox => {
                checkbox.checked = selectAll.checked;
            });
        }

        // 批量更新状态功能
        function batchUpdateStatus() {
            const checkboxes = document.querySelectorAll('.checkbox-select:checked');
            const selectedCount = checkboxes.length;

            if (selectedCount === 0) {
                alert('请至少选择一项记录！');
                return;
            }

            const status = prompt('请输入要设置的状态值（0表示低库存，1表示正常）：');

            if (status === null || (status !== '0' && status !== '1')) {
                alert('请输入有效的状态值（0或1）！');
                return;
            }

            if (confirm(`确定要将选中的 ${selectedCount} 条记录状态更新为 ${status == '1' ? '正常' : '低库存'} 吗？`)) {
                // 构建表单提交
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '/goods/admin/stock/batchUpdateStockStatus';

                // 添加选中的ID
                checkboxes.forEach(checkbox => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'sids';
                    input.value = checkbox.value;
                    form.appendChild(input);
                });

                // 添加状态值
                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'status';
                statusInput.value = status;
                form.appendChild(statusInput);

                // 提交表单
                document.body.appendChild(form);
                form.submit();
            }
        }

        // 处理低库存筛选
        function applyFilter() {
            const filter = document.getElementById('stockFilter').value;
            if (filter === 'low') {
                window.location.href = '/goods/admin/stock/lowStockList';
            } else {
                window.location.href = '/goods/admin/stock/list';
            }
        }

        // 搜索功能
        function searchStock() {
            const keyword = document.getElementById('searchKeyword').value.trim();
            if (keyword) {
                window.location.href = '/goods/admin/stock/searchStock?keyword=' + encodeURIComponent(keyword);
            } else {
                window.location.href = '/goods/admin/stock/list';
            }
        }

        // 回车键搜索
        function handleKeyPress(event) {
            if (event.key === 'Enter') {
                searchStock();
            }
        }
    </script>
</head>

<body>
<div class="container">
    <h1>库存管理列表</h1>

    <!-- 消息提示区域 -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">${errorMessage}</div>
    </c:if>
    <!-- 控制区域 -->
    <div class="controls">
        <div class="search-bar">
            <input type="text" id="searchKeyword" placeholder="请输入图书ID或名称进行搜索..."
                   onkeypress="handleKeyPress(event)" value="${keyword}"/>
        </div>
        <div class="filter-section">
            <select id="stockFilter" onchange="applyFilter()">
                <option value="all" <c:if test="${empty filter || filter eq 'all'}">selected="selected"
                </c:if>>全部库存
                </option>
                <option value="low" <c:if test="${filter eq 'low'}">selected="selected"</c:if>>低库存预警
                </option>
                <option value="normal" <c:if test="${filter eq 'normal'}">selected="selected"</c:if>>正常库存
                </option>
            </select>
            <button type="button" onclick="searchStock()" class="btn btn-primary">搜索</button>
            <a href="/goods/admin/stock/list" class="btn btn-secondary">重置</a>
            <a href="/goods/admin/stock/report" class="btn btn-warning">库存报表</a>
            <a href="/goods/admin/index" class="btn btn-success" style="margin-left: 10px;">返回首页</a>
        </div>
    </div>

    <!-- 批量操作区域 -->
    <div class="status-section">
        <div class="select-all-section">
            <input type="checkbox" id="selectAll" onclick="toggleSelectAll()"/>
            <label for="selectAll">全选（${pageInfo.total} 条记录）</label>
        </div>
        <button type="button" onclick="batchUpdateStatus()" class="btn btn-warning">批量更新状态</button>
        <a href="/goods/admin/stock/lowStockList" class="btn btn-danger">查看低库存列表</a>
    </div>

    <!-- 库存列表表格 -->
    <div style="overflow-x: auto;">
        <table>
            <thead>
            <tr>
                <th>选择</th>
                <th>库存ID</th>
                <th>图书ID</th>
                <th>图书名称</th>
                <th>当前库存</th>
                <th>最低预警值</th>
                <th>库存状态</th>
                <th>状态可视化</th>
                <th>最后更新时间</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty stockList || not empty searchResults}">
                    <c:forEach items="${not empty searchResult ? searchResult : stockList}"
                               var="stock">
                        <tr>
                            <td>
                                <input type="checkbox" class="checkbox-select" value="${stock.sid}"/>
                            </td>
                            <td>${stock.sid}</td>
                            <td>${stock.bid}</td>
                            <td>${stock.bname}</td>
                            <td>${stock.quantity}</td>
                            <td>${stock.minQuantity}</td>
                            <td>
                                                <span class="status-pill <c:choose>
                                            <c:when test=" ${stock.status eq 1}">normal
                                </c:when>
                                <c:otherwise>low</c:otherwise>
                            </c:choose>">
                                                        ${stock.statusDesc}
                                                </span>
                            </td>
                            <td>
                                <c:set var="percentage"
                                       value="${(stock.quantity / stock.minQuantity * 100) gt 100 ? 100 : (stock.quantity / stock.minQuantity * 100)}">
                                </c:set>
                                <div class="stock-progress">
                                    <div class="stock-progress-bar <c:choose>
                                                <c:when test=" ${stock.quantity lt stock.minQuantity}">low</c:when>
                                        <c:when test="${stock.quantity lt stock.minQuantity * 2}">warning</c:when>
                                        <c:otherwise></c:otherwise>
                                        </c:choose>" style="width: ${percentage}%">
                                    </div>
                                </div>
                                <span class="stock-percentage">${Math.round(percentage * 1.0)}%</span>
                            </td>
                            <td>${stock.updateTime}</td>
                            <td>
                                <a href="/goods/admin/stock/detail/${stock.bid}" class="btn btn-secondary"
                                   style="padding: 5px 10px; font-size: 14px; margin-bottom: 5px; display: block; text-align: center;">查看详情</a>
                                <a href="/goods/admin/stock/edit/${stock.bid}" class="btn btn-primary"
                                   style="padding: 5px 10px; font-size: 14px; display: block; text-align: center;">编辑库存</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="10" class="no-data">暂无库存记录</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <!-- 分页控制 -->
    <c:if test="${pageInfo.total gt 0}">
        <div class="pagination">
            <c:if test="${pageInfo.pageNum gt 1}">
                <a href="/goods/admin/stock/list?pageNum=${pageInfo.pageNum-1}">上一页</a>
            </c:if>

            <c:forEach begin="1" end="${pageInfo.pages}" var="page">
                <a href="/goods/admin/stock/list?pageNum=${page}" <c:if
                        test="${page eq pageInfo.pageNum}">class="active"
                </c:if>>${page}</a>
            </c:forEach>
            <c:if test="${pageInfo.pageNum lt pageInfo.pages}">
                <a href="/goods/admin/stock/list?pageNum=${pageInfo.pageNum+1}">下一页</a>
            </c:if>
        </div>
    </c:if>
</div>
</body>

</html>