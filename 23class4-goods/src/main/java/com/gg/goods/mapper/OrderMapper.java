package com.gg.goods.mapper;

import com.gg.goods.entity.Order;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @Entity com.gg.goods.entity.Order
 */
public interface OrderMapper {

    int deleteByPrimaryKey(String id);

    int insert(Order record);

    int insertSelective(Order record);

    List<Order> selectAllOrders();

    Order selectByPrimaryKey(String oid);

    Order selectByOid(String oid);

    List<Order> selectByUid(String uid);

    int updateByPrimaryKey(Order order);

    int updateStatus(@Param("oid") String oid, @Param("status") Integer status);

    int updateAddress(@Param("oid") String oid, @Param("address") String address);

    /**
     * 根据日期范围查询订单列表
     *
     * @param startDate 开始日期
     * @param endDate   结束日期
     * @return 订单列表
     */
    List<Order> selectOrdersByDateRange(@Param("startDate") Date startDate, @Param("endDate") Date endDate);

    /**
     * 查询指定日期范围的订单统计信息（订单数、销售额和用户数）
     *
     * @param params 包含startTime和endTime的参数Map
     * @return 包含订单数、销售额和用户数的Map
     */
    Map<String, Object> selectOrderStatsByDate(Map<String, Object> params);
}