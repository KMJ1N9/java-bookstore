$(function () {
    /*
     * 1. 原代码尝试为按钮设置图片，但按钮元素不支持src属性，已移除
     */

    /*
     * 2. 给表单添加submit()事件，完成表单校验
     */
    $("#loginForm").submit(function () {
        $("#msg").text("");
        var bool = true;

        // 验证所有字段
        $(this).find(".input").each(function () {
            var inputName = $(this).attr("name");
            if (!invokeValidateFunction(inputName)) {
                bool = false;
            }
        });

        return bool;
    });

    /*
     * 3. 输入框得到焦点时隐藏错误信息
     */
    $("#loginname, #loginpass").focus(function () {
        var inputName = $(this).attr("name");
        $("#" + inputName + "Error").css("display", "none");
    });

    /*
     * 4. 输入框推动焦点时进行校验
     */
    $("#loginname, #loginpass").blur(function () {
        var inputName = $(this).attr("name");
        invokeValidateFunction(inputName);
    });
});

/*
 * 输入input名称，调用对应的validate方法。
 * 例如input名称为：loginname，那么调用validateLoginname()方法。
 */
function invokeValidateFunction(inputName) {
    inputName = inputName.substring(0, 1).toUpperCase() + inputName.substring(1);
    var functionName = "validate" + inputName;
    return eval(functionName + "()");
}

/*
 * 校验登录名
 */
function validateLoginname() {
    var bool = true;
    $("#loginnameError").css("display", "none");
    var value = $("#loginname").val();
    if (!value) {// 非空校验
        $("#loginnameError").css("display", "");
        $("#loginnameError").text("用户名不能为空！");
        bool = false;
    } else if (value.length < 3 || value.length > 20) {//长度校验
        $("#loginnameError").css("display", "");
        $("#loginnameError").text("用户名长度必须在3 ~ 20之间！");
        bool = false;
    }
    return bool;
}

/*
 * 校验密码
 */
function validateLoginpass() {
    var bool = true;
    $("#loginpassError").css("display", "none");
    var value = $("#loginpass").val();
    if (!value) {// 非空校验
        $("#loginpassError").css("display", "");
        $("#loginpassError").text("密码不能为空！");
        bool = false;
    } else if (value.length < 8) {//长度校验
        $("#loginpassError").css("display", "");
        $("#loginpassError").text("密码必须至少8位，且同时包含字母和数字！");
        bool = false;
    } else {
        // 检查是否包含字母和数字
        var hasLetter = /[a-zA-Z]/.test(value);
        var hasDigit = /\d/.test(value);
        if (!hasLetter || !hasDigit) {
            $("#loginpassError").css("display", "");
            $("#loginpassError").text("密码必须至少8位，且同时包含字母和数字！");
            bool = false;
        }
    }
    return bool;
}