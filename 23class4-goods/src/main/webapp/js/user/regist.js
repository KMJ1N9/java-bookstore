function zhuce() {

    /*要把5个框的校验函数调用 并做与操作*/
    let bool = verify_loginname() && verify_loginpass() && verify_reloginpass() && verify_email() && verify_verifyCode();
    if (!bool) {
        alert("请核实表单!!!");
    }
    return bool;
}

/*页面初始化后，会自动调用下面的这个函数，相当于onload事件*/
$(function () {
    /*给注册按钮 注册一个hover事件*/
    /*hover 两个入参  分别是  移入、移出*/
    $("#submitBtn").hover(
        function () {
            /*移入*/
            $(this).attr("src", "/goods/images/regist2.jpg");
        }
        ,
        function () {
            /*移出*/
            $(this).attr("src", "/goods/images/regist1.jpg");
        }
    );
    /*1.隐藏所有的错误提示label*/
    $("#loginnameError").css({"display": "none"});
    $("#loginpassError").css({"display": "none"});
    $("#reloginpassError").css({"display": "none"});
    $("#emailError").css({"display": "none"});
    $("#verifyCodeError").css({"display": "none"});

    /*2.文本框丢失焦点后，对应的错误提示label要显示出来*/
    /*丢失焦点   事件  叫 blur*/
    $("#loginname").blur(function () {
        /*让对应的错误提示框label显示出来*/
        $("#loginnameError").css("display", "inline");
        /*调用校验函数*/
        verify_loginname();
    });

    $("#loginpass").blur(function () {
        $("#loginpassError").css("display", "inline");
        verify_loginpass();
    });

    $("#reloginpass").blur(function () {
        $("#reloginpassError").css("display", "inline");
        verify_reloginpass();
    });

    $("#email").blur(function () {
        $("#emailError").css("display", "inline");
        verify_email();
    });

    $("#verifyCode").blur(function () {
        $("#verifyCodeError").css("display", "inline");
        verify_verifyCode();
    });

    /*3.用户输入文本框的时候，文本框获取了焦点，要求对应的错误提示框 隐藏*/
    /*focus  获取焦点*/
    $("#loginname").focus(function () {
        $("#loginnameError").css("display", "none");
    });

    $("#loginpass").focus(function () {
        $("#loginpassError").css("display", "none");
    });

    $("#reloginpass").focus(function () {
        $("#reloginpassError").css("display", "none");
    });

    $("#email").focus(function () {
        $("#emailError").css("display", "none");
    });

    $("#verifyCode").focus(function () {
        $("#verifyCodeError").css("display", "none");
    });

    /*4.添加实时验证功能 - 用户输入时立即进行验证（除了用户名唯一性检查和验证码验证）*/
    $("#loginname").on('input', function () {
        let val = $(this).val();
        $("#loginnameError").css("display", "inline");

        // 基本验证 - 实时进行，但不进行Ajax验证
        if (val == "") {
            $("#loginnameError").addClass("errorClass").removeClass("rightClass");
            $("#loginnameError").text("用户名不能为空！");
            return false;
        }

        if (val.length < 3 || val.length > 20) {
            $("#loginnameError").addClass("errorClass").removeClass("rightClass");
            $("#loginnameError").text("用户名长度3到20之间");
            return false;
        }

        let reg = /^[a-zA-Z0-9_]+$/;
        if (!reg.test(val)) {
            $("#loginnameError").addClass("errorClass").removeClass("rightClass");
            $("#loginnameError").text("用户名只能包含字母、数字和下划线");
            return false;
        }

        // 基本验证通过，显示友好提示，但不进行唯一性检查（减少服务器压力）
        $("#loginnameError").text("格式正确，失焦后检查可用性");
        $("#loginnameError").removeClass("errorClass rightClass");
        return true;
    });

    $("#loginpass").on('input', function () {
        let val = $(this).val();
        $("#loginpassError").css("display", "inline");

        if (val == "") {
            $("#loginpassError").addClass("errorClass").removeClass("rightClass");
            $("#loginpassError").text("密码不能为空！");
            return false;
        }

        if (val.length < 8) {
            $("#loginpassError").addClass("errorClass").removeClass("rightClass");
            $("#loginpassError").text("密码必须至少8位，且同时包含字母和数字！");
            return false;
        }

        var hasLetter = /[a-zA-Z]/.test(val);
        var hasDigit = /\d/.test(val);
        if (!hasLetter || !hasDigit) {
            $("#loginpassError").addClass("errorClass").removeClass("rightClass");
            $("#loginpassError").text("密码必须至少8位，且同时包含字母和数字！");
            return false;
        }

        $("#loginpassError").text("通过！");
        $("#loginpassError").addClass("rightClass").removeClass("errorClass");
        return true;
    });

    $("#reloginpass").on('input', function () {
        let reloginpass = $(this).val();
        $("#reloginpassError").css("display", "inline");

        if (reloginpass == "") {
            $("#reloginpassError").addClass("errorClass").removeClass("rightClass");
            $("#reloginpassError").text("确认密码不能为空！");
            return false;
        }

        let loginpass = $("#loginpass").val();
        if (reloginpass != loginpass) {
            $("#reloginpassError").addClass("errorClass").removeClass("rightClass");
            $("#reloginpassError").text("两次密码输入不一致！");
            return false;
        }

        $("#reloginpassError").text("通过！");
        $("#reloginpassError").addClass("rightClass").removeClass("errorClass");
        return true;
    });

    $("#email").on('input', function () {
        let email = $(this).val();
        $("#emailError").css("display", "inline");

        if (email == "") {
            $("#emailError").addClass("errorClass").removeClass("rightClass");
            $("#emailError").text("邮箱不能为空！");
            return false;
        }

        let reg = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!reg.test(email)) {
            $("#emailError").addClass("errorClass").removeClass("rightClass");
            $("#emailError").text("邮箱格式不正确！");
            return false;
        }

        // 基本验证通过，显示友好提示，但不进行唯一性检查（减少服务器压力）
        $("#emailError").text("格式正确，失焦后检查可用性");
        $("#emailError").removeClass("errorClass rightClass");
        return true;
    });
});

