package com.gg.goods.povos;

import com.gg.goods.entity.Stock;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 库存视图对象，用于管理员界面展示
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class StockVO extends Stock {
    /**
     * 库存状态描述
     */
    private String statusDesc;

    /**
     * 库存预警状态描述
     */
    private String warningStatus;

    /**
     * 构造方法，从Stock实体转换为StockVO
     */
    public StockVO(Stock stock) {
        if (stock != null) {
            this.setSid(stock.getSid());
            this.setBid(stock.getBid());
            this.setBname(stock.getBname());
            this.setQuantity(stock.getQuantity());
            this.setMinQuantity(stock.getMinQuantity());
            this.setStatus(stock.getStatus());
            this.setUpdateTime(stock.getUpdateTime());

            // 设置状态描述 - 修正逻辑：1=正常，0=不足
            this.statusDesc = stock.getStatus() == 1 ? "正常" : "不足";

            // 设置预警状态描述
            if (stock.getQuantity() <= stock.getMinQuantity()) {
                this.warningStatus = "库存不足";
            } else if (stock.getQuantity() <= stock.getMinQuantity() * 1.2) {
                this.warningStatus = "即将不足";
            } else {
                this.warningStatus = "库存充足";
            }
        }
    }
}