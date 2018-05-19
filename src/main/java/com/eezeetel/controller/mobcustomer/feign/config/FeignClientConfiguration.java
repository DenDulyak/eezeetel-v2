package com.eezeetel.controller.mobcustomer.feign.config;

import feign.Client;
import org.springframework.context.annotation.Bean;

import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;

public class FeignClientConfiguration {

    @Bean
    public Client client() throws NoSuchAlgorithmException, KeyManagementException {
        return new Client.Default(new NaiveSSLSocketFactory("localhost"),
                new NaiveHostnameVerifier("localhost"));
    }
}
