<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>cartlist.jsp</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <!--
    <link rel="stylesheet" type="text/css" href="styles.css">
    -->
    <script src="<c:url value='/jquery/jq.js'/>"></script>
    <script src="<c:url value='/js/round.js'/>"></script>

    <link rel="stylesheet" type="text/css" href="<c:url value='/css/cart/list.css'/>">
    <script type="text/javascript">
        $(function () {
            showTotal();//显示合计
            // 给全选按钮添加点击事件
            $("#selectAll").click(function () {
                var flag = $(this).prop("checked");//获取全选的状态
                setAll(flag);//让所有条目复选框与全选同步
                setJieSuanStyle(flag);//让结算按钮与全选同步
            });

            // 给条目复选框添加事件
            $(":checkbox[name=checkboxBtn]").click(function () {
                var selectedCount = $(":checkbox[name=checkboxBtn]:checked").length;//被勾选复选框个数
                var allCount = $(":checkbox[name=checkboxBtn]").length;//所有条目复选框个数
                if (selectedCount == allCount) {//全选了
                    $("#selectAll").prop("checked", true);//勾选全选复选框
                    setJieSuanStyle(true);//使结算按钮可用
                } else if (selectedCount == 0) {//全撤消了
                    $("#selectAll").prop("checked", false);//撤消全选复选框
                    setJieSuanStyle(false);//使结算按钮不可用
                } else {//未全选
                    $("#selectAll").prop("checked", false);//撤消全选复选框
                    setJieSuanStyle(true);//使结算按钮可用
                }
                showTotal();//重新计算合计
            });

            // 给jia、jian添加事件
            $(".jian").click(function () {
                var cartItemId = $(this).attr("id").substring(0, 32);
                var quantity = Number($("#" + cartItemId + "Quantity").val());
                if (quantity == 1) {
                    deleteCartItem(cartItemId);
                } else {
                    sendUpdate(cartItemId, quantity - 1);
                }
            });
            $(".jia").click(function () {
                var cartItemId = $(this).attr("id").substring(0, 32);
                var quantity = Number($("#" + cartItemId + "Quantity").val());
                sendUpdate(cartItemId, quantity + 1);
            });
        });

        // 异步请求，修改数量
        function sendUpdate(cartItemId, quantity) {
            /*
             1. 通过cartItemId找到输入框元素
             2. 通过cartItemId找到小计元素
             3. 发送AJAX请求更新后端数据
            */
            var input = $("#" + cartItemId + "Quantity");
            var subtotal = $("#" + cartItemId + "Subtotal");
            var currPrice = $("#" + cartItemId + "CurrPrice");

            // 先更新UI显示
            input.val(quantity);
            subtotal.text(round(currPrice.text() * quantity, 2));
            showTotal();

            // 发送AJAX请求到后端更新数据
            $.ajax({
                url: "<c:url value='/cart/update/quantity'/>",
                type: "POST",
                data: {"cartitemid": cartItemId, "quantity": quantity, "_csrf_token": "${CSRF_TOKEN}"},
                dataType: "json",
                success: function (result) {
                    if (!result.success) {
                        // 如果更新失败，恢复原来的值
                        alert("更新失败: " + result.message);
                    }
                },
                error: function () {
                    alert("网络错误，请重试");
                }
            });
        }

        // 设置所有条目复选框
        function setAll(flag) {
            $(":checkbox[name=checkboxBtn]").prop("checked", flag);//让所有条目的复选框与参数flag同步
            showTotal();//重新设置合计
        }

        // 设置结算按钮的样式
        function setJieSuanStyle(flag) {
            if (flag) {// 有效状态
                $("#jiesuan").removeClass("kill").addClass("jiesuan");//切换样式
                $("#jiesuan").unbind("click");//撤消“点击无效”
            } else {// 无效状态
                $("#jiesuan").removeClass("jiesuan").addClass("kill");//切换样式
                $("#jiesuan").click(function () {//使其“点击无效”
                    return false;
                });
            }
        }

        // 显示合计
        function showTotal() {
            var total = 0;//创建total，准备累加
            /*
            1. 获取所有被勾选的复选框，遍历之
            */
            $(":checkbox[name=checkboxBtn]:checked").each(function () {
                /*
                2. 通过复选框找到小计
                */
                var subtotal = Number($("#" + $(this).val() + "Subtotal").text());
                total += subtotal;
            });
            /*
            3. 设置合计
            */
            $("#total").text(round(total, 2));
        }

        // 删除单个购物车商品
        function deleteCartItem(cartItemId) {
            if (confirm("确定要删除该商品吗？")) {
                $.ajax({
                    url: "<c:url value='/cart/deleteCartitem'/>",
                    type: "GET",
                    data: {"cartitemid": cartItemId, "uid": "${uid}"},
                    dataType: "json",
                    success: function (result) {
                        // 删除成功后刷新页面
                        location.reload();
                    },
                    error: function () {
                        // 发生错误时也刷新页面以确保数据一致性
                        location.reload();
                    }
                });
            }
        }

        // 批量删除功能
        function batchDelete() {
            var checkedItems = $(":checkbox[name=checkboxBtn]:checked");
            if (checkedItems.length == 0) {
                alert("请选择要删除的商品！");
                return;
            }
            if (confirm("确定要删除选中的" + checkedItems.length + "个商品吗？")) {
                var cartItemIds = [];
                checkedItems.each(function () {
                    cartItemIds.push($(this).val());
                });
                var form = $("<form action='<c:url value='/cart/batchDeleteCartitems'/>' method='post'></form>");
                $.each(cartItemIds, function (index, id) {
                    form.append('<input type="hidden" name="cartitemIds" value="' + id + '"/>');
                });
                form.append('<input type="hidden" name="uid" value="${uid}"/>');
                form.append('<input type="hidden" name="_csrf_token" value="${CSRF_TOKEN}"/>');
                form.appendTo('body').submit();
            }
        }

        // 提交表单进行结算
        function submitForm() {
            var checkedItems = $(":checkbox[name=checkboxBtn]:checked");
            if (checkedItems.length == 0) {
                alert("请选择要结算的商品！");
                return;
            }
            var cartItemIds = [];
            checkedItems.each(function () {
                cartItemIds.push($(this).val());
            });
            $("#cartItemIds").val(cartItemIds.join(','));
            $("#form1").submit();
        }


    </script>
