package com.gg.goods.service.impl;

import com.gg.goods.entity.Stock;
import com.gg.goods.mapper.StockMapper;
import com.gg.goods.povos.StockReportPO;
import com.gg.goods.service.AdminStockReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 库存报表服务实现类
 */
@Service
public class AdminStockReportServiceImpl implements AdminStockReportService {

    @Autowired
    private StockMapper stockMapper;

    @Override
    public Map<String, Object> getStockOverviewStats() {
        Map<String, Object> stats = new HashMap<>();

        // 获取所有库存数据
        List<Stock> stocks = stockMapper.selectAllStocks();
        int totalCount = stocks.size();
        int totalQuantity = 0;
        int lowStockCount = 0;
        int normalStockCount = 0;

        // 统计数据
        for (Stock stock : stocks) {
            totalQuantity += stock.getQuantity();
            if (stock.getStatus() == 1) {
                normalStockCount++;
            } else {
                lowStockCount++;
            }
        }

        // 计算平均库存
        double avgQuantity = totalCount > 0 ? (double) totalQuantity / totalCount : 0;

        // 组装结果
        stats.put("totalCount", totalCount);
        stats.put("totalQuantity", totalQuantity);
        stats.put("normalStockCount", normalStockCount);
        stats.put("lowStockCount", lowStockCount);
        stats.put("avgQuantity", Math.round(avgQuantity * 100) / 100.0);

        return stats;
    }

    @Override
    public List<StockReportPO> getStockStatusDistribution() {
        List<StockReportPO> result = new ArrayList<>();
        List<Stock> stocks = stockMapper.selectAllStocks();
        int total = stocks.size();

        // 统计不同状态的数量
        Map<Integer, Integer> statusCount = new HashMap<>();
        statusCount.put(1, 0); // 正常
        statusCount.put(0, 0); // 不足

        for (Stock stock : stocks) {
            statusCount.put(stock.getStatus(), statusCount.get(stock.getStatus()) + 1);
        }

        // 创建报表对象
        StockReportPO normalStock = new StockReportPO();
        normalStock.setCategoryName("正常库存");
        normalStock.setCount(statusCount.get(1));
        normalStock.setPercentage(total > 0 ? (double) statusCount.get(1) / total * 100 : 0);
        normalStock.setColor("#4CAF50");
        result.add(normalStock);

        StockReportPO lowStock = new StockReportPO();
        lowStock.setCategoryName("低库存");
        lowStock.setCount(statusCount.get(0));
        lowStock.setPercentage(total > 0 ? (double) statusCount.get(0) / total * 100 : 0);
        lowStock.setColor("#F44336");
        result.add(lowStock);

        return result;
    }

    @Override
    public List<StockReportPO> getStockWarningDistribution() {
        List<StockReportPO> result = new ArrayList<>();
        List<Stock> stocks = stockMapper.selectAllStocks();
        int total = stocks.size();

        // 统计不同预警级别的数量
        Map<String, Integer> warningCount = new HashMap<>();
        warningCount.put("充足", 0);
        warningCount.put("即将不足", 0);
        warningCount.put("不足", 0);

        for (Stock stock : stocks) {
            if (stock.getQuantity() <= stock.getMinQuantity()) {
                warningCount.put("不足", warningCount.get("不足") + 1);
            } else if (stock.getQuantity() <= stock.getMinQuantity() * 1.2) {
                warningCount.put("即将不足", warningCount.get("即将不足") + 1);
            } else {
                warningCount.put("充足", warningCount.get("充足") + 1);
            }
        }

        // 创建报表对象
        result.add(new StockReportPO("充足", warningCount.get("充足"),
                total > 0 ? (double) warningCount.get("充足") / total * 100 : 0, null, null, "#4CAF50"));
        result.add(new StockReportPO("即将不足", warningCount.get("即将不足"),
                total > 0 ? (double) warningCount.get("即将不足") / total * 100 : 0, null, null, "#FF9800"));
        result.add(new StockReportPO("不足", warningCount.get("不足"),
                total > 0 ? (double) warningCount.get("不足") / total * 100 : 0, null, null, "#F44336"));

        return result;
    }

