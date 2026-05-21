package com.gg.goods.povos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 库存报表数据对象
 * 用于封装各类库存统计和分析数据
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StockReportPO {
    /**
     * 类别名称（如状态名称、预警级别、数量范围等）
     */
    private String categoryName;

    /**
     * 数量
     */
    private Integer count;

    /**
     * 百分比
     */
    private Double percentage;

    /**
     * 数值（可选，用于趋势图表）
     */
    private Double value;

    /**
     * 日期（可选，用于趋势图表）
     */
    private String date;

    /**
     * 颜色代码（可选，用于图表展示）
     */
    private String color;
}
