package com.gg.goods.config;

import jakarta.activation.MimetypesFileTypeMap;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

import java.util.Properties;

@Configuration
public class MailConfig {
    @Bean
    public JavaMailSender getJavaMailSender() {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();

        /*调整  mailSender  支持 html  字符集 utf-8*/
        mailSender.setDefaultEncoding("utf-8");
        MimetypesFileTypeMap fileTypeMap = new MimetypesFileTypeMap();
        fileTypeMap.addMimeTypes("text/html;charset=utf-8");
        mailSender.setDefaultFileTypeMap(fileTypeMap);
        /*
        让我们的邮箱账号自动登录到邮件服务器上。
        * */
        mailSender.setHost("smtp.qq.com");
        mailSender.setPort(587); // 或者是465或其他端口
        mailSender.setUsername("642542344");
        mailSender.setPassword("ycbnrrnlrbitbdee");
        Properties props = mailSender.getJavaMailProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // 如果使用SSL, 则需要设置如下属性
        // props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        // props.put("mail.smtp.socketFactory.fallback", "false");
        // props.put("mail.smtp.port", "465");
        // props.put("mail.smtp.socketFactory.port", "465");

        return mailSender;
    }
}