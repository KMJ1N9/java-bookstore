package com.gg.goods.mapper;

import com.gg.goods.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @Entity com.gg.goods.entity.User
 */

/*每个接口都写这个@Mapper注解，太麻烦，希望所有的持久层接口们对应的代理对象全进IOC容器里*/
//@Mapper  /*自动创建这个接口的代理对象，然后自动放到IOC大瓶子里*/
public interface UserMapper {

    int deleteByPrimaryKey(String uid);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(String uid);

    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);

    /*以loginname查询用户*/
    User selectUserByLoginname(String loginname);

    User selectUserByEmail(String email);

    /*按激活码查询用户*/
    User selectUserByActivationCode(String activationCode);

    User selectUserByLoginnameAndLoginpass(User user);

    /*根据uid查询用户信息*/
    User selectUserByUid(@Param("uid") String uid);

    /*修改用户信息（根据uid）*/
    int updateUserByUid(@Param("user") User user);

    /*修改用户密码*/
    int updateUserPassword(@Param("uid") String uid, @Param("newPassword") String newPassword);

    /*更新用户头像路径*/
    int updateUserAvatar(@Param("uid") String uid, @Param("avatarPath") String avatarPath);

    /*更新用户激活状态*/
    int updateUserStatusByActivationCode(@Param("activationCode") String activationCode, @Param("status") Integer status);

    /*查询所有用户*/
    List<User> selectAllUsers();

    /*根据用户名模糊查询用户*/
    List<User> selectUsersByLoginname(@Param("loginname") String loginname);
}
