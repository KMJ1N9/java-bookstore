package com.gg.goods.mapper;

import com.gg.goods.entity.Orderitem;

import java.util.List;

/**
 * @Entity com.gg.goods.entity.Orderitem
 */
public interface OrderitemMapper {

    int deleteByPrimaryKey(String id);

    int insert(Orderitem record);

    int insertSelective(Orderitem record);

    Orderitem selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Orderitem record);

    int updateByPrimaryKey(Orderitem record);

    // 根据订单ID查询订单项列表
    List<Orderitem> selectByOid(String oid);

    // 批量插入订单项
    int insertBatch(List<Orderitem> orderitems);

}
