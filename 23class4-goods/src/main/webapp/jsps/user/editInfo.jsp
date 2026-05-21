<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑个人资料 - 网上书店</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/css.css'/>">
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
            margin-bottom: 30px;
        }

        .avatar-section {
            text-align: center;
            margin: 20px 0 40px 0;
        }

        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e5e5e5;
            margin-bottom: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: inline-block;
            width: 100px;
            text-align: right;
            padding-right: 20px;
            font-weight: bold;
            color: #666;
        }

        .form-group input[type="text"],
        .form-group input[type="email"] {
            width: 300px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-group input[type="text"]:disabled {
            background-color: #f5f5f5;
            cursor: not-allowed;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px 5px;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s;
            border: none;
        }

        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }

        .btn-primary:hover {
            background-color: #45a049;
        }

        .btn-secondary {
            background-color: #f44336;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #da190b;
        }

        .btn-upload {
            background-color: #2196F3;
            color: white;
        }

        .btn-upload:hover {
            background-color: #0b7dda;
        }

        .button-group {
            text-align: center;
            margin-top: 30px;
        }

        .avatar-upload-form {
            margin-top: 10px;
        }

        .error {
            color: #f44336;
            margin-left: 120px;
            font-size: 12px;
        }
    </style>
    <script type="text/javascript" src="<c:url value='/jquery/jquery-1.5.1.js'/>"></script>
    <script type="text/javascript">
        $(function () {
            // 表单验证
            $('#infoForm').submit(function () {
                var email = $('#email').val();
                var isValid = true;

                // 验证邮箱
                if (email == '') {
                    $('#emailError').text('请输入邮箱地址');
                    isValid = false;
                } else if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
                    $('#emailError').text('邮箱格式不正确');
                    isValid = false;
                } else {
                    $('#emailError').text('');
                }

                return isValid;
            });

            // 头像文件预览
            $('#avatarFile').change(function () {
                var file = this.files[0];
                if (file) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        $('#previewAvatar').attr('src', e.target.result);
                    }
                    reader.readAsDataURL(file);
                }
            });
        });
    </script>
</head>
<body>
<div class="container">
    <h2>编辑个人资料</h2>

    <c:if test="${user != null}">
        <!-- 头像上传部分 -->
        <div class="avatar-section">
            <c:choose>
                <c:when test="${user.avatar != null && user.avatar != ''}">
                    <img id="previewAvatar" src="${pageContext.request.contextPath}${user.avatar}" alt="用户头像"
                         class="avatar">
                </c:when>
                <c:otherwise>
                    <img id="previewAvatar" src="${pageContext.request.contextPath}/images/default-avatar.jpg"
                         alt="默认头像" class="avatar">
                </c:otherwise>
            </c:choose>
            <form class="avatar-upload-form" action="${pageContext.request.contextPath}/user/uploadAvatar" method="post"
                  enctype="multipart/form-data">
                <gg:token/>
                <input type="file" name="avatarFile" id="avatarFile" accept="image/*">
                <button type="submit" class="btn btn-upload">上传头像</button>
            </form>
        </div>

        <!-- 个人信息编辑表单 -->
        <form id="infoForm" action="${pageContext.request.contextPath}/user/updateInfo" method="post">
            <gg:token/>
            <div class="form-group">
                <label for="loginname">用户名：</label>
                <input type="text" id="loginname" name="loginname" value="${user.loginname}" disabled="disabled">
            </div>
            <div class="form-group">
                <label for="email">邮箱：</label>
                <input type="email" id="email" name="email" value="${user.email}">
                <span id="emailError" class="error">${emailError}</span>
            </div>
            <div class="form-group">
                <label for="status">用户状态：</label>
                <input type="text" id="status"
                       value="<c:choose><c:when test="${user.status == 0}">未激活</c:when><c:when test="${user.status == 1}">已激活</c:when><c:otherwise>未知</c:otherwise></c:choose>"
                       disabled="disabled">
            </div>
            <div class="button-group">
                <button type="submit" class="btn btn-primary">保存修改</button>
                <button type="button" class="btn btn-secondary"
                        onclick="location.href='${pageContext.request.contextPath}/user/info'">取消
                </button>
            </div>
        </form>
    </c:if>
    <
    <c:if test="${user == null}">
        <div style="text-align: center; padding: 50px;">
            <p>请先登录！</p>
            <a href="${pageContext.request.contextPath}/jsps/user/login.jsp" class="btn btn-primary">去登录</a>
        </div>
    </c:if>
</div>
</body>
</html>