<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>缓存详情 - ${cacheName} - 商品管理系统</title>
    <meta name="description" content="商品管理系统缓存详情页面">
    <meta name="keywords" content="缓存详情,性能监控,缓存统计">

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
            <h1>缓存详情：${cacheName}</h1>
            <div class="header-actions">
                <a href="<c:url value='/admin/cache/list'/>" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> 返回列表
                </a>
                <a href="<c:url value='/admin/cache/clear?cacheName=${cacheName}'/>" class="btn btn-warning"
                   onclick="return confirm('确定要清除缓存 ${cacheName} 吗？')">
                    <i class="fas fa-sync-alt"></i> 清除缓存
                </a>
            </div>
        </header>

        <!-- 缓存统计信息区域 -->
        <div class="cache-stats-container">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-chart-bar mr-2"></i>缓存统计信息
                </div>
                <div class="card-body">
                    <c:if test="${not empty stats}">
                        <div class="stats-grid">
                            <div class="stat-item">
                                <div class="stat-label">当前大小</div>
                                <div class="stat-value">${stats.size}</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-label">最大容量</div>
                                <div class="stat-value">${stats.maxSize}</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-label">命中率</div>
                                <div class="stat-value">${stats.hitRate}%</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-label">未命中率</div>
                                <div class="stat-value">${stats.missRate}%</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-label">总请求数</div>
                                <div class="stat-value">${stats.requestCount}</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-label">命中次数</div>
                                <div class="stat-value">${stats.hitCount}</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-label">未命中次数</div>
                                <div class="stat-value">${stats.missCount}</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-label">平均加载时间(ms)</div>
                                <div class="stat-value">${stats.avgLoadPenalty}</div>
                            </div>
                        </div>

                        <!-- 命中率可视化展示 -->
                        <div class="chart-container">
                            <h3>命中率统计</h3>
                            <div class="hit-rate-chart">
                                <div class="hit-rate-bar">
                                    <div class="hit-rate-fill hit" style="width: ${stats.hitRate}%"></div>
                                    <div class="hit-rate-fill miss" style="width: ${stats.missRate}%"></div>
                                </div>
                                <div class="hit-rate-legend">
                                        <span class="legend-item">
                                            <span class="legend-color hit"></span>
                                            命中: ${stats.hitRate}%
                                        </span>
                                    <span class="legend-item">
                                            <span class="legend-color miss"></span>
                                            未命中: ${stats.missRate}%
                                        </span>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${empty stats}">
                        <div class="no-data">
                            <i class="fas fa-info-circle"></i>
                            暂无缓存统计数据
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>