/*5个校验函数*/
/*_后缀，取的是文本框id的值*/

/*校验用户名*/
function verify_loginname() {

    /*获取用户输入的值*/
    let val = $("#loginname").val();
    /*1.非空校验*/
    if (val == "") {
        /*错误提示信息的内容是  用户名不能为空*/
        $("#loginnameError").addClass("errorClass").removeClass("rightClass");
        $("#loginnameError").text("用户名不能为空！");
        return false;
    }
    /*2.长度校验,3-20位*/
    if (val.length < 3 || val.length > 20) {
        /*错误提示信息的内容是  用户名长度3~20之间*/
        $("#loginnameError").addClass("errorClass").removeClass("rightClass");
        $("#loginnameError").text("用户名长度3到20之间");
        return false;
    }
    /*3.字符类型校验，只能包含字母、数字和下划线*/
    let reg = /^[a-zA-Z0-9_]+$/;
    if (!reg.test(val)) {
        $("#loginnameError").addClass("errorClass").removeClass("rightClass");
        $("#loginnameError").text("用户名只能包含字母、数字和下划线");
        return false;
    }
    /*4.用户名是否可用（已存在不可用）  Ajax 页面局部刷新*/
    /*查数据库需要时间的，我们要死等这个结果，不能让JS代码还没等数据查回来就往下执行（不允许！）*/
    $.ajaxSettings.async = false;//死等结果
    /*参数1，请求路径*/
    /*参数2，请求参数*/
    /*参数3，你拿到值后你要做什么写到function里*/
    /*res 它就是后端给你返回来的结果，要求后端返回的是bool类型
    *   true 可用，  false 不可用（用户名已存在）
    * */
    let bool = false;
    $.post(
        "/goods/user/verifyLoginname",
        {"loginname": val},
        function (res) {
            if (res) {
                $("#loginnameError").text("恭喜，可用！");
                $("#loginnameError").addClass("rightClass").removeClass("errorClass");
                bool = true;
            } else {
                $("#loginnameError").text("用户名已存在！");
                $("#loginnameError").addClass("errorClass").removeClass("rightClass");
                bool = false;
            }
        }
    );
    return bool;

}

