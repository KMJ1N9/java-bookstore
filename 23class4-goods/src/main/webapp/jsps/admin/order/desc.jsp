<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>订单详情 - 后台管理系统</title>

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

        /* 按钮样式 */
        .btn {
            transition: all 0.3s ease;
            font-weight: 500;
            border-radius: 4px;
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

        /* 订单信息样式 */
        .order-info {
            margin-bottom: 1rem;
        }

        .info-row {
            display: flex;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f1f3f5;
        }

        .info-label {
            font-weight: 600;
            color: #495057;
            min-width: 100px;
            margin-right: 1rem;
        }

        .info-value {
            color: #212529;
        }

        /* 订单状态标签样式 */
        .order-status {
            padding: 0.3rem 0.8rem;
            border-radius: 4px;
            font-size: 0.9rem;
            font-weight: 500;
            text-align: center;
            display: inline-block;
        }

        .status-waiting {
            background-color: #ffeaa7;
            color: #856404;
        }

        .status-paid {
            background-color: #74b9ff;
            color: #0984e3;
        }

        .status-shipped {
            background-color: #a29bfe;
            color: #6c5ce7;
        }

        .status-completed {
            background-color: #00b894;
            color: white;
        }

        .status-cancelled {
            background-color: #d63031;
            color: white;
        }

        /* 价格样式 */
        .price {
            font-weight: 600;
            color: #e74c3c;
            font-size: 1.1rem;
        }

        /* 商品图片样式 */
        .product-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .product-image:hover {
            transform: scale(1.1);
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

            .info-row {
                flex-direction: column;
            }

            .info-label {
                margin-bottom: 0.25rem;
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
            <i class="fas fa-file-invoice mr-2"></i> 订单详情
        </div>

        <!-- 订单基本信息 -->
        <div class="order-info mb-4">
            <div class="info-row">
                <div class="info-label">订单号：</div>
                <div class="info-value font-weight-medium">${order.oid}</div>
            </div>
            <div class="info-row">
                <div class="info-label">下单时间：</div>
                <div class="info-value"><fmt:formatDate value="${order.ordertime}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
            </div>
            <div class="info-row">
                <div class="info-label">订单状态：</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${order.status == 1}">
                            <span class="order-status status-waiting">等待付款</span>
                        </c:when>
                        <c:when test="${order.status == 2}">
                            <span class="order-status status-paid">已支付</span>
                        </c:when>
                        <c:when test="${order.status == 3}">
                            <span class="order-status status-shipped">已发货</span>
                        </c:when>
                        <c:when test="${order.status == 4}">
                            <span class="order-status status-completed">已确认收货</span>
                        </c:when>
                        <c:when test="${order.status == 5}">
                            <span class="order-status status-cancelled">已取消</span>
                        </c:when>
                        <c:otherwise>
                            <span class="order-status">未知状态</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="info-row">
                <div class="info-label">用户ID：</div>
                <div class="info-value">${order.uid}</div>
            </div>
        </div>

        <!-- 订单商品列表 -->
        <div class="mb-4">
            <h5 class="mb-3 font-weight-medium text-gray-700">订单商品</h5>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>商品图片</th>
                        <th>商品名称</th>
                        <th>单价</th>
                        <th>数量</th>
                        <th>小计</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="orderItem" items="${orderItems}">
                        <tr>
                            <td>
                                <img src="<c:url value='/uploads/${orderItem.imageB}'/>"
                                     alt="${orderItem.bname}"
                                     class="product-image">
                            </td>
                            <td>${orderItem.bname}</td>
                            <td>¥${orderItem.currprice}</td>
                            <td>${orderItem.quantity}</td>
                            <td class="price">¥${orderItem.subtotal}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 订单总价信息 -->
        <div class="text-right mt-4">
            <p class="font-weight-medium">
                订单总价：<span class="price" style="font-size: 1.5rem;">¥${order.total}</span>
            </p>
        </div>

        <!-- 操作按钮 -->
        <div class="mt-4 text-right">
            <c:choose>
                <c:when test="${order.status == 1}">
                    <a href="<c:url value='/admin/order/payOrder?oid=${order.oid}'/>"
                       class="btn btn-primary mr-2">
                        <i class="fas fa-check-circle mr-1"></i> 确认付款
                    </a>
                    <a href="<c:url value='/admin/order/cancelOrder?oid=${order.oid}'/>"
                       class="btn btn-secondary mr-2">
                        <i class="fas fa-times-circle mr-1"></i> 取消订单
                    </a>
                </c:when>
                <c:when test="${order.status == 2}">
                    <a href="<c:url value='/admin/order/deliver?oid=${order.oid}'/>"
                       class="btn btn-primary mr-2">
                        <i class="fas fa-box mr-1"></i> 确认发货
                    </a>
                </c:when>
            </c:choose>

            <a href="<c:url value='/admin/order/updateAddressPage/${order.oid}'/>"
               class="btn btn-secondary mr-2">
                <i class="fas fa-edit mr-1"></i> 修改收货信息
            </a>
            <a href="<c:url value='/admin/order/list'/>"
               class="btn btn-secondary">
                <i class="fas fa-arrow-left mr-1"></i> 返回订单列表
            </a>
        </div>
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

        // 订单状态按钮确认提示
        $(".btn-primary, .btn-secondary").click(function (e) {
            var message = "";

            if ($(this).find('.fa-check-circle').length > 0) {
                message = "确认该订单已付款吗？";
            } else if ($(this).find('.fa-times-circle').length > 0) {
                message = "确认要取消该订单吗？";
            } else if ($(this).find('.fa-box').length > 0) {
                message = "确认要发货吗？";
            }

            // 只有在有确认信息且用户取消的情况下才阻止默认行为
            if (message !== "" && !confirm(message)) {
                e.preventDefault();
                return false;
            }

            // 如果是状态修改按钮，使用AJAX请求
            if ($(this).attr('href') && ($(this).attr('href').indexOf('/payOrder') > -1 ||
                $(this).attr('href').indexOf('/cancelOrder') > -1 ||
                $(this).attr('href').indexOf('/deliver') > -1)) {

                e.preventDefault();
                var url = $(this).attr('href');

                $.ajax({
                    url: url,
                    type: 'GET',
                    success: function (response) {
                        if (response === 'success') {
                            alert('操作成功！');
                            // 刷新页面以显示更新后的订单状态
                            location.reload();
                        } else if (response === 'invalid_status') {
                            alert('订单状态不允许此操作！');
                        } else {
                            alert('操作失败，请重试！');
                        }
                    },
                    error: function () {
                        alert('网络错误，请稍后重试！');
                    }
                });
            }
        });
    });
</script>
</body>
</html>