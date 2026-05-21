<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>订单列表</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <meta http-equiv="content-type" content="text/html;charset=utf-8">
    <!--
    <link rel="stylesheet" type="text/css" href="styles.css">
    -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/order/list.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/jsps/pager/pager.css'/>"/>
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="<c:url value='/jsps/pager/pager.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/order/list.js'/>"></script>
    <script type="text/javascript">
        $(function () {
            $("#header .shoppingCart a").addClass("colorRed");
        });

        // 支付订单
        function payOrder(oid) {
            if (confirm('确定要支付此订单吗？')) {
                window.location.href = "<c:url value='/order/toPay'/>?oid=" + oid;
            }
        }

        // 确认收货
        function confirmReceive(oid) {
            if (confirm("确定已收到商品吗？")) {
                $.ajax({
                    url: "<c:url value='/order/confirmReceive'/>?oid=" + oid,
                    success: function (result) {
                        if (result == "success") {
                            alert("确认收货成功！");
                            window.location.reload();
                        } else {
                            alert("操作失败！");
                        }
                    }
                });
            }
        }

        // 取消订单
        function cancelOrder(oid) {
            if (confirm('确定要取消此订单吗？')) {
                $.ajax({
                    url: "<c:url value='/order/cancel'/>?oid=" + oid,
                    success: function (result) {
                        if (result == "success") {
                            alert("订单已取消！");
                            window.location.reload();
                        } else {
                            alert("操作失败！");
                        }
                    },
                    error: function (xhr) {
                        if (xhr.status == 401) {
                            alert("会话已过期，请重新登录！");
                            window.location.href = "<c:url value='/'/>";
                        } else {
                            alert("请求失败，请稍后重试！");
                        }
                    }
                });
            }
        }
    </script>
</head>
<body>
<div class="divMain">
    <div class="divTitle">
        <span style="margin-left: 150px;margin-right: 280px;">商品信息</span>
        <span style="margin-left: 40px;margin-right: 38px;">金额</span>
        <span style="margin-left: 50px;margin-right: 40px;">订单状态</span>
        <span style="margin-left: 50px;margin-right: 50px;">操作</span>
    </div>
    <br/>
    <table align="center" border="0" width="100%" cellpadding="0" cellspacing="0">

        <!-- 动态显示订单列表 -->
        <c:choose>
            <c:when test="${empty orderList}">
                <tr>
                    <td colspan="6" align="center" style="padding: 50px;">
                        您还没有订单记录，<a href="<c:url value='/index.jsp'/>" target="_top">去购物吧！</a>
                    </td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="order" items="${orderList}">
                    <!-- 订单头部信息 -->
                    <tr class="tt">
                        <td width="320px">订单号：<a href="<c:url value='/order/desc/${order.oid}'/>">${order.oid}</a>
                        </td>
                        <td width="200px">
                            下单时间：<fmt:formatDate value="${order.ordertime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr style="padding-top: 10px; padding-bottom: 10px;">
                        <td colspan="2">
                            <!-- 动态显示订单项 -->
                            <c:forEach var="orderItem" items="${order.orderItems}">
                                <a class="link2" href="<c:url value='/jsps/book/desc.jsp?bid=${orderItem.bid}'/>">
                                    <img border="0" width="70"
                                         src="<c:url value='/book_img/${orderItem.imageB}'/>">
                                    <span>${orderItem.bname}</span>
                                </a>
                            </c:forEach>
                        </td>
                        <td width="115px">
                            <span class="price_t">&yen;${order.total}</span>
                        </td>
                        <td width="142px">
                            <!-- 动态显示订单状态 -->
                            <c:choose>
                                <c:when test="${order.status == 1}"><span class="waitPay">等待付款</span></c:when>
                                <c:when test="${order.status == 2}"><span
                                        class="waitConf">已支付（等待发货）</span></c:when>
                                <c:when test="${order.status == 3}"><span
                                        class="waitConf">已发货（等待确认收货）</span></c:when>
                                <c:when test="${order.status == 4}"><span class="finish">已确认收货</span></c:when>
                                <c:when test="${order.status == 5}"><span class="cancel">已取消</span></c:when>
                                <c:otherwise>(未知状态)</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="<c:url value='/order/desc/${order.oid}'/>">查看</a><br/>

                            <!-- 根据订单状态显示不同操作 -->
                            <c:if test="${order.status == 1}">
                                <a href="javascript:void(0);" onclick="payOrder('${order.oid}');"
                                   class="payBtn">支付</a><br/>
                                <a href="javascript:void(0);" onclick="cancelOrder('${order.oid}');" class="cancelBtn">取消</a><br/>
                            </c:if>

                            <c:if test="${order.status == 3}">
                                <a href="javascript:void(0);" onclick="confirmReceive('${order.oid}');"
                                   class="confirmBtn">确认收货</a><br/>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>

    </table>
    <br/>
    <c:if test="${not empty orderList}">
        <%@include file="/jsps/pager/pager.jsp" %>
    </c:if>
</div>
</body>
</html>