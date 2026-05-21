<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>重置密码 - 图书商城</title>
    <script type="text/javascript">
        // 表单验证
        function validateForm() {
            var verificationCode = document.getElementById("verificationCode").value;
            var newPassword = document.getElementById("newPassword").value;
            var confirmPassword = document.getElementById("confirmPassword").value;

            // 验证码验证
            if (!verificationCode) {
                alert("请输入验证码");
                return false;
            }

            // 密码验证（至少8位，包含字母和数字）
            var passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$/;
            if (!newPassword) {
                alert("请输入新密码");
                return false;
            }
            if (!passwordPattern.test(newPassword)) {
                alert("密码必须至少8位，包含字母和数字");
                return false;
            }

            // 确认密码验证
            if (newPassword !== confirmPassword) {
                alert("两次输入的密码不一致");
                return false;
            }

            return true;
        }
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
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
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

        .error {
            color: #D8000C;
            background-color: #FFD2D2;
            padding: 8px;
            border-radius: 4px;
            margin-top: 5px;
            display: none;
        }

        .password-hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            font-style: italic;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>重置密码</h1>

    <form action="${pageContext.request.contextPath}/user/doResetPassword" method="post"
          onsubmit="return validateForm();">
        <input type="hidden" name="token" value="${token}">
        <gg:token/>

        <div class="form-group">
            <label for="verificationCode">验证码（邮件中获取）</label>
            <input type="text" id="verificationCode" name="verificationCode" placeholder="请输入6位数字验证码" required
                   maxlength="6">
            <div id="codeError" class="error">请输入有效的验证码</div>
        </div>

        <div class="form-group">
            <label for="newPassword">新密码</label>
            <input type="password" id="newPassword" name="newPassword" placeholder="请设置新密码" required>
            <div class="password-hint">密码必须至少8位，包含字母和数字</div>
            <div id="passwordError" class="error">密码格式不正确</div>
        </div>

        <div class="form-group">
            <label for="confirmPassword">确认新密码</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="请再次输入新密码" required>
            <div id="confirmError" class="error">两次输入的密码不一致</div>
        </div>

        <input type="submit" class="btn-submit" value="确认重置密码">
    </form>

    <div class="link">
        <a href="${pageContext.request.contextPath}/jsps/user/login.jsp">返回登录</a>
        <span> | </span>
        <a href="${pageContext.request.contextPath}/user/forgotPassword">重新获取重置链接</a>
    </div>
</div>
</body>
</html>