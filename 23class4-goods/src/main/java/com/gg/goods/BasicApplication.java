package com.gg.goods;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.ApplicationContext;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/*@MapperScan：
 * 使用@Mapper注解给每一个持久层接口代理对象放IOC容器太麻烦，
 * 干脆使用扫描器，扫描"com.gg.goods.mapper"包下所有接口，一次性生成代理对象们全放IOC中。
 * */
@MapperScan(basePackages = {"com.gg.goods.mapper"})


/*
 * JavaWeb三大组件，Servlet、Filter、Listener 它是由Tomcat容器生产的，
 * 而我们的工程SpringBoot 负责托管  它，需要整合。
 *
 * */
@ServletComponentScan(basePackages = {"com.gg.goods.filters", "com.gg.goods.listener"})
@SpringBootApplication
@EnableTransactionManagement
@EnableCaching
public class BasicApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(BasicApplication.class);
    }

    public static void main(String[] args) {
        // 设置JMX相关JVM参数，确保IDEA能正确检测JMX服务URL
        System.setProperty("com.sun.management.jmxremote", "true");
        System.setProperty("com.sun.management.jmxremote.port", "1099");
        System.setProperty("com.sun.management.jmxremote.rmi.port", "1099");
        System.setProperty("com.sun.management.jmxremote.authenticate", "false");
        System.setProperty("com.sun.management.jmxremote.ssl", "false");
        System.setProperty("com.sun.management.jmxremote.local.only", "false");

        ApplicationContext ioc = SpringApplication.run(BasicApplication.class, args);
    }
}