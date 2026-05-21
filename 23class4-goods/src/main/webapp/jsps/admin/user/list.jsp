<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>用户管理 - 后台管理系统</title>

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

        /* 表格样式 */
        .table {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            margin-bottom: 0;
        }

        .table thead th {
            background-color: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            transition: background-color 0.3s ease;
            padding: 1rem;
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

        .table td {
            padding: 1rem;
            vertical-align: middle;
        }

        /* 按钮样式 */
        .btn {
            transition: all 0.3s ease;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
        }

        .btn-secondary {
            background-color: #7f8c8d;
            border-color: #7f8c8d;
        }

        .btn-secondary:hover {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .btn-success {
            background-color: #2ecc71;
            border-color: #2ecc71;
        }

        .btn-success:hover {
            background-color: #27ae60;
            border-color: #27ae60;
        }

        .btn-danger {
            background-color: #e74c3c;
            border-color: #e74c3c;
        }

        .btn-danger:hover {
            background-color: #c0392b;
            border-color: #c0392b;
        }

        /* 链接样式 */
        .table a {
            color: #171718;
            text-decoration: none;
            transition: all 0.3s ease;
            padding: 0.25rem 0.5rem;
            border-radius: 3px;
            display: inline-block;
            margin: 0 0.25rem;
        }

        .table a:hover {
            background-color: #f0f8fc;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(52, 152, 219, 0.2);
        }

        /* 状态样式 */
        .badge {
            padding: 0.35em 0.65em;
            font-size: 0.75em;
            font-weight: 600;
            border-radius: 0.375rem;
            transition: all 0.3s ease;
        }

        .badge-success {
            background-color: #2ecc71;
        }

        .badge-danger {
            background-color: #e74c3c;
        }

        /* 分页样式 */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 1.5rem;
            padding: 1rem 0;
        }

        .pagination .page-link {
            color: #3498db;
            border-color: #dee2e6;
            transition: all 0.3s ease;
            margin: 0 0.25rem;
            border-radius: 4px;
        }

        .pagination .page-link:hover {
            background-color: #f8f9fa;
            border-color: #3498db;
            color: #2980b9;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(52, 152, 219, 0.2);
        }

        .pagination .page-item.active .page-link {
            background-color: #3498db;
            border-color: #3498db;
            color: white;
        }

        /* 搜索表单样式 */
        .form-control {
            border-radius: 4px;
            transition: all 0.3s ease;
            border: 1px solid #ced4da;
            padding: 0.5rem 1rem;
        }

        .form-control:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.25);
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
                padding: 1.5rem;
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

            .table-responsive {
                overflow-x: auto;
            }

            .btn-group {
                flex-wrap: wrap;
                gap: 0.5rem;
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

            .form-row {
                flex-direction: column;
                gap: 1rem;
            }

            .form-row .form-group {
                margin-bottom: 0;
            }
        }
    </style>
    <script type="text/javascript">
        // 侧边栏切换功能
        document.addEventListener('DOMContentLoaded', function () {
            // 侧边栏折叠按钮
            const sidebarToggle = document.querySelector('.sidebar-toggle');
            const sidebar = document.querySelector('.sidebar');
            const contentWrapper = document.querySelector('.content-wrapper');
            const menuToggle = document.querySelector('.menu-toggle');

            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', function () {
                    sidebar.classList.toggle('minimized');
                    contentWrapper.classList.toggle('sidebar-minimized');

                    const icon = this.querySelector('i');
                    if (sidebar.classList.contains('minimized')) {
                        icon.classList.remove('fa-chevron-left');
                        icon.classList.add('fa-chevron-right');
                    } else {
                        icon.classList.remove('fa-chevron-right');
                        icon.classList.add('fa-chevron-left');
                    }
                });
            }

            // 移动端菜单切换
            if (menuToggle) {
                menuToggle.addEventListener('click', function () {
                    sidebar.classList.toggle('active');
                });
            }

            // 为所有删除按钮添加事件监听
            const deleteButtons = document.querySelectorAll('.delete-btn');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function (e) {
                    e.preventDefault();
                    const uid = this.getAttribute('data-uid');
                    if (confirm('确定要删除该用户吗？')) {
                        const baseUrl = '${pageContext.request.contextPath}/admin/user/delete';
                        const url = baseUrl + '/' + encodeURIComponent(uid);
                        window.location.href = url;
                    }
                });
            });
        });
    </script>
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
        <li><a href="<c:url value='/admin/order/list'/>" class=""><i class="fas fa-shopping-cart"></i> <span
                class="nav-text">订单管理</span></a></li>
        <li><a href="<c:url value='/admin/user/list'/>" class="active"><i class="fas fa-users"></i> <span
                class="nav-text">用户管理</span></a></li>
        <li><a href="<c:url value='/admin/stock/list'/>" class=""><i class="fas fa-warehouse"></i> <span
                class="nav-text">库存管理</span></a></li>
        <li><a href="<c:url value='/admin/cache/list'/>" class=""><i class="fas fa-database"></i> <span
                class="nav-text">缓存管理</span></a></li>
    </ul>
</aside>

