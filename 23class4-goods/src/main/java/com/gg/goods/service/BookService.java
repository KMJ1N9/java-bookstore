package com.gg.goods.service;

import com.gg.goods.entity.Book;
import com.gg.goods.entity.Stock;
import com.gg.goods.mapper.BookMapper;
import com.gg.goods.mapper.StockMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class BookService {
    @Autowired
    private BookMapper bookMapper;

    @Autowired
    private StockMapper stockMapper;

    /*多条件查询多本  动态SQL*/
    public List<Book> getBooksByCase(Book book) {
        return bookMapper.selectBooksByCase(book);
    }

    /*根据ID获取图书*/
    @Cacheable(value = "books", key = "#bid", sync = true)
    public Book getBookByBid(String bid) {
        return bookMapper.selectByPrimaryKey(bid);
    }

    /*创建图书*/
    @Caching(evict = {
            @CacheEvict(value = "books", key = "'newest_'.concat(#root.methodName)"),
            @CacheEvict(value = "books", key = "'hot_'.concat(#root.methodName)")
    })
    @Transactional
    public int createBook(Book book) {
        int result = bookMapper.insertSelective(book);

        // 添加图书成功后，同时创建库存记录
        if (result > 0) {
            Stock stock = new Stock();
            stock.setSid(UUID.randomUUID().toString().replace("-", ""));
            stock.setBid(book.getBid());
            stock.setBname(book.getBname());
            stock.setQuantity(0); // 初始库存为0
            stock.setMinQuantity(10); // 默认最低库存预警为10
            stock.setStatus(1); // 初始状态为正常
            stock.setUpdateTime(new java.util.Date());

            stockMapper.insertSelective(stock);
        }

        return result;
    }

    /*更新图书信息*/
    @Caching(evict = {
            @CacheEvict(value = "books", key = "#book.bid"),
            @CacheEvict(value = "books", key = "'booksByCid_'.concat(#book.cid)")
    })
    public int updateBook(Book book) {
        return bookMapper.updateByPrimaryKeySelective(book);
    }

    /*删除图书*/
    @Caching(evict = {
            @CacheEvict(value = "books", key = "#bid"),
            @CacheEvict(value = "books", allEntries = true, cacheResolver = "booksCacheResolver")
    })
    @Transactional
    public int deleteBook(String bid) {
        // 先根据bid查询库存记录
        Stock stock = stockMapper.selectByBid(bid);
        if (stock != null) {
            // 使用库存记录的主键删除库存
            stockMapper.deleteByPrimaryKey(stock.getSid());
        }
        // 然后删除图书
        // 将String类型的bid转换为Long类型
        return bookMapper.deleteByPrimaryKey(Long.valueOf(bid));
    }

    /*根据分类ID查询图书*/
    @Cacheable(value = "books", key = "'booksByCid_'.concat(#cid)", sync = true)
    public List<Book> getBooksByCid(String cid) {
        return bookMapper.selectBooksByCid(cid);
    }

    /*搜索图书（根据书名）*/
    public List<Book> searchBooks(String keyword) {
        return bookMapper.selectBooksByBname(keyword);
    }

    /*获取最新上架的图书*/
    @Cacheable(value = "books", key = "'newest_'.concat(#limit)", sync = true)
    public List<Book> getNewestBooks(Integer limit) {
        return bookMapper.selectNewestBooks(limit);
    }

    /*获取热门图书*/
    @Cacheable(value = "books", key = "'hot_'.concat(#limit)", sync = true)
    public List<Book> getHotBooks(Integer limit) {
        return bookMapper.selectHotBooks(limit);
    }

    /*批量查询图书信息*/
    @Cacheable(value = "books", key = "'batch_'.concat(#bids.toString())", sync = true)
    public List<Book> getBooksByBids(List<String> bids) {
        return bookMapper.selectBooksByBids(bids);
    }

    /*更新图书统计信息（销量/浏览量）*/
    @CacheEvict(value = "books", key = "#bid")
    public void updateBookStatistics(String bid, Integer type, Integer increment) {
        Map<String, Object> params = new HashMap<>();
        params.put("bid", bid);
        params.put("type", type);
        params.put("increment", increment);
        bookMapper.updateBookStatistics(params);
    }

    /*查询图书总数*/
    public int getBookCount(Book book) {
        return bookMapper.selectBookCount(book);
    }
}