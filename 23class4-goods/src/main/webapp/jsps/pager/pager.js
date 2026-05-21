// 分页功能 JavaScript 文件
// 复制自 pager.jsp 中的 JavaScript 逻辑
function _go() {
    var pc = $("#pageCode").val();//获取文本框中的当前页码
    if (!/^[1-9]\d*$/.test(pc)) {//对当前页码进行整数校验
        alert('请输入正确的页码！');
        return;
    }
    if (pc > 10) {//判断当前页码是否大于最大页
        alert('请输入正确的页码！');
        return;
    }
    location = "${uri}&pageNum=" + pc;
}
