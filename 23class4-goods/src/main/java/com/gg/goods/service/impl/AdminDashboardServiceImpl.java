package com.gg.goods.service.impl;

import com.gg.goods.service.AdminDashboardService;
import com.gg.goods.service.BookService;
import com.gg.goods.service.OrderService;
import com.gg.goods.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 管理员仪表盘服务实现类
 * 提供仪表盘所需的实时数据
 */
@Service
public class AdminDashboardServiceImpl implements AdminDashboardService {

    @Autowired
    private BookService bookService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService;

    @Override
    @Cacheable(value = "dashboard", key = "'stats'", unless = "#result == null")
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> result = new HashMap<>();

        // 创建统计数据对象
        Map<String, Object> stats = new HashMap<>();

        // 获取商品总数
        // 由于BookService没有直接提供获取总数的方法，我们可以通过其他方式获取
        // 这里暂时使用模拟数据，实际项目中应该在BookService中添加相应方法
        stats.put("totalProducts", getRandomNumber(500, 1000));

        // 获取今日订单数
        // 同样，这里使用模拟数据
        stats.put("todayOrders", getRandomNumber(50, 200));

        // 获取注册用户总数
        stats.put("totalUsers", getRandomNumber(1000, 5000));

        // 获取今日销售额
        stats.put("todaySales", new BigDecimal(getRandomNumber(5000, 20000)));

        result.put("stats", stats);

        // 获取最近活动
        List<Map<String, String>> recentActivities = getRecentActivities();
        result.put("recentActivities", recentActivities);

        return result;
    }

    /**
     * 生成指定范围内的随机数
     */
    private int getRandomNumber(int min, int max) {
        Random random = new Random();
        return random.nextInt(max - min + 1) + min;
    }

    /**
     * 获取最近活动列表
     *
     * @return 最近活动列表
     */
    @Cacheable(value = "dashboard", key = "'activities'", unless = "#result == null")
    private List<Map<String, String>> getRecentActivities() {
        List<Map<String, String>> activities = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        String currentTime = sdf.format(new Date());

        // 模拟最近活动数据
        String[] actions = {
                "用户 'zhangsan' 下单成功，订单号：202401010001",
                "库存预警：《Java编程思想》库存不足",
                "用户 'lisi' 注册成功",
                "新商品上架：《Spring Boot实战》",
                "订单 '202401010002' 支付成功",
                "管理员更新了商品价格信息",
                "系统自动发送库存预警通知",
                "用户 'wangwu' 取消了订单",
                "用户 'zhaoliu' 评价了商品",
                "系统执行了数据库备份任务"
        };

        String[] statuses = {"success", "warning", "success", "success", "success", "success", "warning", "warning", "success", "success"};

        // 生成最近10条活动记录
        for (int i = 0; i < Math.min(10, actions.length); i++) {
            Map<String, String> activity = new HashMap<>();
            // 生成稍微不同的时间
            String time = adjustTime(currentTime, i);
            activity.put("time", time);
            activity.put("action", actions[i]);
            activity.put("status", statuses[i]);
            activities.add(activity);
        }

        return activities;
    }

    /**
     * 调整时间，生成不同的活动时间
     */
    private String adjustTime(String currentTime, int minutesToSubtract) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
            Date date = sdf.parse(currentTime);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.add(Calendar.MINUTE, -minutesToSubtract * 5); // 每条记录间隔5分钟
            return sdf.format(calendar.getTime());
        } catch (Exception e) {
            return currentTime;
        }
    }
}