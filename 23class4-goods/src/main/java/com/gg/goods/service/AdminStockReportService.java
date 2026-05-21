package com.gg.goods.service;

import com.gg.goods.povos.StockReportPO;

import java.util.List;
import java.util.Map;

/**
 * 库存报表服务接口
 * 提供库存统计和分析功能
 */
public interface AdminStockReportService {

    /**
     * 获取库存概览统计数据
     *
     * @return 包含总库存量、商品种类数、低库存数量等统计信息的Map
     */
    Map<String, Object> getStockOverviewStats();

    /**
     * 获取库存状态分布数据
     *
     * @return 包含正常、不足等不同状态的商品数量分布
     */
    List<StockReportPO> getStockStatusDistribution();

    /**
     * 获取库存预警级别分布
     *
     * @return 包含充足、即将不足、不足等不同预警级别的数量分布
     */
    List<StockReportPO> getStockWarningDistribution();

    /**
     * 获取库存数量范围分布
     *
     * @return 不同库存数量区间的商品分布
     */
    List<StockReportPO> getStockQuantityRangeDistribution();

    /**
     * 获取近期库存变化趋势数据
     *
     * @param days 查询天数
     * @return 按日期统计的库存变化数据
     */
    List<StockReportPO> getStockTrendByDays(int days);

    /**
     * 获取库存周转率数据（模拟）
     *
     * @return 不同商品的库存周转情况
     */
    List<Map<String, Object>> getStockTurnoverData();
}
