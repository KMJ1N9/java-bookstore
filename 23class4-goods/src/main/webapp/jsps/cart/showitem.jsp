<%@ page language="java"
         import="com.gg.goods.povos.CartBookPovo, com.gg.goods.service.CartitemService, org.springframework.web.context.WebApplicationContext, org.springframework.web.context.support.WebApplicationContextUtils, java.util.Arrays, java.util.List"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>showitem.jsp</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <!--
    <link rel="stylesheet" type="text/css" href="styles.css">
    -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/cart/showitem.css'/>">
    <script src="<c:url value='/jquery/jquery-1.5.1.js'/>"></script>
    <script src="<c:url value='/js/round.js'/>"></script>
    <style type="text/css">
        #addr {
            width: 500px;
            height: 32px;
            border: 1px solid #7f9db9;
            padding-left: 10px;
            line-height: 32px;
        }
    </style>

    <script type="text/javascript">
        //计算合计
        $(function () {
            var total = 0;
            $(".subtotal").each(function () {
                total += Number($(this).text());
            });
            $("#total").text(round(total, 2));
        });
    </script>
</head>

<body>
<%
    // 获取购物车项ID列表
    String cartItemIdsStr = request.getParameter("cartItemIds");
    List<CartBookPovo> cartBookPovos = null;

    if (cartItemIdsStr != null && !cartItemIdsStr.isEmpty()) {
        // 分割ID字符串为数组
        String[] cartItemIds = cartItemIdsStr.split(",");

        // 从Spring容器中获取CartitemService (更可靠的方式)
        CartitemService cartitemService = null;
        try {
            // 获取Spring容器
            WebApplicationContext wac = WebApplicationContextUtils.getWebApplicationContext(application);
            if (wac != null) {
                // 从容器中获取cartitemService
                cartitemService = (CartitemService) wac.getBean("cartitemService");
            }
        } catch (Exception e) {
            // 如果获取失败，记录异常
            e.printStackTrace();
        }

        // 调用服务获取购物车项列表
        if (cartitemService != null) {
            cartBookPovos = cartitemService.getCartitemsByIds(Arrays.asList(cartItemIds));
        }
    }

// 将购物车项列表存入请求作用域
    request.setAttribute("cartBookPovos", cartBookPovos);
%>

<form id="form1" action="<c:url value='/order/createOrderFromCart'/>" method="post">
    <input type="hidden" name="cartitemIds" value="${param.cartItemIds}"/>
    <input type="hidden" name="_csrf_token" value="${CSRF_TOKEN}"/>
    <table width="95%" align="center" cellpadding="0" cellspacing="0">
        <tr bgcolor="#efeae5">
            <td width="400px" colspan="5"><span style="font-weight: 900;">生成订单</span></td>
        </tr>
        <tr align="center">
            <td width="10%">&nbsp;</td>
            <td width="50%">图书名称</td>
            <td>单价</td>
            <td>数量</td>
            <td>小计</td>
        </tr>

        <c:if test="${empty cartBookPovos}">
            <tr>
                <td colspan="5" align="center">
                    <span>没有选中的商品，请重新选择！</span>
                </td>
            </tr>
        </c:if>

        <c:if test="${not empty cartBookPovos}">
            <c:forEach items="${cartBookPovos}" var="cartbookpovo">
                <tr align="center">
                    <td align="right">
                        <a class="linkImage"
                           href="<c:url value='/jsps/book/desc.jsp?bid=${cartbookpovo.book.bid}' />"><img border="0"
                                                                                                          width="54"
                                                                                                          align="top"
                                                                                                          src="<c:url value='/${cartbookpovo.book.imageB}' />"/></a>
                    </td>
                    <td align="left">
                        <a href="<c:url value='/jsps/book/desc.jsp?bid=${cartbookpovo.book.bid}' />"><span>${cartbookpovo.book.bname}</span></a>
                    </td>
                    <td>&yen;${cartbookpovo.book.currprice}</td>
                    <td>${cartbookpovo.cartitem.quantity}</td>
                    <td>
                        <span class="price_n">&yen;<span class="subtotal">${cartbookpovo.subtotal}</span></span>
                    </td>
                </tr>
            </c:forEach>
        </c:if>

        <tr>
            <td colspan="6" align="right">
                <span>总计：</span><span class="price_t">&yen;<span id="total"></span></span>
            </td>
        </tr>
        <tr>
            <td colspan="5" bgcolor="#efeae5"><span style="font-weight: 900">收货地址</span></td>
        </tr>
        <tr>
            <td colspan="6">
                <input id="addr" type="text" name="address" value="" placeholder="请输入收货地址"/>
            </td>
        </tr>
        <tr>
            <td style="border-top-width: 4px;" colspan="5" align="right">
                <a id="linkSubmit" href="javascript:$('#form1').submit();">提交订单</a>
            </td>
        </tr>
    </table>
</form>
</body>
</html>

