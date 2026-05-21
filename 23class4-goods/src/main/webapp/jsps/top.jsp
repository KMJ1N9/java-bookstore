<%@ page language="java" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>top</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <meta http-equiv="content-type" content="text/html;charset=utf-8">
    <!--
    <link rel="stylesheet" type="text/css" href="styles.css">
    -->
    <style type="text/css">
        body {
            background: #15B69A;
            margin: 0px;
            color: #ffffff;
        }

        a {
            text-transform: none;
            text-decoration: none;
            color: #ffffff;
            font-weight: 900;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
<h1 style="text-align: center;">网上书城系统</h1>
<div style="font-size: 10pt; line-height: 10px;">
    <%--
        Tomcat服务器有一个缓存叫Session，一人一份，只要你访问了我当前网站任意资源，、
        Tomcat服务器就自动创建一个缓存对象叫Session（HttpSession），30分钟你没有任何操作或者
        关闭浏览器，杀死Session。当然我也可以用代码杀死Session，session.invalidate();
        其实就是我们用户退出功能的实现（本质就是杀死Session）

        潜规则，在单体应用中，用户登录成功后，必须往Session域放一个满值（从MySQL查回来）User对象。

    --%>
    <c:if test="${empty user}">
        <a href="<c:url value='/jsps/user/login.jsp'/>" target="_parent">会员登录</a> |&nbsp;
        <a href="<c:url value='/jsps/user/regist.jsp'/>" target="_parent">注册会员</a>
        &nbsp;&nbsp;|&nbsp;&nbsp;
        <a href="<c:url value='/admin/loginPage'/>" target="_blank">管理员登录</a>
    </c:if>
    <c:if test="${not empty  user}">
        会员：${user.loginname}&nbsp;&nbsp;|&nbsp;&nbsp;
        <%--select  *  from  cartitem where uid = ?--%>
        <a href="<c:url value='/cart/getCartitemsByUid?uid=${user.uid}'/>" target="body">我的购物车</a>&nbsp;&nbsp;|&nbsp;&nbsp;
        <a href="<c:url value='/order/myOrders'/>" target="body">我的订单</a>&nbsp;&nbsp;|&nbsp;&nbsp;
        <a href="<c:url value='/jsps/user/pwd.jsp'/>" target="body">修改密码</a>&nbsp;&nbsp;|&nbsp;&nbsp;
        <a href="javascript:dengchu()" target="_parent">退出</a>

    </c:if>

</div>
</body>
</html>

