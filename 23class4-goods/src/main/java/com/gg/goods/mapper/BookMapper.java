package com.gg.goods.mapper;

import com.gg.goods.entity.Book;

import java.util.List;
import java.util.Map;

/**
 * @Entity com.gg.goods.entity.Book
 */
public interface BookMapper {

    int deleteByPrimaryKey(Long id);

    int insert(Book record);

    int insertSelective(Book record);

    Book selectByPrimaryKey(String bid);

    int updateByPrimaryKeySelective(Book record);

    int updateByPrimaryKey(Book record);

    /*按条件查询多本，使用一个动态SQL全部实现*/
    List<Book> selectBooksByCase(Book book);

    /*根据分类ID查询图书*/
    List<Book> selectBooksByCid(String cid);

    /*根据书名模糊查询*/
    List<Book> selectBooksByBname(String bname);

    /*根据作者查询图书*/
    List<Book> selectBooksByAuthor(String author);

    /*根据出版社查询图书*/
    List<Book> selectBooksByPress(String press);

    /*查询最新上架的图书*/
    List<Book> selectNewestBooks(int limit);

    /*查询热门图书（按销量或浏览量排序）*/
    List<Book> selectHotBooks(int limit);

    /*批量查询图书信息*/
    List<Book> selectBooksByBids(List<String> bids);

    /*更新图书的销量或浏览量*/
    int updateBookStatistics(Map<String, Object> params);

    /*查询图书总数*/
    int selectBookCount(Book book);

}
