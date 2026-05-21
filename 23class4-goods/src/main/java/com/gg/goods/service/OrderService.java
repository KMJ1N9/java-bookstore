package com.gg.goods.service;

import com.gg.goods.entity.Order;
import com.gg.goods.entity.Orderitem;

import java.util.List;

public interface OrderService {
    /**
     * 创建订单
     *
     * @param order      订单对象
     * @param orderitems 订单项列表
     * @return 创建的订单ID
     */
    String createOrder(Order order, List<Orderitem> orderitems);

    /**
     * 从购物车创建订单
     *
     * @param order       订单对象
     * @param cartitemIds 购物车项ID列表
     * @return 创建的订单ID
     */
    String createOrderFromCart(Order order, List<String> cartitemIds);

    /**
     * 根据用户ID查询订单列表
     *
     * @param uid 用户ID
     * @return 订单列表
     */
    List<Order> findByUid(String uid);

    /**
     * 查找所有订单
     */
    List<Order> findAllOrders();

    /**
     * 根据订单ID查询订单详情
     *
     * @param oid 订单ID
     * @return 订单对象
     */
    Order getOrderById(String oid);

    /**
     * 根据订单ID查询订单详情（通过字符串ID）
     *
     * @param oid 订单ID
     * @return 订单对象
     */
    Order findByOid(String oid);

    /**
     * 根据订单ID查询订单项列表
     *
     * @param oid 订单ID
     * @return 订单项列表
     */
    List<Orderitem> findOrderItemsByOid(String oid);

    /**
     * 更新订单状态
     *
     * @param oid    订单ID
     * @param status 新状态
     * @return 更新结果
     */
    boolean updateStatus(String oid, Integer status);

    /**
     * 更新订单收货地址
     *
     * @param oid     订单ID
     * @param address 新地址
     * @return 更新结果
     */
    boolean updateAddress(String oid, String address);

    /**
     * 支付订单
     *
     * @param oid 订单ID
     * @return 支付结果
     */
    boolean payOrder(String oid);

    /**
     * 确认收货
     *
     * @param oid 订单ID
     * @return 操作结果
     */
    boolean confirmReceive(String oid);

    /**
     * 取消订单
     *
     * @param oid 订单ID
     * @return 操作结果
     */
    boolean cancelOrder(String oid);

    void updateOrderAddress(Integer oid, String address);
}
