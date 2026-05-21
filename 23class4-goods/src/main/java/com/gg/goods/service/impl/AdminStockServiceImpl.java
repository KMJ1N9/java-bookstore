package com.gg.goods.service.impl;

import com.gg.goods.entity.Stock;
import com.gg.goods.mapper.StockMapper;
import com.gg.goods.povos.StockVO;
import com.gg.goods.service.AdminStockService;
import com.gg.goods.service.SystemLogService;
import com.github.pagehelper.PageHelper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 管理员库存服务实现类
 */
@Service
public class AdminStockServiceImpl implements AdminStockService {

    @Autowired
    private StockMapper stockMapper;

    @Autowired
    private SystemLogService systemLogService;

    @Override
    public List<StockVO> getAllStockVOsByPage(int pageNum, int pageSize) {
        // 参数验证
        if (pageNum <= 0) {
            pageNum = 1;
        }
        if (pageSize <= 0) {
            pageSize = 10;
        }
        if (pageSize > 100) {
            pageSize = 100;
        }

        // 启动分页
        PageHelper.startPage(pageNum, pageSize);

        // 查询数据
        List<Stock> stocks = stockMapper.selectAllStocks();
        List<StockVO> stockVOs = new ArrayList<>();

        for (Stock stock : stocks) {
            stockVOs.add(new StockVO(stock));
        }

        return stockVOs;
    }

    @Override
    public List<StockVO> getLowStockVOsByPage(int pageNum, int pageSize) {
        // 参数验证
        if (pageNum <= 0) {
            pageNum = 1;
        }
        if (pageSize <= 0) {
            pageSize = 10;
        }
        if (pageSize > 100) {
            pageSize = 100;
        }

        // 启动分页
        PageHelper.startPage(pageNum, pageSize);

        // 查询数据
        List<Stock> stocks = stockMapper.selectLowStocks();
        List<StockVO> stockVOs = new ArrayList<>();

        for (Stock stock : stocks) {
            stockVOs.add(new StockVO(stock));
        }

        return stockVOs;
    }

    @Override
    public List<StockVO> searchStockByBookNameByPage(String keyword, int pageNum, int pageSize) {
        // 参数验证
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }
        if (pageNum <= 0) {
            pageNum = 1;
        }
        if (pageSize <= 0) {
            pageSize = 10;
        }
        if (pageSize > 100) {
            pageSize = 100;
        }

        // 启动分页
        PageHelper.startPage(pageNum, pageSize);

        // 查询数据
        List<Stock> stocks = stockMapper.searchStockByBookName(keyword);
        List<StockVO> stockVOs = new ArrayList<>();

        for (Stock stock : stocks) {
            stockVOs.add(new StockVO(stock));
        }

