<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>忘记密码 - 图书商城</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/user/forgotPassword.css">
    <script type="text/javascript">
        // 表单验证
        function validateForm() {
            var email = document.getElementById("email").value;
            if (!email) {
                alert("请输入邮箱地址");
                return false;
            }
            // 简单的邮箱格式验证
            var emailPattern = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/;
            if (!emailPattern.test(email)) {
                alert("请输入有效的邮箱地址");
                return false;
            }
            return true;
        }

        // 显示消息后5秒自动隐藏
        window.onload = function () {
            var msg = '${msg}';
            if (msg) {
                var msgDiv = document.createElement('div');
                msgDiv.className = 'message';
                msgDiv.innerHTML = msg;
                document.body.insertBefore(msgDiv, document.body.firstChild);
                setTimeout(function () {
                    msgDiv.style.display = 'none';
                }, 5000);
            }
        };
    </script>
    <style type="text/css">
        body {
            font-family: "Microsoft YaHei", Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 100%;
            max-width: 500px;
            margin: 50px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            font-size: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: bold;
        }

        input[type="text"],
        input[type="email"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }

        input[type="text"]:focus,
        input[type="email"]:focus {
            outline: none;
            border-color: #4A90E2;
            box-shadow: 0 0 5px rgba(74, 144, 226, 0.3);
        }

        .btn-submit {
            width: 100%;
            padding: 12px;
            background-color: #4A90E2;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-submit:hover {
            background-color: #357ABD;
        }

        .link {
            text-align: center;
            margin-top: 20px;
        }

        .link a {
            color: #4A90E2;
            text-decoration: none;
        }

        .link a:hover {
            text-decoration: underline;
        }

        .message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>忘记密码</h1>

    <!-- 显示消息 -->
    <c:if test="${not empty msg}">
        <div class="message">${msg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/user/sendResetEmail" method="post"
          onsubmit="return validateForm();">
        <div class="form-group">
            <label for="email">邮箱地址</label>
            <input type="email" id="email" name="email" placeholder="请输入您注册时使用的邮箱" required>
        </div>
        <gg:token/>
        <input type="submit" class="btn-submit" value="发送重置密码邮件">
    </form>

    <div class="link">
        <a href="${pageContext.request.contextPath}/jsps/user/login.jsp">返回登录</a>
        <span> | </span>
        <a href="${pageContext.request.contextPath}/jsps/user/regist.jsp">注册账号</a>
    </div>
</div>
</body>
</html>

