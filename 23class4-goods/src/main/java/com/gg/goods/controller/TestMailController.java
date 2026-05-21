package com.gg.goods.controller;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/mail")
public class TestMailController {
    @Autowired
    private JavaMailSender javaMailSender;

    @RequestMapping("/test2")
    public String mail_test2() throws MessagingException {
        /*获取支持发送HTML标签的 message */
        MimeMessage message = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message);
        helper.setFrom("642542344@qq.com");
        helper.setTo("2638002006@qq.com");
        helper.setSubject("(自我测试，不要拦截，用于上课学习)您有来自广东肇庆的一封问候，上午好，张先生！");
        helper.setText("<a href='http://www.baidu.com' target='_blank'>点我激活用户</a>", true);

        javaMailSender.send(message);
        return "带HTML标签邮件已投递！";
    }

    @RequestMapping("/test1")
    public String mail_test1() {
        /*1.制作一个信*/
        SimpleMailMessage message = new SimpleMailMessage();
        /*2.4个部分组成*/
        /*发信人*/
        message.setFrom("642542344@qq.com");
        /*收信人*/
        message.setTo("2638002006@qq.com");
        /*主题 subject*/
        message.setSubject("(自我测试，不要拦截，用于上课学习)您有来自广东肇庆的一封问候，上午好，张先生！");
        /*内容，text*/
        message.setText("GoodMorning！！Mr Zhang!~我这次有中文，行还是不行？？？<a href='http://baidu.com' target='_blank'>点我激活用户</a>");
        /*3.javaMailSender 把信发出去*/
        javaMailSender.send(message);
        return "邮件已投递！";
    }

}
