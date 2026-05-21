<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户信息 - 网上书店</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 50px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #333;
            text-align: center;
            border-bottom: 2px solid #e5e5e5;
            padding-bottom: 10px;
        }

        .user-info {
            margin: 20px 0;
        }

        .info-item {
            display: flex;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-label {
            width: 100px;
            font-weight: bold;
            color: #666;
        }

        .info-value {
            flex: 1;
            color: #333;
        }

        .avatar-container {
            display: flex;
            justify-content: center;
            margin: 20px 0;
        }

        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e5e5e5;
        }

        .btn {
            display: inline-block;
            padding: 8px 20px;
            margin: 10px 5px;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-primary {
            background-color: #4CAF50;
            color: white;
            border: none;
        }

        .btn-primary:hover {
            background-color: #45a049;
        }

        .btn-secondary {
            background-color: #f44336;
            color: white;
            border: none;
        }

        .btn-secondary:hover {
            background-color: #da190b;
        }

        .button-group {
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>用户信息</h2>

    <c:if test="${user != null}">
        <div class="avatar-container">
            <c:choose>
                <c:when test="${user.avatar != null && user.avatar != ''}">
                    <img src="${pageContext.request.contextPath}${user.avatar}" alt="用户头像" class="avatar">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/images/default-avatar.jpg" alt="默认头像"
                         class="avatar">
                </c:otherwise>
            </c:choose>
        </div>

        <div class="user-info">
            <div class="info-item">
                <span class="info-label">用户名：</span>
                <span class="info-value">${user.loginname}</span>
            </div>
            <div class="info-item">
                <span class="info-label">邮箱：</span>
                <span class="info-value">${user.email}</span>
            </div>
            <div class="info-item">
                <span class="info-label">用户状态：</span>
                <span class="info-value">
                        <c:choose>
                            <c:when test="${user.status == 0}">未激活</c:when>
                            <c:when test="${user.status == 1}">已激活</c:when>
                            <c:otherwise>未知</c:otherwise>
                        </c:choose>
                    </span>
            </div>
        </div>

        <div class="button-group">
            <button class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/user/editInfo'">
                编辑个人资料
            </button>
            <button class="btn btn-secondary"
                    onclick="location.href='${pageContext.request.contextPath}/user/password'">修改密码
            </button>
        </div>
    </c:if>

    <c:if test="${user == null}">
        <div style="text-align: center; padding: 50px;">
            <p>请先登录！</p>
            <a href="${pageContext.request.contextPath}/jsps/user/login.jsp" class="btn btn-primary">去登录</a>
        </div>
    </c:if>
</div>
</body>
</html>