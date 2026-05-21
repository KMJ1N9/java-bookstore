<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>修改收货信息 - 后台管理系统</title>

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
            border: 1px solid #e9ecef;
        }

        .dashboard-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.15);
            border-color: #3498db;
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

        /* 表单样式增强 */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control {
            border-radius: 4px;
            border: 1px solid #ced4da;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .form-control:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.25);
            outline: none;
        }

        .form-control::placeholder {
            color: #adb5bd;
        }

        /* 按钮样式 */
        .btn {
            transition: all 0.3s ease;
            font-weight: 500;
            border-radius: 4px;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
        }

        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
        }

        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(108, 117, 125, 0.3);
        }

        .btn i {
            margin-right: 0.5rem;
        }

        /* 订单信息卡片样式 */
        .order-summary {
            background-color: #f8f9fa;
            border-radius: 4px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border: 1px solid #e9ecef;
        }

        .order-summary-item {
            display: flex;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }

        .order-summary-item:last-child {
            border-bottom: none;
        }

        .summary-label {
            font-weight: 600;
            color: #495057;
            min-width: 100px;
            margin-right: 1rem;
        }

        .summary-value {
            color: #212529;
            font-weight: 500;
        }

        /* 响应式设计 */
        @media (max-width: 992px) {
            .content-wrapper {
                padding: 1.5rem;
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
                padding: 1.5rem 1rem;
            }

            .welcome-message {
                font-size: 1rem;
                margin-left: 0.5rem;
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

            .order-summary-item {
                flex-direction: column;
            }

            .summary-label {
                margin-bottom: 0.25rem;
            }

            .btn {
                width: 100%;
                justify-content: center;
                margin-bottom: 0.5rem;
            }
        }

        @media (max-width: 576px) {
            .content-wrapper {
                padding: 1rem;
            }

            .card-header {
                font-size: 1.1rem;
            }

            .dashboard-card {
                padding: 1.25rem;
            }
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
        <li><a href="<c:url value='/admin/index'/>" class=""><i class="fas fa-home"></i> <span
                class="nav-text">首页</span></a></li>
        <li><a href="<c:url value='/admin/book/list'/>" class=""><i class="fas fa-shopping-bag"></i> <span
                class="nav-text">商品管理</span></a></li>
        <li><a href="<c:url value='/admin/order/list'/>" class="active"><i class="fas fa-clipboard-list"></i> <span
                class="nav-text">订单管理</span></a></li>
        <li><a href="<c:url value='/admin/user/list'/>" class=""><i class="fas fa-users"></i> <span class="nav-text">用户管理</span></a>
        </li>
    </ul>
</aside>

<!-- 主内容区域 -->
<div class="content-wrapper">
    <div class="dashboard-card">
        <div class="card-header">
            <i class="fas fa-edit mr-2"></i> 修改收货信息
        </div>

        <!-- 订单基本信息摘要 -->
        <div class="order-summary">
            <div class="order-summary-item">
                <div class="summary-label">订单号：</div>
                <div class="summary-value">${order.oid}</div>
            </div>
            <div class="order-summary-item">
                <div class="summary-label">订单金额：</div>
                <div class="summary-value" style="color: #e74c3c;">¥${order.total}</div>
            </div>
        </div>

        <!-- 表单区域 -->
        <form action="<c:url value='/admin/order/updateAddress'/>" method="post">
            <gg:token/>
            <input type="hidden" name="oid" value="${order.oid}"/>

            <div class="form-group">
                <label for="name" class="form-label">收货人姓名 *</label>
                <input type="text" id="name" name="name"
                       class="form-control"
                       placeholder="请输入收货人姓名"
                       required
                       maxlength="50">
            </div>

            <div class="form-group">
                <label for="telephone" class="form-label">手机号码 *</label>
                <input type="tel" id="telephone" name="telephone"
                       class="form-control"
                       placeholder="请输入手机号码"
                       required
                       pattern="^1[3-9]\d{9}$"
                       maxlength="11">
                <small class="text-muted" style="display: block; margin-top: 0.25rem;">请输入11位手机号码</small>
            </div>

            <div class="form-group">
                <label for="address" class="form-label">收货地址 *</label>
                <textarea id="address" name="address"
                          class="form-control"
                          rows="4"
                          placeholder="请输入详细收货地址"
                          required
                          maxlength="200"></textarea>
                <small class="text-muted"
                       style="display: block; margin-top: 0.25rem;">请输入详细的街道、门牌号等信息，方便配送</small>
            </div>

            <div class="mt-4 text-right">
                <a href="<c:url value='/admin/order/desc/${order.oid}'/>"
                   class="btn btn-secondary mr-2">
                    <i class="fas fa-times mr-1"></i> 取消
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-check mr-1"></i> 保存修改
                </button>
            </div>
        </form>
    </div>
</div>

<!-- 引入jQuery和Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 侧边栏折叠功能
    $(document).ready(function () {
        // 侧边栏折叠按钮点击事件
        $('.sidebar-toggle').click(function () {
            $('.sidebar').toggleClass('minimized');
            $('.content-wrapper').toggleClass('sidebar-minimized');
            $(this).find('i').toggleClass('fa-chevron-left fa-chevron-right');
        });

        // 移动端菜单按钮
        $('.menu-toggle').click(function () {
            $('.sidebar').toggleClass('active');
        });

        // 顶部导航栏滚动效果
        $(window).scroll(function () {
            if ($(window).scrollTop() > 10) {
                $('.main-header').addClass('scrolled');
            } else {
                $('.main-header').removeClass('scrolled');
            }
        });

        // 表单验证
        $('form').submit(function (event) {
            var name = $('#name').val().trim();
            var telephone = $('#telephone').val().trim();
            var address = $('#address').val().trim();

            if (!name) {
                alert('请输入收货人姓名');
                $('#name').focus();
                return false;
            }

            if (!telephone) {
                alert('请输入手机号码');
                $('#telephone').focus();
                return false;
            }

            if (!/^1[3-9]\d{9}$/.test(telephone)) {
                alert('请输入有效的手机号码');
                $('#telephone').focus();
                return false;
            }

            if (!address) {
                alert('请输入收货地址');
                $('#address').focus();
                return false;
            }

            return confirm('确认保存修改吗？');
        });
    });
</script>
</body>
</html>