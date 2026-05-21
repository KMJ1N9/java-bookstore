<%@ page language="java" import="java.util.Date" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 检查管理员是否已登录，如果未登录则重定向到登录页面 -->
<c:if test="${empty admin}">
    <c:redirect url="/admin/loginPage"/>
</c:if>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>后台管理系统</title>

    <!-- 引入Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <!-- 引入Font Awesome图标 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <style type="text/css">
        /* 全局样式 */
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        /* 平滑滚动 */
        html {
            scroll-behavior: smooth;
        }

        /* 顶部导航栏样式 */
        .main-header {
            background-color: #2c3e50;
            color: white;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .main-header.scrolled {
            padding: 0.75rem 2rem;
            background-color: rgba(44, 62, 80, 0.95);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .welcome-message {
            font-size: 1.1rem;
            font-weight: 500;
        }

        .logout-link {
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            background-color: rgba(255, 255, 255, 0.1);
            display: inline-flex;
            align-items: center;
        }

        .logout-link:hover {
            color: #ecf0f1;
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            text-decoration: none;
        }

        /* 侧边栏样式 */
        .sidebar {
            width: 240px;
            background-color: #34495e;
            position: fixed;
            top: 60px;
            bottom: 0;
            left: 0;
            z-index: 100;
            transition: transform 0.3s ease, width 0.3s ease;
            overflow-y: auto;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        }

        .sidebar.minimized {
            width: 60px;
        }

        .sidebar.minimized .nav-text {
            display: none;
        }

        .sidebar.minimized a {
            text-align: center;
            padding: 1rem 0.5rem;
        }

        .sidebar.minimized a i {
            margin-right: 0;
            font-size: 1.2rem;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar li {
            border-bottom: 1px solid #2c3e50;
            position: relative;
        }

        .sidebar a {
            display: block;
            padding: 1rem 1.5rem;
            color: #ecf0f1;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 0.95rem;
            position: relative;
            overflow: hidden;
        }

        .sidebar a:before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            transition: left 0.5s;
        }

        .sidebar a:hover:before {
            left: 100%;
        }

        .sidebar a:hover {
            background-color: #2c3e50;
            color: #3498db;
            padding-left: 1.7rem;
            transform: translateX(5px);
        }

        .sidebar a.active {
            background-color: #3498db;
            color: white;
            font-weight: 500;
        }

        .sidebar a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
            transition: all 0.3s ease;
        }

        /* 折叠按钮 */
        .sidebar-toggle {
            position: absolute;
            right: -15px;
            top: 20px;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #3498db;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
            z-index: 101;
        }

        .sidebar-toggle:hover {
            background-color: #2980b9;
            transform: scale(1.1);
        }

        /* 主内容区域样式 */
        .content-wrapper {
            margin-left: 240px;
            margin-top: 60px;
            padding: 2rem;
            transition: all 0.3s ease;
            min-height: calc(100vh - 60px);
        }

        .content-wrapper.sidebar-minimized {
            margin-left: 60px;
        }

        /* 卡片样式 */
        .dashboard-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease, border 0.3s ease;
            border-top: 4px solid #3498db;
            border: 1px solid #e9ecef;
            position: relative;
            overflow: hidden;
        }

        .dashboard-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #3498db, #9b59b6);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.15);
            border-color: #3498db;
        }

        .dashboard-card:hover::before {
            transform: scaleX(1);
        }

        .card-header {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 1rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
        }

        /* 快捷操作按钮样式 */
        .quick-action-btn {
            display: block;
            text-align: center;
            padding: 1rem;
            margin-bottom: 0.75rem;
            background-color: #f8f9fa;
            border-radius: 6px;
            color: #2c3e50;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-left: 3px solid #3498db;
            position: relative;
            overflow: hidden;
        }

        .quick-action-btn::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 0;
            background-color: rgba(52, 152, 219, 0.1);
            transition: height 0.3s ease;
        }

        .quick-action-btn:hover {
            background-color: #3498db;
            color: white;
            transform: translateX(5px) translateY(-2px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
            border-left-color: #2980b9;
        }

        .quick-action-btn:hover::after {
            height: 100%;
        }

        .quick-action-btn i {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            display: block;
            transition: transform 0.3s ease;
        }

        .quick-action-btn:hover i {
            transform: scale(1.2) rotate(10deg);
        }

        /* 统计卡片样式 */
        .stats-card {
            text-align: center;
            padding: 1.5rem;
            border-radius: 8px;
            color: white;
            margin-bottom: 1.5rem;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            transform: rotate(45deg);
            animation: shimmer 2s infinite;
            opacity: 0;
        }

        .stats-card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
        }

        .stats-card:hover::before {
            opacity: 1;
        }

        @keyframes shimmer {
            0% {
                left: -50%;
                opacity: 0;
            }
            50% {
                opacity: 0.3;
            }
            100% {
                left: 150%;
                opacity: 0;
            }
        }

        .stats-card i {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }

        .stats-value {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
        }

        .stats-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .bg-blue {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .bg-green {
            background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%);
        }

        .bg-orange {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .bg-purple {
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            color: #2c3e50;
        }

        /* 移动端响应式菜单按钮 */
        .menu-toggle {
            color: white;
            font-size: 1.2rem;
            cursor: pointer;
            display: none;
            padding: 0.5rem;
            border-radius: 4px;
            transition: all 0.3s ease;
        }

        .menu-toggle:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        /* 表格样式增强 */
        .table {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .table thead th {
            background-color: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            transition: background-color 0.3s ease;
        }

        .table thead th:hover {
            background-color: #e9ecef;
        }

        .table tbody tr {
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
            transform: translateX(5px);
        }

        /* 徽章样式 */
        .badge {
            padding: 0.35em 0.65em;
            font-size: 0.75em;
            font-weight: 600;
            border-radius: 0.375rem;
            transition: all 0.3s ease;
        }

        .badge:hover {
            transform: scale(1.05);
        }

        /* 加载动画 */
        .loader {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        /* 响应式设计 */
        @media (max-width: 992px) {
            .stats-value {
                font-size: 1.8rem;
            }

            .quick-action-btn i {
                font-size: 1.3rem;
            }
        }

        @media (max-width: 768px) {
            .menu-toggle {
                display: block;
            }

            .sidebar {
                transform: translateX(-100%);
                width: 260px;
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .content-wrapper {
                margin-left: 0;
                padding: 1.5rem;
            }

            .welcome-message {
                font-size: 1rem;
                margin-left: 0.5rem;
            }

            .stats-card {
                margin-bottom: 1rem;
            }

            .main-header {
                padding: 1rem;
            }

            .sidebar-toggle {
                right: -10px;
                top: 15px;
                width: 25px;
                height: 25px;
                font-size: 0.75rem;
            }
        }

        @media (max-width: 576px) {
            .content-wrapper {
                padding: 1rem;
            }

            .stats-value {
                font-size: 1.5rem;
            }

            .card-header {
                font-size: 1.1rem;
            }

            .dashboard-card {
                padding: 1.25rem;
            }
        }

        /* 动画效果 */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }

        /* 工具提示 */
        .tooltip {
            position: absolute;
            background-color: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 0.5rem 0.75rem;
            border-radius: 4px;
            font-size: 0.85rem;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            z-index: 1000;
            bottom: 125%;
            left: 50%;
            transform: translateX(-50%);
        }

        .tooltip::after {
            content: '';
            position: absolute;
            top: 100%;
            left: 50%;
            margin-left: -5px;
            border-width: 5px;
            border-style: solid;
            border-color: rgba(0, 0, 0, 0.8) transparent transparent transparent;
        }

        [data-tooltip]:hover .tooltip {
            opacity: 1;
            visibility: visible;
            transform: translateX(-50%) translateY(-5px);
        }
    </style>
</head>

<body>
<!-- 顶部导航栏 -->
<header class="main-header d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center">
        <span class="menu-toggle mr-3"><i class="fas fa-bars"></i></span>
        <span class="welcome-message">欢迎管理员：<span class="text-primary">${admin.adminname}</span></span>
    </div>
    <div>
        <a href="<c:url value='/admin/logout'/>" class="logout-link">
            <i class="fas fa-sign-out-alt mr-1"></i> 退出
        </a>
    </div>
</header>

<!-- 侧边栏导航 -->
<aside class="sidebar">
    <div class="sidebar-toggle">
        <i class="fas fa-chevron-left"></i>
    </div>
    <ul>
        <li><a href="<c:url value='/admin/index'/>" class="active"><i class="fas fa-home"></i> <span
                class="nav-text">首页</span></a></li>
        <li><a href="<c:url value='/admin/book/list'/>" class=""><i class="fas fa-shopping-bag"></i> <span
                class="nav-text">商品管理</span></a></li>
        <li><a href="<c:url value='/admin/order/list'/>" class=""><i class="fas fa-shopping-cart"></i> <span
                class="nav-text">订单管理</span></a></li>
        <li><a href="<c:url value='/admin/user/list'/>" class=""><i class="fas fa-users"></i> <span class="nav-text">用户管理</span></a>
        </li>
        <li><a href="<c:url value='/admin/stock/list'/>" class=""><i class="fas fa-warehouse"></i> <span
                class="nav-text">库存管理</span></a></li>
        <li><a href="<c:url value='/admin/cache/list'/>" class=""><i class="fas fa-database"></i> <span
                class="nav-text">缓存管理</span></a></li>
    </ul>
</aside>

<!-- 主内容区域 -->
<main class="content-wrapper">
    <!-- 统计卡片区域 -->
    <div class="row mb-4">
        <div class="col-md-6 col-lg-3">
            <div class="stats-card bg-blue fade-in">
                <i class="fas fa-shopping-bag"></i>
                <div class="stats-value">128</div>
                <div class="stats-label">商品总数</div>
            </div>
        </div>
        <div class="col-md-6 col-lg-3">
            <div class="stats-card bg-green fade-in">
                <i class="fas fa-shopping-cart"></i>
                <div class="stats-value">36</div>
                <div class="stats-label">今日订单</div>
            </div>
        </div>
        <div class="col-md-6 col-lg-3">
            <div class="stats-card bg-orange fade-in">
                <i class="fas fa-users"></i>
                <div class="stats-value">256</div>
                <div class="stats-label">注册用户</div>
            </div>
        </div>
        <div class="col-md-6 col-lg-3">
            <div class="stats-card bg-purple fade-in">
                <i class="fas fa-chart-line"></i>
                <div class="stats-value">¥12,580</div>
                <div class="stats-label">今日销售额</div>
            </div>
        </div>
    </div>
    <!-- 系统信息卡片 -->
    <div class="row mb-4">
        <div class="col-lg-6">
            <div class="dashboard-card fade-in">
                <div class="card-header">
                    <i class="fas fa-info-circle mr-2"></i>系统信息
                </div>
                <div class="card-body">
                    <p class="mb-3">欢迎使用后台管理系统</p>
                    <p class="text-muted">当前时间：<%=new Date().toLocaleString() %>
                    </p>
                    <div class="mt-3 p-3 bg-light rounded">
                        <p class="small mb-1"><i class="fas fa-server mr-1"></i> 系统状态：<span
                                class="badge badge-success">正常运行</span></p>
                        <p class="small mb-1"><i class="fas fa-shield-alt mr-1"></i> 安全状态：<span
                                class="badge badge-success">已更新</span></p>
                        <p class="small"><i class="fas fa-cloud mr-1"></i> 服务器负载：<span class="badge badge-warning">23%</span>
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <!-- 快捷操作卡片 -->
        <div class="col-lg-6">
            <div class="dashboard-card fade-in">
                <div class="card-header">
                    <i class="fas fa-bolt mr-2"></i>快捷操作
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-6">
                            <a href="<c:url value='/admin/book/addPage'/>" class="quick-action-btn">
                                <i class="fas fa-plus-circle"></i>
                                <span>添加商品</span>
                            </a>
                        </div>
                        <div class="col-6">
                            <a href="<c:url value='/admin/order/list'/>" class="quick-action-btn">
                                <i class="fas fa-list-alt"></i>
                                <span>查看订单</span>
                            </a>
                        </div>
                        <div class="col-6">
                            <a href="<c:url value='/admin/user/list'/>" class="quick-action-btn">
                                <i class="fas fa-user-cog"></i>
                                <span>管理用户</span>
                            </a>
                        </div>
                        <div class="col-6">
                            <a href="<c:url value='/admin/stock/list'/>" class="quick-action-btn">
                                <i class="fas fa-tags"></i>
                                <span>库存管理</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 最近活动卡片 -->
    <div class="dashboard-card fade-in">
        <div class="card-header">
            <i class="fas fa-history mr-2"></i>最近活动
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>时间</th>
                        <th>操作</th>
                        <th>状态</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>10:23</td>
                        <td>添加了新商品：iPhone 13 Pro</td>
                        <td><span class="badge badge-success">成功</span></td>
                    </tr>
                    <tr>
                        <td>09:45</td>
                        <td>处理了订单 #12345></td>
                        <td><span class="badge badge-success">成功</span></td>
                    </tr>
                    <tr>
                        <td>08:30</td>
                        <td>更新了系统设置</td>
                        <td><span class="badge badge-success">成功</span></td>
                    </tr>
                    <tr>
                        <td>昨天</td>
                        <td>删除了过期商品</td>
                        <td><span class="badge badge-warning">警告</span></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js"></script>

<script>
    // 页面加载时再次检查登录状态（防止session过期后的页面显示问题）
    if (!('${admin}' && '${admin.adminname}')) {
        window.location.href = '<c:url value="/admin/loginPage"/>';
    }

    $(document).ready(function () {
        // 侧边栏切换
        $('.menu-toggle').click(function () {
            $('.sidebar').toggleClass('active');
        });

        // 侧边栏折叠功能
        $('.sidebar-toggle').click(function () {
            const sidebar = $('.sidebar');
            const contentWrapper = $('.content-wrapper');
            const icon = $(this).find('i');

            sidebar.toggleClass('minimized');
            contentWrapper.toggleClass('sidebar-minimized');

            if (icon.hasClass('fa-chevron-left')) {
                icon.removeClass('fa-chevron-left').addClass('fa-chevron-right');
            } else {
                icon.removeClass('fa-chevron-right').addClass('fa-chevron-left');
            }
        });

        // 滚动时导航栏效果
        $(window).scroll(function () {
            if ($(window).scrollTop() > 10) {
                $('.main-header').addClass('scrolled');
            } else {
                $('.main-header').removeClass('scrolled');
            }
        });

        // 添加渐入动画效果
        $('.fade-in').each(function (index) {
            $(this).css('animation-delay', index * 0.1 + 's');
        });

        // 为统计卡片添加数字动画效果
        function animateValue(element, start, end, duration) {
            let startTimestamp = null;
            const step = (timestamp) => {
                if (!startTimestamp) startTimestamp = timestamp;
                const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                const value = Math.floor(progress * (end - start) + start);

                // 格式化货币
                if (element.textContent.includes('¥')) {
                    element.textContent = '¥' + value.toLocaleString();
                } else {
                    element.textContent = value.toLocaleString();
                }

                if (progress < 1) {
                    window.requestAnimationFrame(step);
                }
            };
            window.requestAnimationFrame(step);
        }

        // 检测元素是否在可视区域内
        function isElementInViewport(el) {
            const rect = el.getBoundingClientRect();
            return (
                rect.top >= 0 &&
                rect.left >= 0 &&
                rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
                rect.right <= (window.innerWidth || document.documentElement.clientWidth)
            );
        }

        // 为卡片添加数字动画
        const animateOnScroll = () => {
            const statsElements = document.querySelectorAll('.stats-value');
            statsElements.forEach(el => {
                if (isElementInViewport(el)) {
                    const value = el.textContent.replace(/[^0-9]/g, '');
                    animateValue(el, 0, parseInt(value), 1500);
                    el.setAttribute('data-animated', 'true');
                }
            });
        };

        // 初始化时检查
        animateOnScroll();

        // 滚动时检查
        window.addEventListener('scroll', animateOnScroll);

        // 添加工具提示功能
        $('[title]').each(function () {
            const title = $(this).attr('title');
            $(this).attr('data-tooltip', 'true');
            $(this).append('<span class="tooltip">' + title + '</span>');
            $(this).removeAttr('title');
        });

        // 添加点击波纹效果
        $(document).on('click', '.quick-action-btn, .logout-link', function (e) {
            const x = e.offsetX;
            const y = e.offsetY;
            const ripple = $('<span class="ripple"></span>');

            ripple.css({
                top: y + 'px',
                left: x + 'px'
            });

            $(this).append(ripple);

            setTimeout(() => {
                ripple.remove();
            }, 1000);
        });

        // 实时更新功能
        function updateDashboardData() {
            // 获取统计数据
            $.ajax({
                url: '/goods/admin/dashboard/stats',
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    // 更新统计卡片
                    if (data.stats) {
                        $('.stats-card:nth-child(1) .stats-value').text(data.stats.totalProducts).removeAttr('data-animated');
                        $('.stats-card:nth-child(2) .stats-value').text(data.stats.todayOrders).removeAttr('data-animated');
                        $('.stats-card:nth-child(3) .stats-value').text(data.stats.totalUsers).removeAttr('data-animated');
                        $('.stats-card:nth-child(4) .stats-value').text('¥' + data.stats.todaySales.toLocaleString()).removeAttr('data-animated');

                        // 重新执行动画
                        animateOnScroll();
                    }

                    // 更新最近活动
                    if (data.recentActivities && data.recentActivities.length > 0) {
                        const tbody = $('.table-responsive tbody');
                        tbody.empty();

                        data.recentActivities.forEach(activity => {
                            const statusClass = activity.status === 'success' ? 'badge-success' : 'badge-warning';
                            const statusText = activity.status === 'success' ? '成功' : '警告';

                            tbody.append(`
                    <tr>
                      <td>${activity.time}</td>
                      <td>${activity.action}</td>
                      <td><span class="badge ${statusClass}">${statusText}</span></td>
                    </tr>
                  `);
                        });
                    }
                },
                error: function (xhr, status, error) {
                    console.error('获取仪表盘数据失败:', error);
                }
            });
        }

        // 初始加载数据
        updateDashboardData();

        // 设置定时刷新，每30秒更新一次
        setInterval(updateDashboardData, 30000);
    });

    // 添加波纹效果的CSS
    const style = document.createElement('style');
    style.textContent = `
        .ripple {
          position: absolute;
          width: 100px;
          height: 100px;
          margin-left: -50px;
          margin-top: -50px;
          border-radius: 50%;
          background: rgba(255, 255, 255, 0.5);
          transform: scale(0);
          animation: ripple 0.6s linear;
          pointer-events: none;
          z-index: 1000;
        }
        
        @keyframes ripple {
          to {
            transform: scale(4);
            opacity: 0;
          }
        }
      `;
    document.head.appendChild(style);
</script>
</body>
</html>