package com.gg.goods.service;

import com.gg.goods.entity.Stock;
import com.gg.goods.povos.StockVO;
import jakarta.servlet.http.HttpServletRequest;

import java.util.List;
import java.util.Map;

/**
 * 管理员库存服务接口
 */
public interface AdminStockService {

    // 分页查询方法
    List<StockVO> getAllStockVOsByPage(int pageNum, int pageSize);

    List<StockVO> getLowStockVOsByPage(int pageNum, int pageSize);

    List<StockVO> searchStockByBookNameByPage(String keyword, int pageNum, int pageSize);

    // 非分页查询方法
    List<StockVO> getAllStockVOs();

    List<StockVO> getLowStockVOs();

    Stock getStockByBid(String bid);

    // 带请求参数的操作方法（带日志记录）
    int adminUpdateStockQuantity(String bid, Integer quantity, HttpServletRequest request);

    int adminUpdateStockInfo(Stock stock, HttpServletRequest request);

    int batchUpdateStockStatus(Map<String, Object> params, HttpServletRequest request);

    void refreshAllStockStatus(HttpServletRequest request);

    // 原有的操作方法（兼容旧代码）
    int adminUpdateStockQuantity(String bid, Integer quantity);

    int adminUpdateStockInfo(Stock stock);

    int batchUpdateStockStatus(Map<String, Object> params);

    void refreshAllStockStatus();

    // 搜索方法
    List<StockVO> searchStockByBookName(String keyword);
}