<!-- 主内容区域 -->
<div class="content-wrapper">
    <!-- 页面标题卡片 -->
    <div class="dashboard-card fade-in">
        <div class="card-header">
            <i class="fas fa-users mr-2"></i>
            用户管理
        </div>
    </div>

    <!-- 功能按钮区域 -->
    <div class="dashboard-card fade-in" style="animation-delay: 0.1s;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="${pageContext.request.contextPath}/admin/user/toAdd" class="btn btn-primary">
                    <i class="fas fa-plus"></i> 添加用户
                </a>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/admin/index" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> 返回首页
                </a>
            </div>
        </div>
    </div>

    <!-- 查询区域 -->
    <div class="dashboard-card fade-in" style="animation-delay: 0.2s;">
        <div class="card-header">
            <i class="fas fa-search mr-2"></i>
            用户搜索
        </div>
        <div class="mt-4">
            <form action="${pageContext.request.contextPath}/admin/user/search" method="post"
                  class="form-row align-items-center justify-content-center">
                <div class="form-group">
                    <label for="loginname" class="mr-2">用户名：</label>
                    <input type="text" name="loginname" id="loginname" value="${loginname}" class="form-control"
                           style="width: 250px;">
                </div>
                <div class="form-group">
                    <gg:token/>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> 搜索
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- 操作提示信息 -->
    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
            <i class="fas fa-check-circle mr-2"></i>${message}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:if>

    <!-- 用户列表表格 -->
    <div class="dashboard-card fade-in" style="animation-delay: 0.3s;">
        <div class="card-header">
            <i class="fas fa-list-alt mr-2"></i>
            用户列表
        </div>
        <div class="table-responsive mt-4">
            <table class="table table-hover table-striped">
                <thead>
                <tr>
                    <th width="10%">用户ID</th>
                    <th width="20%">用户名</th>
                    <th width="25%">邮箱</th>
                    <th width="10%">状态</th>
                    <th width="35%">操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageInfo.list}" var="user">
                    <tr>
                        <td>${user.uid}</td>
                        <td>${user.loginname}</td>
                        <td>${user.email}</td>
                        <td>
                            <c:choose>
                                <c:when test="${user.status == 1}">
                                    <span class="badge badge-success">已激活</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">未激活</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/admin/user/toEdit/${user.uid}"
                                   class="btn btn-sm btn-primary">
                                    <i class="fas fa-edit"></i> 编辑
                                </a>
                                <a href="#" class="delete-btn" data-uid="${user.uid}">删除</a>
                                <c:if test="${user.status == 0}">
                                    <a href="${pageContext.request.contextPath}/admin/user/enable/${user.uid}">启用</a>
                                </c:if>
                                <c:if test="${user.status == 1}">
                                    <a href="${pageContext.request.contextPath}/admin/user/disable/${user.uid}">禁用</a>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 分页区域 -->
    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center">
            <%-- 首页和上一页 --%>
            <c:if test="${pageInfo.hasPreviousPage}">
                <li class="page-item">
                    <c:choose>
                        <c:when test="${empty loginname}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/user/list?pageNum=1"
                               aria-label="首页">
                                <span aria-hidden="true"><i class="fas fa-angle-double-left"></i></span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/user/search?loginname=${loginname}&pageNum=1"
                               aria-label="首页">
                                <span aria-hidden="true"><i class="fas fa-angle-double-left"></i></span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
                <li class="page-item">
                    <c:choose>
                        <c:when test="${empty loginname}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/user/list?pageNum=${pageInfo.prePage}"
                               aria-label="上一页">
                                <span aria-hidden="true"><i class="fas fa-angle-left"></i></span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/user/search?loginname=${loginname}&pageNum=${pageInfo.prePage}"
                               aria-label="上一页">
                                <span aria-hidden="true"><i class="fas fa-angle-left"></i></span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:if>

            <%-- 页码列表 --%>
            <c:forEach begin="${pageInfo.navigateFirstPage}" end="${pageInfo.navigateLastPage}" var="pageNum">
                <li class="page-item <c:if test='${pageNum == pageInfo.pageNum}'>active</c:if>">
                    <c:choose>
                        <c:when test="${empty loginname}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/user/list?pageNum=${pageNum}">${pageNum}</a>
                        </c:when>
                        <c:otherwise>
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/user/search?loginname=${loginname}&pageNum=${pageNum}">${pageNum}</a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:forEach>

            <%-- 下一页和末页 --%>
            <c:if test="${pageInfo.hasNextPage}">
                <li class="page-item">
                    <c:choose>
                        <c:when test="${empty loginname}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/user/list?pageNum=${pageInfo.nextPage}"
                               aria-label="下一页">
                                <span aria-hidden="true"><i class="fas fa-angle-right"></i></span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/user/search?loginname=${loginname}&pageNum=${pageInfo.nextPage}"
                               aria-label="下一页">
                                <span aria-hidden="true"><i class="fas fa-angle-right"></i></span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
                <li class="page-item">
                    <c:choose>
                        <c:when test="${empty loginname}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/user/list?pageNum=${pageInfo.pages}"
                               aria-label="末页">
                                <span aria-hidden="true"><i class="fas fa-angle-double-right"></i></span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/user/search?loginname=${loginname}&pageNum=${pageInfo.pages}"
                               aria-label="末页">
                                <span aria-hidden="true"><i class="fas fa-angle-double-right"></i></span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:if>
        </ul>
        <div class="text-center text-muted mt-2">
            <small>共 ${pageInfo.pages} 页，${pageInfo.total} 条记录</small>
        </div>
    </nav>
</div>

<!-- 引入Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>