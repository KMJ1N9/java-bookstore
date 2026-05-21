package com.gg.goods.entity;

import lombok.Data;

import java.util.Date;

/**
 * 系统日志实体类
 * 用于记录系统中的关键操作和事件
 */
@Data
public class SystemLog {
    /**
     * 日志ID
     */
    private String id;

    /**
     * 操作时间
     */
    private Date operateTime;

    /**
     * 操作用户（可以是普通用户、管理员或系统）
     */
    private String operator;

    /**
     * 操作内容描述
     */
    private String action;

    /**
     * 操作状态（success、warning、error等）
     */
    private String status;

    /**
     * 相关联的业务ID（如订单号、商品ID等）
     */
    private String businessId;

    /**
     * 操作IP地址
     */
    private String ip;
}
