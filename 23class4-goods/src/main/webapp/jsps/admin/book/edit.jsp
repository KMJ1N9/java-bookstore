<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="gg" uri="http://com.gg.goods/tags/csrf" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>商品管理 - 编辑商品</title>

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

        .btn-danger {
            background: #dc3545;
        }

        .btn-danger:hover {
            background: #c82333;
        }
    </style>
    <script type="text/javascript" src="<c:url value='/js/book/edit.js'/>"></script>
</head>

<body>
<div class="container">
    <h2>编辑商品</h2>

    <form action="<c:url value='/admin/book/edit'/>" method="post">
        <gg:token/>
        <!-- 隐藏字段 -->
        <input type="hidden" name="bid" value="${book.bid}"/>

        <div class="form-row">
            <div class="form-col">
                <div class="form-group">
                    <label for="bname">书名:</label>
                    <input type="text" id="bname" name="bname" value="${book.bname}" required/>
                </div>

                <div class="form-group">
                    <label for="author">作者:</label>
                    <input type="text" id="author" name="author" value="${book.author}" required/>
                </div>

                <div class="form-group">
                    <label for="press">出版社:</label>
                    <input type="text" id="press" name="press" value="${book.press}" required/>
                </div>

                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label for="price">定价:</label>
                            <input type="number" id="price" name="price" step="0.01" min="0" value="${book.price}"
                                   required/>
                        </div>
                    </div>

                    <div class="form-col">
                        <div class="form-group">
                            <label for="currprice">现价:</label>
                            <input type="number" id="currprice" name="currprice" step="0.01" min="0"
                                   value="${book.currprice}" required/>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label for="edition">版次:</label>
                            <input type="number" id="edition" name="edition" min="1" value="${book.edition}"/>
                        </div>
                    </div>

                    <div class="form-col">
                        <div class="form-group">
                            <label for="pagenum">页数:</label>
                            <input type="number" id="pagenum" name="pagenum" min="1" value="${book.pagenum}"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-col">
                <div class="form-group">
                    <label for="publishtime">出版时间:</label>
                    <input type="text" id="publishtime" name="publishtime" value="${book.publishtime}"
                           placeholder="例如: 2023-01-01"/>
                </div>

                <div class="form-group">
                    <label for="printtime">印刷时间:</label>
                    <input type="text" id="printtime" name="printtime" value="${book.printtime}"
                           placeholder="例如: 2023-01-01"/>
                </div>

                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label for="booksize">开本:</label>
                            <input type="number" id="booksize" name="booksize" value="${book.booksize}"/>
                        </div>
                    </div>

                    <div class="form-col">
                        <div class="form-group">
                            <label for="wordnum">字数:</label>
                            <input type="number" id="wordnum" name="wordnum" value="${book.wordnum}"/>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="paper">纸质:</label>
                    <input type="text" id="paper" name="paper" value="${book.paper}"/>
                </div>

                <div class="form-group">
                    <label for="cid">分类ID:</label>
                    <input type="text" id="cid" name="cid" value="${book.cid}" required/>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label for="imageW">小图路径:</label>
            <input type="text" id="imageW" name="imageW" value="${book.imageW}" placeholder="例如: book_img/xxx_w.jpg"/>
        </div>

        <div class="form-group">
            <label for="imageB">大图路径:</label>
            <input type="text" id="imageB" name="imageB" value="${book.imageB}" placeholder="例如: book_img/xxx_b.jpg"/>
        </div>

        <div class="form-group">
            <button type="submit" class="btn">保存修改</button>
            <a href="<c:url value='/admin/book/list'/>" class="btn btn-secondary">返回列表</a>
            <a href="<c:url value='/admin/book/delete?bid=${book.bid}'/>"
               onclick="return confirm('确定要删除这本书吗？')" class="btn btn-danger">删除商品</a>
        </div>
    </form>
</div>
</body>
</html>