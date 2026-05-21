<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>订单管理 - 操作结果</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <meta http-equiv="content-type" content="text/html;charset=utf-8">

    <link rel="stylesheet" type="text/css" href="<c:url value='/css/order/message.css'/>"/>
</head>

<body>
<div class="divMain">
    <div class="divTitle">
        <span style="margin-left: 150px; margin-right: 280px;">商品信息</span>
        <span style="margin-left: 40px; margin-right: 38px;">金额</span>
        <span style="margin-left: 50px; margin-right: 40px;">订单状态</span>
        <span style="margin-left: 50px; margin-right: 50px;">操作</span>
    </div>
    <br/>

    <table align="center" border="0" width="100%" cellpadding="0" cellspacing="0">
        <tr class="tt">
            <td width="320px">
                订单号：<a href="<c:url value='/admin/order/desc/${order.oid}'/>">${order.oid}</a>
            </td>
            <td width="200px">下单时间：${order.ordertime}</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr style="padding-top: 10px; padding-bottom: 10px;">
            <td colspan="2">
                <c:forEach items="${orderItems}" var="orderItem">
                    <a class="link2" href="<c:url value='/book/getBookByBid?bid=${orderItem.bid}'/>">
                        <img border="0" width="70" src="<c:url value='/book_img/${orderItem.imageB}'/>"/>
                    </a>
                </c:forEach>
            </td>
            <td width="115px">
                <span class="price_t">¥${order.total}</span>
            </td>
            <td width="142px">
                <c:choose>
                    <c:when test="${order.status == 1}">等待付款</c:when>
                    <c:when test="${order.status == 2}">已支付</c:when>
                    <c:when test="${order.status == 3}">已发货</c:when>
                    <c:when test="${order.status == 4}">已确认收货</c:when>
                    <c:when test="${order.status == 5}">已取消</c:when>
                    <c:otherwise>未知状态</c:otherwise>
                </c:choose>
            </td>
            <td>
                <a href="<c:url value='/admin/order/desc/${order.oid}'/>">查看</a><br/>
                <a href="<c:url value='/admin/order/updateAddress?oid=${order.oid}'/>">修改地址</a><br/>
            </td>
        </tr>
    </table>
</div>
</body>
</html>