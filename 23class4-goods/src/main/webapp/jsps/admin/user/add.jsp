<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>
<html>
<head>
    <title>添加用户</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/admin/add.css'/>">
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
            position: relative; /* 为错误提示定位做准备 */
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

        .btn:hover {
            background-color: #407c2d;
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

        /* 错误提示样式 */
        .errorMsg {
            color: red;
            font-size: 12px;
            margin-left: 115px;
            display: block; /* 独占一行，提升可读性 */
            margin-top: 5px;
        }
    </style>
</head>
<body>
<!-- 标题区域 -->
<div class="divTitle">
    <span>添加用户</span>
</div>

<!-- 表单容器 -->
<div class="formDiv">
    <form action="${pageContext.request.contextPath}/admin/user/add" method="post">
        <gg:token/>
        <!-- 用户名 -->
        <div class="formItem">
            <label for="loginname">用户名：</label>
            <input type="text"
                   id="loginname"
                   name="loginname"
                   class="textInput"
                   required/>
            <c:if test="${not empty errorMsg}">
                <span class="errorMsg">${errorMsg}</span>
            </c:if>
        </div>

        <!-- 密码 -->
        <div class="formItem">
            <label for="loginpass">密码：</label>
            <input type="password"
                   id="loginpass"
                   name="loginpass"
                   class="textInput"
                   required/>
        </div>

        <!-- 邮箱 -->
        <div class="formItem">
            <label for="email">邮箱：</label>
            <input type="email"
                   id="email"
                   name="email"
                   class="textInput"
                   required/>
        </div>

        <!-- 状态选择 -->
        <div class="formItem">
            <label for="status">状态：</label>
            <select id="status" name="status" class="textInput">
                <option value="0">未激活</option>
                <option value="1">已激活</option>
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