</head>
<body>

<c:if test="${fn:length(cartBookPovos) == 0}">
    <table width="95%" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td align="right">
                <img align="top" src="<c:url value='/images/icon_empty.png'/>"/>
            </td>
            <td>
                <span class="spanEmpty">您的购物车中暂时没有商品</span>
            </td>
        </tr>
    </table>

    <br/>
    <br/>
</c:if>
<c:if test="${fn:length(cartBookPovos) != 0}">
    <table width="95%" align="center" cellpadding="0" cellspacing="0">
        <tr align="center" bgcolor="#efeae5">
            <td align="left" width="50px">
                <input type="checkbox" id="selectAll" checked="checked"/><label for="selectAll">全选</label>
            </td>
            <td colspan="2">商品名称</td>
            <td>单价</td>
            <td>数量</td>
            <td>小计</td>
            <td>操作</td>
        </tr>


        <c:forEach items="${cartBookPovos}" var="cartbookpovo">

            <tr align="center">
                <td align="left">
                    <input value="${cartbookpovo.cartitem.cartitemid}" type="checkbox" name="checkboxBtn"
                           checked="checked"/>
                </td>
                <td align="left" width="70px">
                    <a class="linkImage" href="<c:url value='/book/getBookByBid?bid=${cartbookpovo.book.bid}'/>">
                        <img border="0" width="54" align="top" src="<c:url value='/${cartbookpovo.book.imageB}'/>"/></a>
                </td>
                <td align="left" width="400px">
                    <a href="<c:url value='/book/getBookByBid?bid=${cartbookpovo.book.bid}'/>">
                        <span>${cartbookpovo.book.bname}</span>
                    </a>
                </td>
                <td><span>&yen;<span class="currPrice"
                                     id="${cartbookpovo.cartitem.cartitemid}CurrPrice">${cartbookpovo.book.currprice}</span></span>
                </td>
                <td>
                    <a class="jian" id="${cartbookpovo.cartitem.cartitemid}Jian"></a>
                    <input class="quantity" readonly="readonly" id="${cartbookpovo.cartitem.cartitemid}Quantity"
                           type="text" value="${cartbookpovo.cartitem.quantity}"/>
                    <a class="jia" id="${cartbookpovo.cartitem.cartitemid}Jia"></a>
                </td>
                <td width="100px">
                    <span class="price_n">&yen;<span class="subTotal"
                                                     id="${cartbookpovo.cartitem.cartitemid}Subtotal">${cartbookpovo.subtotal}</span></span>
                </td>
                <td>
                    <a href="javascript:void(0);"
                       onclick="deleteCartItem('${cartbookpovo.cartitem.cartitemid}');">删除</a>
                </td>
            </tr>
        </c:forEach>
        <tr>
            <td colspan="4" class="tdBatchDelete">
                <a href="javascript:batchDelete();">批量删除</a>
            </td>
            <td colspan="3" align="right" class="tdTotal">
                <span>总计：</span><span class="price_t">&yen;<span id="total"></span></span>
            </td>
        </tr>
        <tr>
            <td colspan="7" align="right">
                <a href="javascript:submitForm();" id="jiesuan" class="jiesuan"></a>
            </td>
        </tr>
    </table>
    <form id="form1" action="<c:url value='/jsps/cart/showitem.jsp'/>" method="post">
        <input type="hidden" name="cartItemIds" id="cartItemIds"/>
        <input type="hidden" name="method" value="loadCartItems"/>
        <input type="hidden" name="_csrf_token" value="${CSRF_TOKEN}"/>
    </form>

</c:if>
</body>
</html>

