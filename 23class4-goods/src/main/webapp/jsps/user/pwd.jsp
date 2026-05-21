<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>pwd.jsp</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <!--
    <link rel="stylesheet" type="text/css" href="styles.css">
    -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/css.css'/>">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/user/pwd.css'/>">
    <script type="text/javascript" src="<c:url value='/jquery/jquery-1.5.1.js'/>"></script>
    <script src="<c:url value='/js/common.js'/>"></script>
    <script type="text/javascript">
        // 密码格式验证函数
        function validatePassword(password) {
            // 密码要求：至少8位，包含字母和数字
            if (!password) {
                return {valid: false, message: '请输入密码'};
            }
            if (password.length < 8) {
                return {valid: false, message: '密码长度至少8位'};
            }
            var hasLetter = /[a-zA-Z]/.test(password);
            var hasDigit = /\d/.test(password);
            if (!hasLetter || !hasDigit) {
                return {valid: false, message: '密码必须同时包含字母和数字'};
            }
            return {valid: true, message: ''};
        }

        // 初始化验证码图片和密码验证
        $(function () {
            _change();

            // 新密码输入框实时验证
            $('#newPassword').on('input blur', function () {
                var password = $(this).val();
                var result = validatePassword(password);
                var errorElement = $('#newpassError');

                if (password) { // 只有当用户输入内容时才显示错误提示
                    if (!result.valid) {
                        errorElement.text(result.message).show();
                    } else {
                        errorElement.text('').hide();
                    }
                } else {
                    errorElement.text('').hide();
                }
            });

            // 确认密码验证
            $('#confirmPassword').on('input blur', function () {
                var newPass = $('#newPassword').val();
                var confirmPass = $(this).val();
                var errorElement = $('#reloginpassError');

                if (confirmPass) { // 只有当用户输入内容时才显示错误提示
                    if (newPass !== confirmPass) {
                        errorElement.text('两次输入的密码不一致').show();
                    } else {
                        errorElement.text('').hide();
                    }
                } else {
                    errorElement.text('').hide();
                }
            });

            // 表单提交前验证
            $('form').on('submit', function () {
                var newPass = $('#newPassword').val();
                var confirmPass = $('#confirmPassword').val();
                var isValid = true;

                // 验证新密码格式
                var passResult = validatePassword(newPass);
                if (!passResult.valid) {
                    $('#newpassError').text(passResult.message).show();
                    isValid = false;
                }

                // 验证确认密码
                if (newPass !== confirmPass) {
                    $('#reloginpassError').text('两次输入的密码不一致').show();
                    isValid = false;
                }

                return isValid;
            });
        });
    </script>
</head>

<body>
<div class="div0">
    <span>修改密码</span>
</div>

<div class="div1">
    <form action="<c:url value='/user/updatePassword'/>" method="post" target="_top">
        <gg:token/>
        <table>
            <tr>
                <td><label class="error">${msg }</label></td>
                <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td align="right">原密码:</td>
                <td><input class="input" type="password" name="oldPassword" id="oldPassword" value=""/></td>
                <td><label id="loginpassError" class="error"></label></td>
            </tr>
            <tr>
                <td align="right">新密码:</td>
                <td>
                    <input class="input" type="password" name="newPassword" id="newPassword" value=""/>
                    <br/>
                    <span class="hint">密码必须至少8位，且同时包含字母和数字</span>
                </td>
                <td><label id="newpassError" class="error"></label></td>
            </tr>
            <tr>
                <td align="right">确认密码:</td>
                <td><input class="input" type="password" name="confirmPassword" id="confirmPassword" value=""/></td>
                <td><label id="reloginpassError" class="error"></label></td>
            </tr>
            <tr>
                <td align="right"></td>
                <td>
                    <img id="vCode" src="" border="1"/>
                    <a href="javascript:_change();">看不清，换一张</a>
                </td>
            </tr>
            <tr>
                <td align="right">验证码:</td>
                <td>
                    <input class="input" type="text" name="verifyCode" id="verifyCode" value=""/>
                </td>
                <td><label id="verifyCodeError" class="error"></label></td>
            </tr>
            <tr>
                <td align="right"></td>
                <td><input id="submit" type="submit" value="修改密码"/></td>
            </tr>
        </table>
    </form>
</div>
</body>
</html>

