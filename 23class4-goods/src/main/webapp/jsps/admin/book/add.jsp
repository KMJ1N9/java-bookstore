<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>商品管理 - 添加商品</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <meta http-equiv="content-type" content="text/html;charset=utf-8">
    <!--
    <link rel="stylesheet" type="text/css" href="styles.css">
    -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css'/>">
    <style type="text/css">
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }

        .container {
            width: 90%;
            margin: 20px auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            margin-top: 0;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 3px;
            box-sizing: border-box;
        }

        .form-group select {
            /* 移除浏览器默认的下拉样式限制 */
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;

            /* 重要：设置下拉菜单的最大高度 */
            max-height: 300px;
            overflow-y: auto;

            /* 添加一个向下的箭头图标，因为移除了原生样式 */
            background-image: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 4 5'%3E%3Cpath fill='%23343a40' d='M2 0L0 2h4zm0 5L0 3h4z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 8px 10px;
        }

        /* 针对select下拉菜单内容的样式 */
        .form-group select option {
            padding: 4px;
        }

        /* 为select元素添加自定义滚动条，支持所有浏览器 */
        .form-group select::-webkit-scrollbar {
            width: 8px;
        }

        .form-group select::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        .form-group select::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 4px;
        }

        .form-group select::-webkit-scrollbar-thumb:hover {
            background: #555;
        }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-col {
            flex: 1;
        }

        .btn {
            padding: 10px 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 16px;
        }

        .btn:hover {
            background: #0056b3;
        }

        .btn-secondary {
            background: #6c757d;
            margin-left: 10px;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }
    </style>
    <script type="text/javascript" src="<c:url value='/js/book/add.js'/>"></script>
</head>

<body>
<div class="container">
    <h2>添加商品</h2>

    <form action="<c:url value='/admin/book/add'/>" method="post">
        <gg:token/>
        <div class="form-row">
            <div class="form-col">
                <div class="form-group">
                    <label for="bname">书名:</label>
                    <input type="text" id="bname" name="bname" required/>
                </div>

                <div class="form-group">
                    <label for="author">作者:</label>
                    <input type="text" id="author" name="author" required/>
                </div>

                <div class="form-group">
                    <label for="press">出版社:</label>
                    <input type="text" id="press" name="press" required/>
                </div>

                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label for="price">定价:</label>
                            <input type="number" id="price" name="price" step="0.01" min="0" required/>
                        </div>
                    </div>

                    <div class="form-col">
                        <div class="form-group">
                            <label for="currprice">现价:</label>
                            <input type="number" id="currprice" name="currprice" step="0.01" min="0" required/>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label for="edition">版次:</label>
                            <input type="number" id="edition" name="edition" min="1" value="1"/>
                        </div>
                    </div>

                    <div class="form-col">
                        <div class="form-group">
                            <label for="pagenum">页数:</label>
                            <input type="number" id="pagenum" name="pagenum" min="1"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-col">
                <div class="form-group">
                    <label for="publishtime">出版时间:</label>
                    <input type="text" id="publishtime" name="publishtime" placeholder="例如: 2023-01-01"/>
                </div>

                <div class="form-group">
                    <label for="printtime">印刷时间:</label>
                    <input type="text" id="printtime" name="printtime" placeholder="例如: 2023-01-01"/>
                </div>

                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label for="booksize">开本:</label>
                            <input type="number" id="booksize" name="booksize"/>
                        </div>
                    </div>

                    <div class="form-col">
                        <div class="form-group">
                            <label for="wordnum">字数:</label>
                            <input type="number" id="wordnum" name="wordnum"/>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="paper">纸质:</label>
                    <input type="text" id="paper" name="paper"/>
                </div>

                <div class="form-group">
                    <label for="cid">分类:</label>
                    <select id="cid" name="cid" required>
                        <option value="">请选择分类</option>
                        <c:forEach items="${categories}" var="categoryPovo">
                            <!-- 显示一级分类（不可选） -->
                            <option value="" disabled>${categoryPovo.dad.cname}</option>
                            <!-- 显示该一级分类下的所有二级分类 -->
                            <c:forEach items="${categoryPovo.children}" var="subCategory">
                                <option value="${subCategory.cid}">${subCategory.cname}</option>
                            </c:forEach>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label for="imageW">小图路径:</label>
            <input type="text" id="imageW" name="imageW" placeholder="例如: book_img/xxx_w.jpg"/>
        </div>

        <div class="form-group">
            <label for="imageB">大图路径:</label>
            <input type="text" id="imageB" name="imageB" placeholder="例如: book_img/xxx_b.jpg"/>
        </div>

        <div class="form-group">
            <button type="submit" class="btn">添加商品</button>
            <a href="<c:url value='/admin/book/list'/>" class="btn btn-secondary">返回列表</a>
        </div>
    </form>
</div>
</body>
</html>