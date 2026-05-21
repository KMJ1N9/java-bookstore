<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>
<html>
<head>
    <title>编辑用户</title>
    <link type="text/css" rel="stylesheet" href="/css/style.css">
    <style type="text/css">
        /* 标题区域样式 */
        .divTitle {
            background-color: #508e37;
            width: 100%;
            height: 35px;
            margin-bottom: 10px;
        }

        .divTitle span {
            color: white;
            font-weight: bold;
            line-height: 35px;
            margin-left: 10px;
        }

        /* 表单容器样式 */
        .formDiv {
            margin: 20px auto;
            width: 500px;
        }

        /* 表单项样式 */
        .formItem {
            margin: 15px 0;
        }

        .formItem label {
            display: inline-block;
            width: 100px;
            text-align: right;
            margin-right: 10px;
        }

        /* 输入框通用样式 */
        .textInput {
            width: 300px;
            padding: 5px;
            box-sizing: border-box; /* 统一盒模型，避免宽度溢出 */
        }

        /* 按钮样式 */
        .btn {
            background-color: #508e37;
            color: white;
            border: none;
            padding: 5px 15px;
            cursor: pointer;
            border-radius: 3px;
            margin-right: 10px;
        }

        .btnCancel {
            background-color: #cccccc;
            color: #333333;
        }

        .btnCancel:hover {
            background-color: #bbbbbb;
        }

        /* 按钮区域样式 */
        .formButton {
            text-align: center;
            margin-top: 20px;
        }

        /* 密码提示样式 */
        .passwordNote {
            color: #666666;
            margin-left: 115px;
            font-size: 12px;
            margin-top: 5px; /* 增加间距，提升可读性 */
        }
    </style>
</head>
<body>
<!-- 标题区域 -->
<div class="divTitle">
    <span>编辑用户</span>
</div>

<!-- 表单容器 -->
<div class="formDiv">
    <form action="${pageContext.request.contextPath}/admin/user/update" method="post">
        <!-- 用户ID隐藏域 -->
        <input type="hidden" name="uid" value="${user.uid}"/>
        <gg:token/>

        <!-- 用户名 -->
        <div class="formItem">
            <label for="loginname">用户名：</label>
            <input type="text"
                   id="loginname"
                   name="loginname"
                   value="${user.loginname}"
                   class="textInput"
                   disabled/>
        </div>

        <!-- 密码 -->
        <div class="formItem">
            <label for="loginpass">密码：</label>
            <input type="password"
                   id="loginpass"
                   name="loginpass"
                   class="textInput"
                   placeholder="不修改请留空"/>
            <div class="passwordNote">不修改密码请留空</div>
        </div>

        <!-- 邮箱 -->
        <div class="formItem">
            <label for="email">邮箱：</label>
            <input type="email"
                   id="email"
                   name="email"
                   value="${user.email}"
                   class="textInput"
                   required/>
        </div>

        <!-- 状态选择 -->
        <div class="formItem">
            <label for="status">状态：</label>
            <select id="status" name="status" class="textInput">
                <option value="0" <c:if test="${user.status == 0}">selected</c:if>>未激活</option>
                <option value="1" <c:if test="${user.status == 1}">selected</c:if>>已激活</option>
            </select>
        </div>

        <!-- 表单按钮 -->
        <div class="formButton">
            <input type="submit" value="提交" class="btn"/>
            <a href="${pageContext.request.contextPath}/admin/user/list">
                <input type="button" value="取消" class="btn btnCancel"/>
            </a>
        </div>
    </form>
</div>
</body>
</html>