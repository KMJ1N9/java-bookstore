<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 商品管理系统</title>
    <link href="/goods/css/user/regist.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript">
        // 切换验证码
        function changeImg() {
            document.getElementById("imgVerifyCode").src = "/goods/user/createVerifycode?a=" + new Date().getTime();
        }

        // 表单验证
        function checkForm() {
            // 验证用户名
            var username = document.getElementById("username").value;
            if (username == "") {
                document.getElementById("usernameError").innerHTML = "请输入用户名！";
                return false;
            }

            // 用户名格式验证：只能包含字母、数字和下划线，长度3-20位
            var usernameReg = /^[a-zA-Z0-9_]{3,20}$/;
            if (!usernameReg.test(username)) {
                document.getElementById("usernameError").innerHTML = "用户名格式不正确，只能包含字母、数字和下划线，长度3-20位！";
                return false;
            }

            // 验证密码
            var password = document.getElementById("password").value;
            if (password == "") {
                document.getElementById("passwordError").innerHTML = "请输入密码！";
                return false;
            }
            if (password.length < 6) {
                document.getElementById("passwordError").innerHTML = "密码长度不能少于6位！";
                return false;
            }

            // 验证确认密码
            var repassword = document.getElementById("repassword").value;
            if (repassword == "") {
                document.getElementById("repasswordError").innerHTML = "请输入确认密码！";
                return false;
            }
            if (password != repassword) {
                document.getElementById("repasswordError").innerHTML = "两次输入的密码不一致！";
                return false;
            }

            // 验证邮箱
            var email = document.getElementById("email").value;
            if (email == "") {
                document.getElementById("emailError").innerHTML = "请输入邮箱！";
                return false;
            }

            // 验证邮箱格式
            var emailReg = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailReg.test(email)) {
                document.getElementById("emailError").innerHTML = "邮箱格式不正确！";
                return false;
            }

            // 验证验证码
            var verifyCode = document.getElementById("verifyCode").value;
            if (verifyCode == "") {
                document.getElementById("verifyCodeError").innerHTML = "请输入验证码！";
                return false;
            }

            return true;
        }

        // 清除错误提示
        function clearError(errorId) {
            document.getElementById(errorId).innerHTML = "";
        }
    </script>
</head>
<body>
<div id="divMain">
    <div id="divTitle">
        <span id="spanTitle">会员注册</span>
    </div>
    <div id="divBody">
        <form action="/goods/user/regist" method="post" onsubmit="return checkForm()">
            <!-- CSRF令牌字段 -->
            <input type="hidden" name="_csrf_token" value="${CSRF_TOKEN}">
            <!-- 用户名输入区域 -->
            <div class="form-group">
                <div class="tdText">用户名:</div>
                <div class="tdInput">
                    <input type="text" id="username" name="loginname" class="inputClass" placeholder="请输入用户名"
                           onblur="clearError('usernameError')"/>
                </div>
                <div class="tdError" id="usernameError">${userRegistError.usernameError}</div>
            </div>
            <!-- 密码输入区域 -->
            <div class="form-group">
                <div class="tdText">密码:</div>
                <div class="tdInput">
                    <input type="password" id="password" name="loginpass" class="inputClass" placeholder="请输入密码"
                           onblur="clearError('passwordError')"/>
                </div>
                <div class="tdError" id="passwordError">${userRegistError.passwordError}</div>
            </div>
            <!-- 确认密码输入区域 -->
            <div class="form-group">
                <div class="tdText">确认密码:</div>
                <div class="tdInput">
                    <input type="password" id="repassword" name="repassword" class="inputClass"
                           placeholder="请再次输入密码"
                           onblur="clearError('repasswordError')"/>
                </div>
                <div class="tdError" id="repasswordError">${userRegistError.repasswordError}</div>
            </div>
            <!-- 邮箱输入区域 -->
            <div class="form-group">
                <div class="tdText">邮箱:</div>
                <div class="tdInput">
                    <input type="text" id="email" name="email" class="inputClass" placeholder="请输入邮箱"
                           onblur="clearError('emailError')"/>
                </div>
                <div class="tdError" id="emailError">${userRegistError.emailError}</div>
            </div>
            <!-- 验证码输入区域 -->
            <div class="form-group">
                <div class="tdText">验证码:</div>
                <div class="tdInput">
                    <div id="tdVerifyCode">
                        <input type="text" id="verifyCode" name="verifyCode" class="inputClass"
                               placeholder="请输入验证码"
                               style="flex: 1;" onblur="clearError('verifyCodeError')"/>
                        <div id="divVerifyCode">
                            <img id="imgVerifyCode" alt="验证码" src="/goods/user/createVerifycode"
                                 onclick="changeImg()"/>
                        </div>
                    </div>
                </div>
                <div class="tdError" id="verifyCodeError">
                    ${userRegistError.verifyCodeError}
                    <a onclick="changeImg()">换一张</a>
                </div>
            </div>
            <!-- 提交按钮 -->
            <div class="form-group">
                <button type="submit" id="submitBtn">注册</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>