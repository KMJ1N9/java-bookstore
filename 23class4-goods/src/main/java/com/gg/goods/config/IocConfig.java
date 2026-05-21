package com.gg.goods.config;

import com.gg.goods.entity.User;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class IocConfig {

    @Bean
    User xxx() {
        return new User();
    }

}