    @Override
    public List<StockReportPO> getStockQuantityRangeDistribution() {
        List<StockReportPO> result = new ArrayList<>();
        List<Stock> stocks = stockMapper.selectAllStocks();
        int total = stocks.size();

        // 定义库存范围
        Map<String, Integer> rangeCount = new HashMap<>();
        rangeCount.put("0-10", 0);
        rangeCount.put("11-50", 0);
        rangeCount.put("51-100", 0);
        rangeCount.put("101-200", 0);
        rangeCount.put("201+", 0);

        // 统计各范围数量
        for (Stock stock : stocks) {
            int quantity = stock.getQuantity();
            if (quantity <= 10) {
                rangeCount.put("0-10", rangeCount.get("0-10") + 1);
            } else if (quantity <= 50) {
                rangeCount.put("11-50", rangeCount.get("11-50") + 1);
            } else if (quantity <= 100) {
                rangeCount.put("51-100", rangeCount.get("51-100") + 1);
            } else if (quantity <= 200) {
                rangeCount.put("101-200", rangeCount.get("101-200") + 1);
            } else {
                rangeCount.put("201+", rangeCount.get("201+") + 1);
            }
        }

        // 创建报表对象
        result.add(new StockReportPO("0-10", rangeCount.get("0-10"),
                total > 0 ? (double) rangeCount.get("0-10") / total * 100 : 0, null, null, "#F44336"));
        result.add(new StockReportPO("11-50", rangeCount.get("11-50"),
                total > 0 ? (double) rangeCount.get("11-50") / total * 100 : 0, null, null, "#FF9800"));
        result.add(new StockReportPO("51-100", rangeCount.get("51-100"),
                total > 0 ? (double) rangeCount.get("51-100") / total * 100 : 0, null, null, "#FFEB3B"));
        result.add(new StockReportPO("101-200", rangeCount.get("101-200"),
                total > 0 ? (double) rangeCount.get("101-200") / total * 100 : 0, null, null, "#8BC34A"));
        result.add(new StockReportPO("201+", rangeCount.get("201+"),
                total > 0 ? (double) rangeCount.get("201+") / total * 100 : 0, null, null, "#4CAF50"));

        return result;
    }

    @Override
    public List<StockReportPO> getStockTrendByDays(int days) {
        List<StockReportPO> result = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();

        // 生成过去N天的日期和模拟数据
        for (int i = days - 1; i >= 0; i--) {
            calendar.add(Calendar.DAY_OF_MONTH, -1);
            String date = sdf.format(calendar.getTime());

            // 模拟库存总量变化趋势（基于当前数据，添加一些随机波动）
            double baseValue = 1000; // 基础值
            double randomVariation = (Math.random() - 0.5) * 200; // -100到+100的随机变化
            double trend = i * 10; // 简单的上升趋势
            double value = baseValue + randomVariation + trend;

            result.add(new StockReportPO(null, null, null, value, date, null));
        }

        return result;
    }

    @Override
    public List<Map<String, Object>> getStockTurnoverData() {
        List<Map<String, Object>> result = new ArrayList<>();
        List<Stock> stocks = stockMapper.selectAllStocks();

        // 取前10个商品作为样本，生成模拟的周转率数据
        int limit = Math.min(10, stocks.size());
        for (int i = 0; i < limit; i++) {
            Stock stock = stocks.get(i);
            Map<String, Object> data = new HashMap<>();

            // 基本信息
            data.put("bname", stock.getBname());
            data.put("currentStock", stock.getQuantity());

            // 模拟数据
            double monthlySales = Math.random() * 50 + 10; // 10-60之间的模拟月销量
            double turnoverRate = stock.getQuantity() > 0 ? monthlySales / stock.getQuantity() * 30 : 0; // 30天周转率
            double avgStayDays = turnoverRate > 0 ? 30 / turnoverRate : Double.MAX_VALUE; // 平均停留天数

            data.put("monthlySales", Math.round(monthlySales * 100) / 100.0);
            data.put("turnoverRate", Math.round(turnoverRate * 100) / 100.0);
            data.put("avgStayDays", avgStayDays == Double.MAX_VALUE ? "无限" : Math.round(avgStayDays * 100) / 100.0);

            result.add(data);
        }

        // 按周转率排序
        result.sort((a, b) -> {
            double rateA = (double) a.get("turnoverRate");
            double rateB = (double) b.get("turnoverRate");
            return Double.compare(rateB, rateA); // 降序排列
        });

        return result;
    }
}
