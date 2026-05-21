<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>订单详细</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <meta http-equiv="content-type" content="text/html;charset=utf-8">
    <!--
    <link rel="stylesheet" type="text/css" href="styles.css">
    -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/order/desc.css"/>
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.7.2.min.js"></script>
</head>

<body>
<div class="divOrder">
		<span>订单号：${order.oid}
			<c:choose>
                <c:when test="${order.status == 1}">(等待付款)</c:when>
                <c:when test="${order.status == 2}">(已支付，等待发货)</c:when>
                <c:when test="${order.status == 3}">(已发货，等待确认收货)</c:when>
                <c:when test="${order.status == 4}">(已确认收货)</c:when>
                <c:when test="${order.status == 5}">(已取消)</c:when>
                <c:otherwise>(未知状态)</c:otherwise>
            </c:choose>
		　　　下单时间：<fmt:formatDate value="${order.ordertime}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
</div>
<div class="divContent">
    <div class="div2">
        <dl>
            <dt>收货人信息</dt>
            <dd>${order.address} </dd>
        </dl>
    </div>
    <div class="div2">
        <dl>
            <dt>商品清单</dt>
            <dd>
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <th class="tt">商品名称</th>
                        <th class="tt" align="left">单价</th>
                        <th class="tt" align="left">数量</th>
                        <th class="tt" align="left">小计</th>
                    </tr>

                    <c:forEach items="${orderItems}" var="orderItem">
                        <tr style="padding-top: 20px; padding-bottom: 20px;">
                            <td class="td" width="400px">
                                <div class="bookname">
                                    <img align="middle" width="70"
                                         src="<c:url value='/book_img/${orderItem.imageB}'/>"/>
                                    <a href="<c:url value='/jsps/book/desc.jsp?bid=${orderItem.bid}'/>">${orderItem.bname}</a>
                                </div>
                            </td>
                            <td class="td">
                                <span>&yen;${orderItem.currprice}</span>
                            </td>
                            <td class="td">
                                <span>${orderItem.quantity}</span>
                            </td>
                            <td class="td">
                                <span>&yen;${orderItem.subtotal}</span>
                            </td>
                        </tr>
                    </c:forEach>

                </table>
            </dd>
        </dl>
    </div>
    <div style="margin: 10px 10px 10px 550px;">
        <span style="font-weight: 900; font-size: 15px;">合计金额：</span>
        <span class="price_t">&yen;${order.total}</span><br/>

        <c:if test="${order.status == 1}">
            <a href="javascript:payOrder('${order.oid}');" class="pay"></a><br/>
            <a id="cancel" href="javascript:cancelOrder('${order.oid}');">取消订单</a><br/>
        </c:if>
        <c:if test="${order.status == 3}">
            <a id="confirm" href="javascript:confirmReceive('${order.oid}');">确认收货</a><br/>
        </c:if>
    </div>
</div>
<script type="text/javascript">
    // 支付订单
    function payOrder(oid) {
        $.ajax({
            url: "<c:url value='/order/pay'/>?oid=" + oid,
            success: function (result) {
                if (result == "success") {
                    alert("支付成功！");
                    window.location.reload();
                } else {
                    alert("支付失败！");
                }
            }
        });
    }

    // 取消订单
    function cancelOrder(oid) {
        if (confirm("确定要取消该订单吗？")) {
            $.ajax({
                url: "<c:url value='/order/cancel'/>?oid=" + oid,
                success: function (result) {
                    if (result == "success") {
                        alert("订单已取消！");
                        window.location.reload();
                    } else {
                        alert("取消失败！");
                    }
                }
            });
        }
    }

    // 确认收货
    function confirmReceive(oid) {
        if (confirm("确定已收到商品吗？")) {
            $.ajax({
                url: "<c:url value='/order/confirmReceive'/>?oid=" + oid,
                success: function (result) {
                    if (result == "success") {
                        alert("交易成功！");
                        window.location.reload();
                    } else {
                        alert("确认收货失败！");
                    }
                }
            });
        }
    }
</script>
</body>
</html>