package com.gg.goods.service.impl;

import com.gg.goods.entity.Cartitem;
import com.gg.goods.entity.Order;
import com.gg.goods.entity.Orderitem;
import com.gg.goods.mapper.CartitemMapper;
import com.gg.goods.mapper.OrderMapper;
import com.gg.goods.mapper.OrderitemMapper;
import com.gg.goods.povos.CartBookPovo;
import com.gg.goods.service.OrderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
public class OrderServiceImpl implements OrderService {
    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private OrderitemMapper orderitemMapper;
    @Autowired
    private CartitemMapper cartitemMapper;
    @Autowired
    private DataSource dataSource;

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "ordersByUid", key = "#order.uid"),
            @CacheEvict(value = "allOrders", allEntries = true)
    })
    public String createOrder(Order order, List<Orderitem> orderitems) {
        // 生成订单ID
        String oid = UUID.randomUUID().toString().replace("-", "");
        order.setOid(oid);
        // 设置实时订单创建时间
        order.setOrdertime(new Date());
        order.setStatus(1); // 1表示未支付

        // 插入订单
        orderMapper.insert(order);

        // 为每个订单项设置订单ID并批量插入
        for (Orderitem orderitem : orderitems) {
            orderitem.setOrderitemid(UUID.randomUUID().toString().replace("-", ""));
            orderitem.setOid(oid);
        }
        orderitemMapper.insertBatch(orderitems);

        return oid;
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "ordersByUid", key = "#order.uid"),
            @CacheEvict(value = "allOrders", allEntries = true)
    })
    public String createOrderFromCart(Order order, List<String> cartitemIds) {
        // 生成订单ID
        String oid = UUID.randomUUID().toString().replace("-", "");
        order.setOid(oid);
        // 设置实时订单创建时间
        order.setOrdertime(new Date());
        order.setStatus(1); // 1表示未支付

        // 获取购物车项列表和图书信息
        List<CartBookPovo> cartBookPovos = cartitemMapper.selectCartitemBookByIds(cartitemIds);

        // 计算订单总价
        BigDecimal total = BigDecimal.ZERO;
        List<Orderitem> orderitems = new ArrayList<>();

        for (CartBookPovo cartBookPovo : cartBookPovos) {
            // 创建订单项
            Orderitem orderitem = new Orderitem();
            orderitem.setOrderitemid(UUID.randomUUID().toString().replace("-", ""));
            orderitem.setOid(oid);
            orderitem.setBid(cartBookPovo.getCartitem().getBid());
            orderitem.setQuantity(cartBookPovo.getCartitem().getQuantity());
            orderitem.setBname(cartBookPovo.getBook().getBname());
            orderitem.setCurrprice(cartBookPovo.getBook().getCurrprice());
            orderitem.setImageB(cartBookPovo.getBook().getImageB());

            // 使用CartBookPovo中的getSubtotal方法获取小计
            BigDecimal subtotal = cartBookPovo.getSubtotal();
            orderitem.setSubtotal(subtotal);
            total = total.add(subtotal);

            orderitems.add(orderitem);
        }

        // 设置订单总价
        order.setTotal(total);

        // 插入订单
        orderMapper.insert(order);

        // 批量插入订单项
        if (!orderitems.isEmpty()) {
            orderitemMapper.insertBatch(orderitems);
        }

        // 不再立即从购物车中移除已下单的商品，这样未支付的订单商品仍会显示在购物车中

        return oid;
    }

    @Override
    @Cacheable(value = "ordersByUid", key = "#uid")
    public List<Order> findByUid(String uid) {
        return orderMapper.selectByUid(uid);
    }

    @Override
    @Cacheable(value = "orderById", key = "#oid")
    public Order findByOid(String oid) {
        return orderMapper.selectByOid(oid);
    }

    @Override
    @Cacheable(value = "orderItemsByOid", key = "#oid")
    public List<Orderitem> findOrderItemsByOid(String oid) {
        return orderitemMapper.selectByOid(oid);
    }

    @Override
    @Cacheable(value = "allOrders")
    public List<Order> findAllOrders() {
        return orderMapper.selectAllOrders();
    }

    @Override
    @Cacheable(value = "orderById", key = "#oid")
    public Order getOrderById(String oid) {
        return orderMapper.selectByPrimaryKey(oid);
    }

    @Override
    @Caching(evict = {
            @CacheEvict(value = "orderById", key = "#oid"),
            @CacheEvict(value = "ordersByUid", allEntries = true),
            @CacheEvict(value = "allOrders", allEntries = true)
    })
    public boolean updateStatus(String oid, Integer status) {
        return orderMapper.updateStatus(oid, status) > 0;
    }

    @Override
    @Caching(evict = {
            @CacheEvict(value = "orderById", key = "#oid"),
            @CacheEvict(value = "ordersByUid", allEntries = true),
            @CacheEvict(value = "allOrders", allEntries = true)
    })
    public boolean updateAddress(String oid, String address) {
        return orderMapper.updateAddress(oid, address) > 0;
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "orderById", key = "#oid"),
            @CacheEvict(value = "ordersByUid", allEntries = true),
            @CacheEvict(value = "allOrders", allEntries = true)
    })
    public boolean payOrder(String oid) {
        // 1. 首先获取订单信息，包含用户ID
        Order order = orderMapper.selectByOid(oid);
        if (order == null) {
            return false;
        }

        // 2. 更新订单状态为已支付
        boolean result = updateStatus(oid, 2); // 2表示已支付

        if (result) {
            // 3. 如果支付成功，获取该订单的所有订单项
            List<Orderitem> orderitems = orderitemMapper.selectByOid(oid);

            // 4. 遍历订单项，根据用户ID和商品ID删除对应的购物车商品
            for (Orderitem orderitem : orderitems) {
                // 创建购物车商品查询条件
                Cartitem cartitem = new Cartitem();
                cartitem.setUid(order.getUid());
                cartitem.setBid(orderitem.getBid());

                // 查询对应的购物车商品
                Cartitem existingCartitem = cartitemMapper.selectCartitemByUidAndBid(cartitem);

                // 如果存在，删除该购物车商品
                if (existingCartitem != null) {
                    cartitemMapper.removeCartItem(existingCartitem.getCartitemid());
                }
            }
        }

        return result;
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "orderById", key = "#oid"),
            @CacheEvict(value = "ordersByUid", allEntries = true),
            @CacheEvict(value = "allOrders", allEntries = true)
    })
    public boolean confirmReceive(String oid) {
        log.debug("开始确认收货操作，订单ID: {}", oid);

        // 先检查订单是否存在
        Order order = orderMapper.selectByOid(oid);
        log.debug("查询订单结果: {}", (order != null ? "存在" : "不存在"));

        if (order == null) {
            log.warn("订单不存在，无法确认收货");
            return false;
        }

        log.debug("当前订单状态: {}", order.getStatus());

        // 检查订单状态是否为3（已发货，等待确认收货）
        if (order.getStatus() != 3) {
            log.warn("订单状态不是已发货，当前状态: {}，无法确认收货", order.getStatus());
            return false;
        }

        // 调用updateStatus更新订单状态为4（已确认收货）
        log.debug("准备调用updateStatus更新订单状态为4");
        int updateResult = orderMapper.updateStatus(oid, 4);
        log.debug("调用updateStatus返回结果，受影响行数: {}", updateResult);

        // 再次查询订单，验证状态是否已更新
        Order updatedOrder = orderMapper.selectByOid(oid);
        if (updatedOrder != null) {
            log.debug("更新后订单状态: {}", updatedOrder.getStatus());
        }

        // 将int返回值转换为boolean
        boolean result = updateResult > 0;
        log.info("确认收货操作最终结果: {}", result);
        return result;
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "orderById", key = "#oid"),
            @CacheEvict(value = "ordersByUid", allEntries = true),
            @CacheEvict(value = "allOrders", allEntries = true)
    })
    public boolean cancelOrder(String oid) {
        // 先检查订单是否存在
        Order order = orderMapper.selectByOid(oid);
        if (order == null) {
            return false;
        }

        // 检查订单状态是否为1（未支付）
        if (order.getStatus() != 1) {
            return false;
        }

        // 只有未支付的订单才能被取消
        return updateStatus(oid, 5); // 5表示已取消
    }

    @Override
    @Caching(evict = {
            @CacheEvict(value = "orderById", key = "#oid.toString()"),
            @CacheEvict(value = "ordersByUid", allEntries = true),
            @CacheEvict(value = "allOrders", allEntries = true)
    })
    public void updateOrderAddress(Integer oid, String address) {
        // 由于订单ID在系统中实际是字符串类型，这里进行转换处理
        String oidStr = oid.toString();
        Order order = orderMapper.selectByOid(oidStr);
        if (order != null) {
            order.setAddress(address);
            // 使用updateAddress方法保持一致性
            updateAddress(oidStr, address);
        }
    }
}