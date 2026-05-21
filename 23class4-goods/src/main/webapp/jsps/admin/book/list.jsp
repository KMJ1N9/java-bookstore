<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品管理 - 商品列表</title>

    <!-- 引入Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <!-- 引入Font Awesome图标 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/admin/common.css'/>">

    <style>
        /* 管理员页面通用样式 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            line-height: 1.6;
        }

        /* 顶部导航栏样式 */
        .main-header {
            background-color: #2c3e50;
            color: white;
            padding: 1rem 2rem;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease;
        }

        .main-header.scrolled {
            background-color: rgba(44, 62, 80, 0.95);
            padding: 0.8rem 2rem;
        }

        .menu-toggle {
            cursor: pointer;
            font-size: 1.5rem;
            color: white;
            transition: color 0.3s ease;
        }

        .menu-toggle:hover {
            color: #3498db;
        }

        .welcome-message {
            font-size: 1rem;
            margin-left: 1rem;
        }

        .logout-link {
            color: white;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .logout-link:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: #3498db;
            text-decoration: none;
        }

        /* 侧边栏样式 */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 240px;
            height: 100vh;
            background-color: #2c3e50;
            color: white;
            padding-top: 70px;
            transform: translateX(-100%);
            transition: transform 0.3s ease, width 0.3s ease;
            z-index: 900;
            overflow-y: auto;
            box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);
        }

        .sidebar.active {
            transform: translateX(0);
        }

        .sidebar.minimized {
            width: 60px;
        }

        .sidebar.minimized .nav-text {
            display: none;
        }

        .sidebar.minimized .sidebar-header h2 {
            display: none;
        }

        .sidebar-toggle {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255, 255, 255, 0.1);
            border: none;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .sidebar-toggle:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: scale(1.1);
        }

        .sidebar-header {
            padding: 1rem;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 1rem;
        }

        .sidebar-header h2 {
            font-size: 1.2rem;
            margin: 0;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            margin: 0;
        }

        .sidebar ul li a {
            display: flex;
            align-items: center;
            padding: 0.8rem 1.5rem;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .sidebar ul li a:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .sidebar ul li a.active {
            background-color: #3498db;
            border-left-color: #2980b9;
            color: white;
        }

        .sidebar ul li a i {
            font-size: 1.2rem;
            margin-right: 0.8rem;
            width: 20px;
            text-align: center;
        }

        .nav-text {
            transition: all 0.3s ease;
        }

        /* 主内容区域样式 */
        .content-wrapper {
            margin-left: 0;
            margin-top: 70px;
            padding: 2rem;
            transition: margin-left 0.3s ease;
            min-height: calc(100vh - 70px);
        }

        .content-wrapper.sidebar-minimized {
            margin-left: 60px;
        }

        .content-wrapper.sidebar-active {
            margin-left: 240px;
        }

        /* 卡片样式 */
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .card-header {
            background-color: #f8f9fa;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e9ecef;
            font-weight: 600;
            color: #495057;
        }

        .card-body {
            padding: 1.5rem;
        }

        /* 动画效果 */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 工具提示样式 */
        [data-tooltip] {
            position: relative;
        }

        .tooltip {
            position: absolute;
            bottom: 125%;
            left: 50%;
            transform: translateX(-50%);
            background-color: #333;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
            z-index: 1000;
        }

        .tooltip::after {
            content: '';
            position: absolute;
            top: 100%;
            left: 50%;
            transform: translateX(-50%);
            border-width: 5px;
            border-style: solid;
            border-color: #333 transparent transparent transparent;
        }

        [data-tooltip]:hover .tooltip {
            opacity: 1;
            visibility: visible;
        }

        /* 表格样式 */
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 0;
        }

        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            text-align: left;
            padding: 12px 15px;
            border-bottom: 2px solid #dee2e6;
        }

        .table td {
            padding: 12px 15px;
            border-bottom: 1px solid #dee2e6;
            vertical-align: middle;
        }

        .table tr:hover {
            background-color: #f8f9fa;
        }

        /* 封面图片样式 */
        .cover-img {
            max-width: 80px;
            max-height: 100px;
            object-fit: cover;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        /* 价格样式 */
        .original-price {
            color: #6c757d;
            text-decoration: line-through;
            font-size: 0.9rem;
        }

        .price {
            color: #dc3545;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .discount-badge {
            background-color: #ff6b6b;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        /* 分页样式 */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 1rem;
        }

        .pagination li {
            margin: 0 4px;
        }

        .pagination a {
            display: inline-block;
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            color: #495057;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .pagination a:hover {
            background-color: #f8f9fa;
            border-color: #3498db;
            color: #3498db;
        }

        .pagination li.active a {
            background-color: #3498db;
            border-color: #3498db;
            color: white;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .main-header {
                padding: 0.8rem 1rem;
            }

            .content-wrapper {
                padding: 1rem;
            }

            .welcome-message {
                display: none;
            }

            .search-form .row {
                flex-direction: column;
            }

            .search-form .col-md-3 {
                margin-bottom: 1rem;
            }

            .table-responsive {
                overflow-x: auto;
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
    <div class="sidebar-header">
        <h2>管理员后台</h2>
    </div>
    <ul>
        <li><a href="<c:url value='/admin/index'/>" class=""><i class="fas fa-home"></i> <span
                class="nav-text">首页</span></a></li>
        <li><a href="<c:url value='/admin/book/list'/>" class="active"><i class="fas fa-shopping-bag"></i> <span
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
    <!-- 页面标题卡片 -->
    <div class="card fade-in">
        <div class="card-header">
            <i class="fas fa-box-open mr-2"></i>
            商品管理 - 商品列表
        </div>
    </div>

    <!-- 搜索表单卡片 -->
    <div class="card fade-in">
        <div class="card-body">
            <form action="<c:url value='/admin/book/list'/>" method="get" class="search-form">
                <div class="row">
                    <div class="col-md-3 form-group">
                        <label for="bname" class="form-label">书名:</label>
                        <input type="text" id="bname" name="bname" value="${book.bname}" class="form-control"
                               placeholder="请输入书名"/>
                    </div>

                    <div class="col-md-3 form-group">
                        <label for="author" class="form-label">作者:</label>
                        <input type="text" id="author" name="author" value="${book.author}" class="form-control"
                               placeholder="请输入作者"/>
                    </div>

                    <div class="col-md-3 form-group">
                        <label for="press" class="form-label">出版社:</label>
                        <input type="text" id="press" name="press" value="${book.press}" class="form-control"
                               placeholder="请输入出版社"/>
                    </div>

                    <div class="col-md-3 form-group" style="display: flex; align-items: flex-end; gap: 10px;">
                        <button type="submit" class="btn btn-primary flex-1">
                            <i class="fas fa-search mr-1"></i>搜索
                        </button>
                        <a href="<c:url value='/admin/book/addPage'/>" class="btn btn-success flex-1">
                            <i class="fas fa-plus mr-1"></i>添加商品
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- 商品表格卡片 -->
    <div class="card fade-in">
        <div class="card-body">
            <table class="table">
                <thead>
                <tr>
                    <th>封面</th>
                    <th>书名</th>
                    <th>作者</th>
                    <th>出版社</th>
                    <th>价格</th>
                    <th>现价</th>
                    <th>折扣</th>
                    <th>出版时间</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty pageInfo.list}">
                        <tr>
                            <td colspan="9" class="no-data">
                                <p>暂无商品数据</p>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${pageInfo.list}" var="book">
                            <tr>
                                <td>
                                    <c:if test="${not empty book.imageB}">
                                        <img src="<c:url value='/${book.imageB}'/>" alt="封面" class="cover-img"/>
                                    </c:if>
                                    <c:if test="${empty book.imageB}">
                                        <div class="text-center py-4 px-2">
                                            <p class="text-muted">无图片</p>
                                        </div>
                                    </c:if>
                                </td>
                                <td>${book.bname}</td>
                                <td>${book.author}</td>
                                <td>${book.press}</td>
                                <td>
                                    <span class="original-price">¥${book.price}</span>
                                </td>
                                <td>
                                    <span class="price">¥${book.currprice}</span>
                                </td>
                                <td>
                                    <span class="discount-badge">
                                      <c:choose>
                                          <c:when test="${not empty book.discount and book.discount > 0}">
                                              ${book.discount}折
                                          </c:when>
                                          <c:when test="${not empty book.currprice and not empty book.price and book.price > 0 and book.currprice != '' and book.price != ''}">
                                              <c:set var="discountStr" value=""/>
                                              <c:if test="${book.currprice ne null and book.price ne null and book.price > 0}">
                                                  <c:set var="discountStr" value="${book.currprice * 10 / book.price}"/>
                                              </c:if>
                                              <c:choose>
                                                  <c:when test="${not empty discountStr and fn:replace(fn:replace(discountStr, '.', ''), '-', '').matches('[0-9]+')}">
                                                      ${fn:substringBefore(discountStr + '.', '.')}.${fn:substring(fn:substringAfter(discountStr + '.', '.'), 0, 1)}折
                                                  </c:when>
                                                  <c:otherwise>
                                                      无折扣
                                                  </c:otherwise>
                                              </c:choose>
                                          </c:when>
                                          <c:otherwise>
                                              无折扣
                                          </c:otherwise>
                                      </c:choose>
                                    </span>
                                </td>
                                <td>${book.publishtime}</td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <a href="<c:url value='/admin/book/editPage?bid=${book.bid}'/>"
                                           class="btn btn-primary btn-sm">
                                            <i class="fas fa-edit mr-1"></i>编辑
                                        </a>
                                        <a href="<c:url value='/admin/book/delete?bid=${book.bid}'/>"
                                           onclick="return confirm('确定要删除这本书吗？')"
                                           class="btn btn-danger btn-sm">
                                            <i class="fas fa-trash-alt mr-1"></i>删除
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>

            <!-- 分页 -->
            <div>
                <ul class="pagination">
                    <c:if test="${pageInfo.hasPreviousPage}">
                        <li>
                            <a href="<c:url value='/admin/book/list?pageNum=1&bname=${book.bname}&author=${book.author}&press=${book.press}'/>">首页</a>
                        </li>
                        <li>
                            <a href="<c:url value='/admin/book/list?pageNum=${pageInfo.prePage}&bname=${book.bname}&author=${book.author}&press=${book.press}'/>">上一页</a>
                        </li>
                    </c:if>

                    <c:forEach items="${pageInfo.navigatepageNums}" var="nav">
                        <li class="${nav == pageInfo.pageNum ? 'active' : ''}">
                            <a href="<c:url value='/admin/book/list?pageNum=${nav}&bname=${book.bname}&author=${book.author}&press=${book.press}'/>">${nav}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${pageInfo.hasNextPage}">
                        <li>
                            <a href="<c:url value='/admin/book/list?pageNum=${pageInfo.nextPage}&bname=${book.bname}&author=${book.author}&press=${book.press}'/>">下一页</a>
                        </li>
                        <li>
                            <a href="<c:url value='/admin/book/list?pageNum=${pageInfo.pages}&bname=${book.bname}&author=${book.author}&press=${book.press}'/>">末页</a>
                        </li>
                    </c:if>
                </ul>
                <div class="text-center mt-2">
                    共 ${pageInfo.total} 条记录,
                    第 ${pageInfo.pageNum} 页 /
                    共 ${pageInfo.pages} 页
                </div>
            </div>
        </div>
    </div>
</main>

<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 页面加载时再次检查登录状态（防止session过期后的页面显示问题）
    if (!('${admin}' && '${admin.adminname}')) {
        window.location.href = '<c:url value="/admin/loginPage"/>';
    }

    $(document).ready(function () {
        // 侧边栏切换
        $('.menu-toggle').click(function () {
            $('.sidebar').toggleClass('active');
            $('.content-wrapper').toggleClass('sidebar-active');
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

        // 添加工具提示功能
        $('[title]').each(function () {
            const title = $(this).attr('title');
            $(this).attr('data-tooltip', 'true');
            $(this).append('<span class="tooltip">' + title + '</span>');
            $(this).removeAttr('title');
        });

        // 添加点击波纹效果
        $(document).on('click', '.logout-link', function (e) {
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