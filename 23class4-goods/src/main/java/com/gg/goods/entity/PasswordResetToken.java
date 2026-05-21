package com.gg.goods.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 重置密码验证码实体类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PasswordResetToken {
    private String token;          // 重置密码令牌
    private String uid;            // 用户ID
    private String email;          // 用户邮箱
    private Date expiryTime;       // 过期时间
    private Integer status;        // 状态：0-未使用，1-已使用，2-已过期
    private String verificationCode; // 验证码
}
