package com.gg.goods.mapper;

import com.gg.goods.entity.SystemLog;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

/**
 * 系统日志Mapper接口
 * 提供系统日志的数据库操作
 */
public interface SystemLogMapper {

    /**
     * 插入系统日志
     *
     * @param log 日志对象
     * @return 影响行数
     */
    int insert(SystemLog log);

    /**
     * 根据日期范围查询系统日志
     *
     * @param startDate 开始日期
     * @param endDate   结束日期
     * @param limit     查询条数限制
     * @return 日志列表
     */
    List<SystemLog> selectByDateRange(@Param("startDate") Date startDate,
                                      @Param("endDate") Date endDate,
                                      @Param("limit") int limit);

    /**
     * 查询最近的系统日志
     *
     * @param limit 查询条数
     * @return 最近的日志列表
     */
    List<SystemLog> selectRecentLogs(@Param("limit") int limit);

    /**
     * 根据操作用户查询日志
     *
     * @param operator 操作用户
     * @param limit    查询条数限制
     * @return 日志列表
     */
    List<SystemLog> selectByOperator(@Param("operator") String operator,
                                     @Param("limit") int limit);
}
