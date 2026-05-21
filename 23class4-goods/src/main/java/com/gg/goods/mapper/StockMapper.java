package com.gg.goods.mapper;

import com.gg.goods.entity.Stock;

import java.util.List;
import java.util.Map;

/**
 * 库存数据访问层接口
 */
public interface StockMapper {
    /**
     * 根据主键删除库存记录
     */
    int deleteByPrimaryKey(String sid);

    /**
     * 插入新的库存记录
     */
    int insert(Stock record);

    /**
     * 选择性插入库存记录
     */
    int insertSelective(Stock record);

    /**
     * 根据主键查询库存记录
     */
    Stock selectByPrimaryKey(String sid);

    /**
     * 根据图书ID查询库存记录 - 管理员专用
     */
    Stock selectByBid(String bid);

    /**
     * 根据图书ID更新库存数量并设置状态 - 管理员专用
     */
    int updateQuantityByBid(Stock record);

    /**
     * 更新库存信息（包括数量、最低预警值和状态）- 管理员专用
     */
    int updateStockInfo(Stock record);

    /**
     * 查询所有库存记录，按更新时间降序排序 - 管理员专用
     */
    List<Stock> selectAllStocks();

    /**
     * 查询库存不足的图书，按数量升序排序 - 管理员专用
     */
    List<Stock> selectLowStocks();

    /**
     * 批量更新库存状态 - 管理员专用
     */
    int batchUpdateStockStatus(Map<String, Object> params);

    /**
     * 根据书名模糊查询库存 - 管理员专用
     */
    List<Stock> searchStockByBookName(String keyword);

    /**
     * 选择性更新库存记录
     */
    int updateByPrimaryKeySelective(Stock record);

    /**
     * 更新库存记录
     */
    int updateByPrimaryKey(Stock record);
}