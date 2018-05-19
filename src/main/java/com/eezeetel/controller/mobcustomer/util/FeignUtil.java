package com.eezeetel.controller.mobcustomer.util;

import com.eezeetel.controller.mobcustomer.feign.FeignAPI;
import com.eezeetel.controller.mobcustomer.feign.gson.GsonDecoder;
import com.eezeetel.controller.mobcustomer.feign.gson.GsonEncoder;
import feign.Feign;

import java.util.Arrays;

public class FeignUtil {

    static String buildUri(String... str) {
        return Arrays.stream(str).map(e -> e.toString()).reduce("", String::concat);
    }

//    public static void feignPost(String... url) {
//        Feign.builder()
//                .decoder(new GsonDecoder())
//                .encoder(new GsonEncoder())
//                .target(FeignAPI.class, buildUri(url))
//                .post();
//    }

    public static void feignGet(String... url) {
        Feign.builder()
                .decoder(new GsonDecoder())
                .encoder(new GsonEncoder())
                .target(FeignAPI.class, buildUri(url))
                .get();
    }
}
