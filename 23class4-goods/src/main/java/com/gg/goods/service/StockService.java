package com.gg.goods.service;

import com.gg.goods.entity.Stock;
import com.gg.goods.mapper.StockMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
public class StockService {
    @Autowired
    private StockMapper stockMapper;

    /*根据图书ID获取库存信息*/
    @Cacheable(value = "stock", key = "#bid")
    public Stock getStockByBid(String bid) {
        return stockMapper.selectByBid(bid);
    }

    /*创建库存记录*/
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "stock", key = "#stock.bid"),
            @CacheEvict(value = "stockList", allEntries = true)
    })
    public int createStock(Stock stock) {
        // 生成唯一ID
        stock.setSid(UUID.randomUUID().toString());
        // 设置实时库存更新时间
        stock.setUpdateTime(new Date());
        // 设置库存状态
        if (stock.getQuantity() < stock.getMinQuantity()) {
            stock.setStatus(0); // 库存不足
        } else {
            stock.setStatus(1); // 库存正常
        }
        return stockMapper.insertSelective(stock);
    }

    /*更新库存数量*/
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "stock", key = "#bid"),
            @CacheEvict(value = "stockList", allEntries = true)
    })
    public int updateStockQuantity(String bid, Integer quantity) {
        Stock stock = stockMapper.selectByBid(bid);
        if (stock != null) {
            stock.setQuantity(quantity);
            // 设置实时库存更新时间
            stock.setUpdateTime(new Date());
            // 更新状态
            if (quantity < stock.getMinQuantity()) {
                stock.setStatus(0);
            } else {
                stock.setStatus(1);
            }
            return stockMapper.updateQuantityByBid(stock);
        }
        return 0;
    }

    /*修改库存预警值*/
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "stock", key = "#bid"),
            @CacheEvict(value = "stockList", allEntries = true)
    })
    public int updateMinQuantity(String bid, Integer minQuantity) {
        Stock stock = stockMapper.selectByBid(bid);
        if (stock != null) {
            stock.setMinQuantity(minQuantity);
            // 设置实时库存更新时间
            stock.setUpdateTime(new Date());
            // 重新判断库存状态
            if (stock.getQuantity() < minQuantity) {
                stock.setStatus(0);
            } else {
                stock.setStatus(1);
            }
            return stockMapper.updateByPrimaryKeySelective(stock);
        }
        return 0;
    }

    /*增加库存*/
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "stock", key = "#bid"),
            @CacheEvict(value = "stockList", allEntries = true)
    })
    public int increaseStock(String bid, Integer quantity) {
        Stock stock = stockMapper.selectByBid(bid);
        if (stock != null) {
            int newQuantity = stock.getQuantity() + quantity;
            return updateStockQuantity(bid, newQuantity);
        }
        return 0;
    }

    /*减少库存（用于销售）*/
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "stock", key = "#bid"),
            @CacheEvict(value = "stockList", allEntries = true)
    })
    public int decreaseStock(String bid, Integer quantity) {
        Stock stock = stockMapper.selectByBid(bid);
        if (stock != null && stock.getQuantity() >= quantity) {
            int newQuantity = stock.getQuantity() - quantity;
            return updateStockQuantity(bid, newQuantity);
        }
        return 0; // 库存不足
    }

    /*获取所有库存信息*/
    @Cacheable(value = "stockList", key = "'all'")
    public List<Stock> getAllStocks() {
        return stockMapper.selectAllStocks();
    }

    /*获取库存不足的图书*/
    @Cacheable(value = "stockList", key = "'low'")
    public List<Stock> getLowStocks() {
        return stockMapper.selectLowStocks();
    }

    /*检查并更新所有库存状态*/
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "stock", allEntries = true),
            @CacheEvict(value = "stockList", allEntries = true)
    })
    public void checkAndUpdateStockStatus() {
        List<Stock> stocks = stockMapper.selectAllStocks();
        for (Stock stock : stocks) {
            if (stock.getQuantity() < stock.getMinQuantity() && stock.getStatus() != 0) {
                // 库存不足但状态不是不足，更新为不足(0)
                stock.setStatus(0);
                // 设置实时库存更新时间
                stock.setUpdateTime(new Date());
                stockMapper.updateByPrimaryKeySelective(stock);
            } else if (stock.getQuantity() >= stock.getMinQuantity() && stock.getStatus() != 1) {
                // 库存充足但状态不是正常，更新为正常(1)
                stock.setStatus(1);
                // 设置实时库存更新时间
                stock.setUpdateTime(new Date());
                stockMapper.updateByPrimaryKeySelective(stock);
            }
        }
    }

    /*删除库存记录*/
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "stock", key = "#bid"),
            @CacheEvict(value = "stockList", allEntries = true)
    })
    public int deleteStock(String bid) {
        // 根据bid删除库存记录
        return stockMapper.deleteByPrimaryKey(bid);
    }
}