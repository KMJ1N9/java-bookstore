<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>缓存管理 - 商品管理系统</title>
    <meta name="description" content="商品管理系统缓存管理页面">
    <meta name="keywords" content="缓存管理,性能优化,后台管理">

    <!-- 引入全局样式 -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/admin/common.css'/>">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/admin/cache.css'/>">

    <!-- 引入Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<div class="admin-container">
    <!-- 侧边栏导航 -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2>管理中心</h2>
        </div>
        <ul class="sidebar-menu">
            <li><a href="<c:url value='/admin/index'/>" class=""><i class="fas fa-home"></i> <span
                    class="nav-text">首页</span></a></li>
            <li><a href="<c:url value='/admin/book/list'/>" class=""><i class="fas fa-shopping-bag"></i> <span
                    class="nav-text">商品管理</span></a></li>
            <li><a href="<c:url value='/admin/category/list'/>" class=""><i class="fas fa-th-large"></i> <span
                    class="nav-text">分类管理</span></a></li>
            <li><a href="<c:url value='/admin/order/list'/>" class=""><i class="fas fa-shopping-cart"></i> <span
                    class="nav-text">订单管理</span></a></li>
            <li><a href="<c:url value='/admin/user/list'/>" class=""><i class="fas fa-users"></i> <span
                    class="nav-text">用户管理</span></a></li>
            <li><a href="<c:url value='/admin/stock/list'/>" class=""><i class="fas fa-warehouse"></i> <span
                    class="nav-text">库存管理</span></a></li>
            <li><a href="<c:url value='/admin/cache/list'/>" class="active"><i class="fas fa-database"></i> <span
                    class="nav-text">缓存管理</span></a></li>
        </ul>
    </aside>

    <!-- 主内容区域 -->
    <main class="content-wrapper">
        <!-- 页面头部 -->
        <header class="page-header">
            <h1>缓存管理</h1>
            <div class="header-actions">
                <button id="clearAllBtn" class="btn btn-danger" onclick="confirmClearAll()">
                    <i class="fas fa-trash-alt"></i> 清除所有缓存
                </button>
            </div>
        </header>

        <!-- 消息提示区域 -->
        <div class="message-area">
            <c:if test="${not empty message}">
                <div class="message success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="message error">${error}</div>
            </c:if>
        </div>

        <!-- 缓存列表区域 -->
        <div class="cache-list-container">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-list-ul mr-2"></i>缓存列表
                </div>
                <div class="card-body">
                    <table class="table table-hover table-list">
                        <thead>
                        <tr>
                            <th>缓存名称</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${cacheNames}" var="cacheName">
                            <tr>
                                <td>${cacheName}</td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<c:url value='/admin/cache/detail?cacheName=${cacheName}'/>"
                                           class="btn btn-info btn-sm">
                                            <i class="fas fa-eye"></i> 查看详情
                                        </a>
                                        <a href="<c:url value='/admin/cache/clear?cacheName=${cacheName}'/>"
                                           class="btn btn-warning btn-sm"
                                           onclick="return confirm('确定要清除缓存 ${cacheName} 吗？')">
                                            <i class="fas fa-sync-alt"></i> 清除缓存
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty cacheNames}">
                            <tr>
                                <td colspan="2" class="no-data">暂无缓存数据</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- JavaScript -->
<script>
    // 确认清除所有缓存
    function confirmClearAll() {
        if (confirm('确定要清除所有缓存吗？这将导致所有缓存数据丢失，可能会暂时影响系统性能。')) {
            window.location.href = '<c:url value="/admin/cache/clearAll"/>';
        }
    }
</script>
</body>
</html>