/*校验密码框*/
function verify_loginpass() {
    /*获取用户输入的密码*/
    let val = $("#loginpass").val();

    /*非空校验 */
    if (val == "") {
        $("#loginpassError").addClass("errorClass").removeClass("rightClass");
        $("#loginpassError").text("密码不能为空！");
        return false;
    }

    /*长度校验 至少8位*/
    if (val.length < 8) {
        $("#loginpassError").addClass("errorClass").removeClass("rightClass");
        $("#loginpassError").text("密码必须至少8位，且同时包含字母和数字！");
        return false;
    } else {
        // 检查是否包含字母和数字
        var hasLetter = /[a-zA-Z]/.test(val);
        var hasDigit = /\d/.test(val);
        if (!hasLetter || !hasDigit) {
            $("#loginpassError").addClass("errorClass").removeClass("rightClass");
            $("#loginpassError").text("密码必须至少8位，且同时包含字母和数字！");
            return false;
        }
    }

    $("#loginpassError").text("通过！");
    $("#loginpassError").addClass("rightClass").removeClass("errorClass");
    return true;
}

function verify_reloginpass() {
    /*获取值*/
    let reloginpass = $("#reloginpass").val();
    /*非空校验*/
    if (reloginpass == "") {
        $("#reloginpassError").addClass("errorClass").removeClass("rightClass");
        $("#reloginpassError").text("确认密码不能为空！");
        return false;
    }
    /*两次密码是否一致*/
    let loginpass = $("#loginpass").val();
    if (reloginpass != loginpass) {
        $("#reloginpassError").addClass("errorClass").removeClass("rightClass");
        $("#reloginpassError").text("两次密码输入不一致！");
        return false;
    }
    $("#reloginpassError").text("通过！");
    $("#reloginpassError").addClass("rightClass").removeClass("errorClass");
    return true;
}

function verify_email() {
    /*获取值*/
    let email = $("#email").val();
    /*非空校验*/
    if (email == "") {
        $("#emailError").addClass("errorClass").removeClass("rightClass");
        $("#emailError").text("邮箱不能为空！");
        return false;
    }
    /*格式校验  正则校验*/
    /*@@qq.@*/
    /*    /^[^\s@]+@[^\s@]+\.[^\s@]+$/;   */

    let reg = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!reg.test(email)) {
        $("#emailError").addClass("errorClass").removeClass("rightClass");
        $("#emailError").text("邮箱格式不正确！");
        return false;
    }
    /*判定Email是否已存在  Ajax*/
    let bool = false;
    $.post(
        "/goods/user/verifyEmail",
        {"email": email},
        function (res) {
            if (res) {
                $("#emailError").text("恭喜，可用！");
                $("#emailError").addClass("rightClass").removeClass("errorClass");
                bool = true;
            } else {
                $("#emailError").text("Email已存在！");
                $("#emailError").addClass("errorClass").removeClass("rightClass");
                bool = false;
            }
        }
    );
    return bool;


}

function verify_verifyCode() {
    /*1.获取用户输入的验证码：*/
    let val = $("#verifyCode").val();
    /*2.1 非空校验*/
    if (val == "") {
        $("#verifyCodeError").text("验证码不能为空！");
        $("#verifyCodeError").addClass("errorClass").removeClass("rightClass");
        return false;
    }
    /*2.2 长度校验 4位*/
    if (val.length != 4) {
        $("#verifyCodeError").text("验证码长度4位！");
        $("#verifyCodeError").addClass("errorClass").removeClass("rightClass");
        return false;
    }

    /*2.3.Ajax异步请求*/
    $.ajaxSettings.async = false;
    // $.ajaxSettings.cache(false);
    let bool = false;
    $.post(
        "/goods/user/verifyVerifyCode",
        {'val': val.toLowerCase()}, // 将用户输入的验证码转换为小写后发送
        function (res) {
            if (res) {
                $("#verifyCodeError").text("验证码正确！");
                $("#verifyCodeError").addClass("rightClass").removeClass("errorClass");
                bool = true;
            } else {
                $("#verifyCodeError").text("验证码错误！");
                $("#verifyCodeError").addClass("errorClass").removeClass("rightClass");
            }
        }
    );
    return bool;
}











