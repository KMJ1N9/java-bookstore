<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
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
</script>


<div class="divBody">
    <div class="divContent">
        <%--上一页 --%>
        <c:if test="${pageinfo.pageNum == 1}">
            <span class="spanBtnDisabled">上一页</span>
        </c:if>
        <c:if test="${pageinfo.pageNum != 1}">
            <a href="${uri}&pageNum=${pageinfo.prePage}" class="aBtn bold">上一页</a>
        </c:if>

        <%-- 计算begin和end --%>
        <%-- 如果总页数<=6，那么显示所有页码，即begin=1 end=${pb.tp} --%>
        <%-- 设置begin=当前页码-2，end=当前页码+3 --%>
        <%-- 如果begin<1，那么让begin=1 end=6 --%>
        <%-- 如果end>最大页，那么begin=最大页-5 end=最大页 --%>


        <%-- 显示页码列表 --%>
        <%-- <span class="spanBtnSelect">1</span>--%>

        <%--10个格子以内--%>
        <c:if test="${pageinfo.pages <= 10}">
            <c:set var="begin" value="1"/>
            <c:set var="end" value="${pageinfo.pages}"/>
        </c:if>

        <%--10个格子以上--%>

        <c:if test="${pageinfo.pages >10}">
            <c:set var="begin" value="${pageinfo.pageNum-5}"/>
            <c:set var="end" value="${pageinfo.pageNum+4}"/>

            <%--左侧扶正--%>
            <c:if test="${begin < 1}">
                <c:set var="begin" value="1"/>
                <c:set var="end" value="10"/>
            </c:if>
            <%--右侧扶正--%>
            <c:if test="${end > pageinfo.pages}">
                <c:set var="end" value="${pageinfo.pages}"/>
                <c:set var="begin" value="${end-9}"/>
            </c:if>
        </c:if>
        <%--循环输出格子们--%>

        <c:forEach begin="${begin}" end="${end}" var="i">
            <a href="${uri}&pageNum=${i}" class="aBtn">[${i}]</a>
        </c:forEach>


        <%--下一页 --%>
        <c:if test="${pageinfo.pageNum == pageinfo.pages}">
            <span class="spanBtnDisabled">下一页</span>
        </c:if>
        <c:if test="${pageinfo.pageNum != pageinfo.pages}">
            <a href="${uri}&pageNum=${pageinfo.nextPage}" class="aBtn bold">下一页</a>
            &nbsp;&nbsp;&nbsp;&nbsp;</c:if>

        <%-- 共N页 到M页 --%>
        <span>共${pageinfo.pages}页</span>
        <span>到</span>
        <input type="text" class="inputPageCode" id="pageCode" value="1"/>
        <span>页</span>
        <a href="javascript:_go();" class="aSubmit">确定</a>
    </div>
</div>