        return stockVOs;
    }

    @Override
    public List<StockVO> getAllStockVOs() {
        List<Stock> stocks = stockMapper.selectAllStocks();
        List<StockVO> stockVOs = new ArrayList<>();

        for (Stock stock : stocks) {
            stockVOs.add(new StockVO(stock));
        }

        return stockVOs;
    }

    @Override
    public List<StockVO> getLowStockVOs() {
        List<Stock> stocks = stockMapper.selectLowStocks();
        List<StockVO> stockVOs = new ArrayList<>();

        for (Stock stock : stocks) {
            stockVOs.add(new StockVO(stock));
        }

        return stockVOs;
    }

    @Override
    public Stock getStockByBid(String bid) {
        return stockMapper.selectByBid(bid);
    }

    @Transactional
    @Override
    public int adminUpdateStockQuantity(String bid, Integer quantity, HttpServletRequest request) {
        try {
            Stock stock = stockMapper.selectByBid(bid);
            if (stock == null) {
                return 0;
            }

            // 记录操作前的数量
            Integer oldQuantity = stock.getQuantity();

            // 创建Stock对象并设置必要字段
            Stock updateStock = new Stock();
            updateStock.setBid(bid);
            updateStock.setQuantity(quantity);
            updateStock.setMinQuantity(stock.getMinQuantity());
            updateStock.setUpdateTime(new Date());

            int result = stockMapper.updateQuantityByBid(updateStock);

            if (result > 0) {
                // 记录操作日志
                String operator = "system"; // 可以从session中获取实际管理员信息
                String action = "更新库存数量：商品ID=" + bid + ", 原数量=" + oldQuantity + ", 新数量=" + quantity;
                String status = "success";

                systemLogService.recordLog(operator, action, status, bid, request);

                // 更新库存状态
                refreshStockStatus(bid);
            }

            return result;
        } catch (Exception e) {
            // 记录错误日志
            String operator = "system";
            String action = "更新库存数量失败：商品ID=" + bid + ", 目标数量=" + quantity;
            String status = "error";

            systemLogService.recordLog(operator, action + ", 错误：" + e.getMessage(), status, bid, request);

            throw e; // 重新抛出异常以便事务回滚
        }
    }

    @Transactional
    @Override
    public int adminUpdateStockInfo(Stock stock, HttpServletRequest request) {
        try {
            int result = stockMapper.updateByPrimaryKeySelective(stock);

            if (result > 0) {
                // 记录操作日志
                String operator = "system";
                String action = "更新库存信息：商品ID=" + stock.getBid() + ", 最低预警值=" + stock.getMinQuantity();
                String status = "success";

                systemLogService.recordLog(operator, action, status, stock.getBid(), request);

                // 更新库存状态
                refreshStockStatus(stock.getBid());
            }

            return result;
        } catch (Exception e) {
            // 记录错误日志
            String operator = "system";
            String action = "更新库存信息失败：商品ID=" + stock.getBid();
            String status = "error";

            systemLogService.recordLog(operator, action + ", 错误：" + e.getMessage(), status, stock.getBid(), request);

            throw e;
        }
    }

    @Transactional
    @Override
    public int batchUpdateStockStatus(Map<String, Object> params, HttpServletRequest request) {
        try {
            List<String> sids = (List<String>) params.get("sids");
            Integer status = (Integer) params.get("status");

            int result = stockMapper.batchUpdateStockStatus(params);

            if (result > 0) {
                // 记录操作日志
                String operator = "system";
                String action = "批量更新库存状态：数量=" + sids.size() + ", 目标状态=" + status;
                String statusStr = "success";

                systemLogService.recordLog(operator, action, statusStr, sids.toString(), request);
            }

            return result;
        } catch (Exception e) {
            // 记录错误日志
            String operator = "system";
            String action = "批量更新库存状态失败";
            String statusStr = "error";

            systemLogService.recordLog(operator, action + ", 错误：" + e.getMessage(), statusStr, null, request);

            throw e;
        }
    }

    @Override
    public List<StockVO> searchStockByBookName(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }

        List<Stock> stocks = stockMapper.searchStockByBookName(keyword);
        List<StockVO> stockVOs = new ArrayList<>();

        for (Stock stock : stocks) {
            stockVOs.add(new StockVO(stock));
        }

        return stockVOs;
    }

    @Transactional
    @Override
    public void refreshAllStockStatus(HttpServletRequest request) {
        try {
            List<Stock> stocks = stockMapper.selectAllStocks();
            int updatedCount = 0;

            for (Stock stock : stocks) {
                int result = refreshStockStatus(stock.getBid());
                if (result > 0) {
                    updatedCount++;
                }
            }

            // 记录操作日志
            String operator = "system";
            String action = "刷新所有库存状态，成功更新" + updatedCount + "条记录";
            String status = "success";

            systemLogService.recordLog(operator, action, status, null, request);
        } catch (Exception e) {
            // 记录错误日志
            String operator = "system";
            String action = "刷新所有库存状态失败";
            String status = "error";

            systemLogService.recordLog(operator, action + ", 错误：" + e.getMessage(), status, null, request);

            throw e;
        }
    }

    // 重载方法，兼容原有调用
    @Override
    public int adminUpdateStockQuantity(String bid, Integer quantity) {
        return adminUpdateStockQuantity(bid, quantity, null);
    }

    @Override
    public int adminUpdateStockInfo(Stock stock) {
        return adminUpdateStockInfo(stock, null);
    }

    @Override
    public int batchUpdateStockStatus(Map<String, Object> params) {
        return batchUpdateStockStatus(params, null);
    }

    @Override
    public void refreshAllStockStatus() {
        refreshAllStockStatus(null);
    }

    /**
     * 更新单个库存的状态
     *
     * @param bid 商品ID
     * @return 更新结果
     */
    private int refreshStockStatus(String bid) {
        Stock stock = stockMapper.selectByBid(bid);
        if (stock == null) {
            return 0;
        }

        Integer status = calculateStockStatus(stock.getQuantity(), stock.getMinQuantity());
        stock.setStatus(status);
        stock.setUpdateTime(new Date());

        return stockMapper.updateByPrimaryKeySelective(stock);
    }

    /**
     * 计算库存状态
     *
     * @param quantity    当前库存
     * @param minQuantity 最低预警值
     * @return 状态值（1-正常，0-不足）
     */
    private Integer calculateStockStatus(Integer quantity, Integer minQuantity) {
        if (quantity <= minQuantity) {
            return 0; // 库存不足
        }
        return 1; // 库存正常
    }
}