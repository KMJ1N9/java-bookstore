<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>


<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>会员登录 - 网上书城</title>
    <meta name="description" content="欢迎登录网上书城，享受便捷的购书体验">

    <!-- 引入CSS样式 -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/user/login.css'/>">

    <!-- 引入JavaScript库 -->
    <script type="text/javascript" src="<c:url value='/jquery/jq.js'/>" defer></script>
    <script src="<c:url value='/js/common.js'/>" defer></script>
    <script type="text/javascript" src="<c:url value='/js/user/login.js'/>" defer></script>
</head>

<body>
<div class="main">
    <!-- 左侧图片区域 -->
    <div class="imageDiv">
        <img class="img" src="<c:url value='/images/zj.png'/>" alt="网上书城">
    </div>

    <!-- 右侧登录表单区域 -->
    <div class="login1">
        <div class="login2">
            <!-- 登录标题区域 -->
            <div class="loginTopDiv">
                <span class="loginTop">会员登录</span>
                <a href="<c:url value='/jsps/user/regist.jsp'/>" class="registBtn">立即注册</a>
            </div>

            <!-- 登录表单 -->
            <form target="_top" action="<c:url value='/user/login'/>" method="post" id="loginForm">
                <input type="hidden" name="method" value=""/>
                <gg:token/>

                <!-- 错误信息显示区域 -->
                <div id="msg" class="error-message">${err_msg}</div>

                <!-- 用户名输入区域 -->
                <div class="form-group">
                    <label for="loginname" class="form-label">用户名</label>
                    <div class="form-input-wrapper">
                        <input
                                class="input"
                                type="text"
                                name="loginname"
                                id="loginname"
                                placeholder="请输入用户名"
                                required
                        />
                    </div>
                    <label id="loginnameError" class="error"></label>
                </div>

                <!-- 密码输入区域 -->
                <div class="form-group">
                    <label for="loginpass" class="form-label">密码</label>
                    <div class="form-input-wrapper">
                        <input
                                class="input"
                                type="password"
                                name="loginpass"
                                id="loginpass"
                                placeholder="请输入密码"
                                required
                        />
                    </div>
                    <label id="loginpassError" class="error"></label>
                </div>

                <!-- 登录按钮 -->
                <div class="form-group form-actions">
                    <button type="submit" id="submit" class="loginBtn">登录</button>
                </div>

                <!-- 忘记密码链接 -->
                <div class="form-footer">
                    <a href="<c:url value='/user/forgotPassword'/>" class="forgotPassword">忘记密码?</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>