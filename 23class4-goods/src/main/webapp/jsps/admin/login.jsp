<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员登录 - 商品管理系统</title>
    <meta name="description" content="商品管理系统管理员登录页面">
    <meta name="keywords" content="管理员登录,商品管理系统,后台管理">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">

    <!-- 引入管理员登录样式 -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/admin/login.css'/>">
</head>

<body>
<div class="main">
    <div class="loginDiv">
        <div class="loginFormDiv">
            <h2>管理员登录</h2>

            <form action="<c:url value='/admin/login'/>" method="post" id="loginForm">
                <gg:token/>
                <c:if test="${not empty msg}">
                    <span class="errorMsg">${msg}</span>
                </c:if>

                <div class="form-group">
                    <label for="adminname">管理员用户名</label>
                    <input type="text" id="adminname" name="adminname" value="${admin.adminname}"
                           placeholder="请输入管理员用户名" required>
                </div>

                <div class="form-group">
                    <label for="adminpwd">密码</label>
                    <input type="password" id="adminpwd" name="adminpwd" placeholder="请输入密码" required>
                </div>

                <div class="form-group submit-group">
                    <input type="submit" value="登录">
                    <input type="reset" value="重置">
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>