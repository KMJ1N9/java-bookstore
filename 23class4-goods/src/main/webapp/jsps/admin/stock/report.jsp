<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>库存统计报表 - 商品管理系统</title>
    <!-- 引入jQuery -->
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js" defer></script>
    <!-- 引入ECharts，使用较小版本并延迟加载 -->
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.0/dist/echarts.min.js" defer></script>
    <!-- 页面样式 -->
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }

        .report-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .report-header {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .report-header h1 {
            margin: 0;
            color: #333;
            font-size: 24px;
        }

        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .stat-card {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .stat-card .number {
            font-size: 32px;
            font-weight: bold;
            color: #1890ff;
            margin-bottom: 8px;
        }

        .stat-card .label {
            font-size: 16px;
            color: #666;
        }

        .chart-section {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .chart-section h3 {
            margin: 0 0 20px 0;
            color: #333;
            font-size: 18px;
        }

        .chart-container {
            width: 100%;
            height: 400px;
        }

        .chart-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        @media (max-width: 768px) {
            .chart-row {
                grid-template-columns: 1fr;
            }
        }

        .control-panel {
            background: #fff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .control-panel select {
            padding: 8px 12px;
            border: 1px solid #d9d9d9;
            border-radius: 4px;
            margin-right: 10px;
        }

        .control-panel button {
            padding: 8px 16px;
            background: #1890ff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .control-panel button:hover {
            background: #40a9ff;
        }

        .stock-status-normal {
            color: #52c41a;
        }

        .stock-status-low {
            color: #faad14;
        }

        .stock-status-empty {
            color: #f5222d;
        }

        /* 加载动画 */
        .loading {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            position: relative;
        }

        .loading::after {
            content: '';
            width: 20px;
            height: 20px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }
            100% {
                transform: rotate(360deg);
            }
        }
    </style>
</head>

<body>
<div class="report-container">
    <!-- 页面标题 -->
    <div class="report-header">
        <h1>库存统计报表</h1>
    </div>

    <!-- 控制区域 -->
    <div class="control-panel">
        <span>趋势分析周期：</span>
        <select id="trend-days">
            <option value="7">近7天</option>
            <option value="30" selected>近30天</option>
            <option value="60">近60天</option>
            <option value="90">近90天</option>
        </select>
        <button id="refresh-btn">刷新报表</button>
        <button onclick="window.location.href='/goods/admin/index'"
                style="background: #52c41a; margin-left: 10px;">返回首页
        </button>
    </div>

    <!-- 库存概览统计 -->
    <div class="stats-overview" id="overview-stats">
        <!-- 统计卡片将通过JS动态生成 -->
        <div class="loading"></div>
    </div>

    <!-- 图表区域 -->
    <div class="chart-row">
        <!-- 库存状态分布 -->
        <div class="chart-section">
            <h3>库存状态分布</h3>
            <div id="status-distribution-chart" class="chart-container">
                <div class="loading"></div>
            </div>
        </div>

        <!-- 库存预警级别分布 -->
        <div class="chart-section">
            <h3>库存预警级别分布</h3>
            <div id="warning-distribution-chart" class="chart-container">
                <div class="loading"></div>
            </div>
        </div>
    </div>

    <div class="chart-row">
        <!-- 库存数量范围分布 -->
        <div class="chart-section">
            <h3>库存数量范围分布</h3>
            <div id="quantity-range-chart" class="chart-container">
                <div class="loading"></div>
            </div>
        </div>

        <!-- 库存周转率 -->
        <div class="chart-section">
            <h3>库存周转率</h3>
            <div id="turnover-chart" class="chart-container">
                <div class="loading"></div>
            </div>
        </div>
    </div>

    <!-- 库存变化趋势 -->
    <div class="chart-section">
        <h3>库存变化趋势</h3>
        <div id="trend-chart" class="chart-container">
            <div class="loading"></div>
        </div>
    </div>
</div>

<script>
    // 确保DOM加载完成后执行
    document.addEventListener('DOMContentLoaded', function () {
        // 检查jQuery和ECharts是否加载完成
        checkDependencies();
    });

    // 检查依赖是否加载完成
    function checkDependencies() {
        if (window.jQuery && window.echarts) {
            initPage();
        } else {
            setTimeout(checkDependencies, 100);
        }
    }

    // 全局变量
    var $, echarts;
    var charts = {};
    var dataCache = {};
    var isLoading = false;
    var lazyLoadTimer = null;

    // 页面初始化
    function initPage() {
        $ = window.jQuery;
        echarts = window.echarts;

        // 初始化事件监听
        initEventListeners();

        // 加载概览数据（优先加载）
        loadOverviewStats();

        // 使用Intersection Observer实现图表懒加载
        initLazyLoading();
    }

    // 初始化事件监听
    function initEventListeners() {
        // 刷新按钮事件
        $('#refresh-btn').click(function () {
            if (!isLoading) {
                refreshAllData();
            }
        });

        // 切换趋势周期
        $('#trend-days').change(function () {
            // 清除趋势图缓存
            delete dataCache['trend'];
            // 重新加载趋势图
            loadChart('trend-chart', loadStockTrend);
        });
    }

    // 初始化图表懒加载
    function initLazyLoading() {
        // 延迟初始化图表，先让页面主体内容显示
        lazyLoadTimer = setTimeout(function () {
            // 按顺序初始化图表，避免同时创建多个图表造成性能问题
            setTimeout(function () {
                loadChart('status-distribution-chart', loadStatusDistribution);
            }, 100);
            setTimeout(function () {
                loadChart('warning-distribution-chart', loadWarningDistribution);
            }, 300);
            setTimeout(function () {
                loadChart('quantity-range-chart', loadQuantityRangeDistribution);
            }, 500);
            setTimeout(function () {
                loadChart('turnover-chart', loadStockTurnover);
            }, 700);
            setTimeout(function () {
                loadChart('trend-chart', loadStockTrend);
            }, 900);
        }, 500);

        // 使用Intersection Observer优化可见性检测
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting && entry.target.id && entry.target.id.includes('chart')) {
                        // 图表可见时初始化
                        var chartId = entry.target.id;
                        if (!charts[chartId]) {
                            switch (chartId) {
                                case 'status-distribution-chart':
                                    loadChart(chartId, loadStatusDistribution);
                                    break;
                                case 'warning-distribution-chart':
                                    loadChart(chartId, loadWarningDistribution);
                                    break;
                                case 'quantity-range-chart':
                                    loadChart(chartId, loadQuantityRangeDistribution);
                                    break;
                                case 'turnover-chart':
                                    loadChart(chartId, loadStockTurnover);
                                    break;
                                case 'trend-chart':
                                    loadChart(chartId, loadStockTrend);
                                    break;
                            }
                        }
                    }
                });
            }, {threshold: 0.1});

            // 观察所有图表容器
            document.querySelectorAll('.chart-container').forEach(function (container) {
                // 添加更严格的类型检查，确保container是有效的Node对象
                if (container && typeof container === 'object' && container.nodeType === Node.ELEMENT_NODE) {
                    observer.observe(container);
                } else {
                    console.warn('Invalid container element for observation:', container);
                }
            });
        }
    }

    // 初始化单个图表
    function loadChart(chartId, loadFunction) {
        var container = document.getElementById(chartId);
        if (!container || charts[chartId]) return;

        // 清除加载动画
        container.innerHTML = '';

        // 创建图表实例
        charts[chartId] = echarts.init(container);

        // 执行加载函数
        loadFunction();
    }

    // 统一处理Ajax请求
    function ajaxRequest(url, callback, cacheKey) {
        // 检查缓存
        if (cacheKey && dataCache[cacheKey]) {
            callback(dataCache[cacheKey]);
            return;
        }

        $.ajax({
            url: url,
            type: 'GET',
            cache: false,
            beforeSend: function () {
                isLoading = true;
            },
            success: function (data) {
                // 缓存数据
                if (cacheKey) {
                    dataCache[cacheKey] = data;
                }
                callback(data);
            },
            error: function (xhr, status, error) {
                console.error('请求失败:', error);
                // 简单错误提示，避免频繁弹窗
                var chartId = cacheKey ? cacheKey.replace(/[^a-zA-Z0-9-]/g, '-') : '';
                var chart = charts[chartId + '-chart'];
                if (chart) {
                    chart.showLoading('default', {
                        text: '加载失败',
                        color: '#1890ff',
                        textColor: '#333',
                        maskColor: 'rgba(255, 255, 255, 0.8)',
                        zlevel: 0
                    });
                }
            },
            complete: function () {
                isLoading = false;
            },
            timeout: 10000 // 设置超时时间
        });
    }

    // 加载库存概览统计
    function loadOverviewStats() {
        ajaxRequest('/goods/admin/stock/report/overview', function (data) {
            var statsHtml = '';
            statsHtml += '<div class="stat-card">';
            statsHtml += '    <div class="number">' + data.totalProducts + '</div>';
            statsHtml += '    <div class="label">商品总数</div>';
            statsHtml += '</div>';
            statsHtml += '<div class="stat-card">';
            statsHtml += '    <div class="number">' + data.totalStock + '</div>';
            statsHtml += '    <div class="label">库存总量</div>';
            statsHtml += '</div>';
            statsHtml += '<div class="stat-card">';
            statsHtml += '    <div class="number" class="stock-status-low">' + data.lowStockCount + '</div>';
            statsHtml += '    <div class="label">低库存商品</div>';
            statsHtml += '</div>';
            statsHtml += '<div class="stat-card">';
            statsHtml += '    <div class="number">' + data.averageStock + '</div>';
            statsHtml += '    <div class="label">平均库存</div>';
            statsHtml += '</div>';
            $('#overview-stats').html(statsHtml);
        }, 'overview');
    }

    // 加载库存状态分布
    function loadStatusDistribution() {
        var chart = charts['status-distribution-chart'];
        if (!chart) return;

        chart.showLoading();

        ajaxRequest('/goods/admin/stock/report/status-distribution', function (data) {
            var pieData = data.map(item => ({
                value: item.count,
                name: item.categoryName,
                itemStyle: {
                    color: item.color || '#1890ff'
                }
            }));

            chart.setOption({
                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b}: {c} ({d}%)'
                },
                legend: {
                    orient: 'vertical',
                    left: 10,
                    data: data.map(item => item.categoryName)
                },
                series: [{
                    name: '库存状态',
                    type: 'pie',
                    radius: '50%',
                    data: pieData,
                    emphasis: {
                        itemStyle: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        }
                    }
                }]
            });

            chart.hideLoading();
        }, 'status-distribution');
    }

    // 加载库存预警级别分布
    function loadWarningDistribution() {
        var chart = charts['warning-distribution-chart'];
        if (!chart) return;

        chart.showLoading();

        ajaxRequest('/goods/admin/stock/report/warning-distribution', function (data) {
            var pieData = data.map(item => ({
                value: item.count,
                name: item.categoryName,
                itemStyle: {
                    color: item.color || '#1890ff'
                }
            }));

            chart.setOption({
                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b}: {c} ({d}%)'
                },
                legend: {
                    orient: 'vertical',
                    left: 10,
                    data: data.map(item => item.categoryName)
                },
                series: [{
                    name: '预警级别',
                    type: 'pie',
                    radius: '50%',
                    data: pieData,
                    emphasis: {
                        itemStyle: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        }
                    }
                }]
            });

            chart.hideLoading();
        }, 'warning-distribution');
    }

    // 加载库存数量范围分布
    function loadQuantityRangeDistribution() {
        var chart = charts['quantity-range-chart'];
        if (!chart) return;

        chart.showLoading();

        ajaxRequest('/goods/admin/stock/report/quantity-range', function (data) {
            chart.setOption({
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    }
                },
                xAxis: {
                    type: 'category',
                    data: data.map(item => item.categoryName)
                },
                yAxis: {
                    type: 'value'
                },
                series: [{
                    data: data.map(item => ({
                        value: item.count,
                        itemStyle: {
                            color: item.color || '#1890ff'
                        }
                    })),
                    type: 'bar'
                }]
            });

            chart.hideLoading();
        }, 'quantity-range');
    }

    // 加载库存变化趋势
    function loadStockTrend() {
        var chart = charts['trend-chart'];
        if (!chart) return;

        chart.showLoading();

        var days = $('#trend-days').val();
        // 为不同时间范围生成不同的缓存键
        var cacheKey = 'trend_' + days;

        ajaxRequest('/goods/admin/stock/report/trend?days=' + days, function (data) {
            chart.setOption({
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: ['库存总量']
                },
                xAxis: {
                    type: 'category',
                    data: data.map(item => item.date)
                },
                yAxis: {
                    type: 'value'
                },
                series: [{
                    name: '库存总量',
                    data: data.map(item => item.value),
                    type: 'line',
                    smooth: true,
                    itemStyle: {
                        color: '#1890ff'
                    },
                    areaStyle: {
                        color: {
                            type: 'linear',
                            x: 0, y: 0, x2: 0, y2: 1,
                            colorStops: [{
                                offset: 0, color: 'rgba(24, 144, 255, 0.3)'
                            }, {
                                offset: 1, color: 'rgba(24, 144, 255, 0.1)'
                            }]
                        }
                    }
                }]
            });

            chart.hideLoading();
        }, cacheKey);
    }

    // 加载库存周转率
    function loadStockTurnover() {
        var chart = charts['turnover-chart'];
        if (!chart) return;

        chart.showLoading();

        ajaxRequest('/goods/admin/stock/report/turnover', function (data) {
            chart.setOption({
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    }
                },
                xAxis: {
                    type: 'category',
                    data: data.map(item => item.categoryName)
                },
                yAxis: {
                    type: 'value',
                    name: '周转率(次)'
                },
                series: [{
                    data: data.map(item => item.turnoverRate),
                    type: 'bar',
                    itemStyle: {
                        color: function (params) {
                            var value = params.value;
                            if (value > 12) return '#52c41a'; // 良好
                            if (value > 6) return '#faad14';  // 一般
                            return '#f5222d';  // 较差
                        }
                    },
                    label: {
                        show: true,
                        position: 'top',
                        formatter: '{c}'
                    }
                }]
            });

            chart.hideLoading();
        }, 'turnover');
    }

    // 刷新所有数据
    function refreshAllData() {
        // 清空缓存
        dataCache = {};

        // 重新加载数据，使用错开的时间避免并发请求
        loadOverviewStats();
        setTimeout(function () {
            Object.keys(charts).forEach(function (chartId, index) {
                setTimeout(function () {
                    switch (chartId) {
                        case 'status-distribution-chart':
                            loadStatusDistribution();
                            break;
                        case 'warning-distribution-chart':
                            loadWarningDistribution();
                            break;
                        case 'quantity-range-chart':
                            loadQuantityRangeDistribution();
                            break;
                        case 'turnover-chart':
                            loadStockTurnover();
                            break;
                        case 'trend-chart':
                            loadStockTrend();
                            break;
                    }
                }, index * 100);
            });
        }, 200);
    }

    // 响应式调整，使用防抖优化
    var resizeTimer;
    window.addEventListener('resize', function () {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function () {
            Object.values(charts).forEach(function (chart) {
                chart.resize();
            });
        }, 100);
    });

    // 页面卸载时销毁图表实例，释放资源
    window.addEventListener('beforeunload', function () {
        if (lazyLoadTimer) {
            clearTimeout(lazyLoadTimer);
        }
        Object.values(charts).forEach(function (chart) {
            chart.dispose();
        });
    });
</script>
</body>

</html>