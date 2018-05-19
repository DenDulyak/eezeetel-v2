package com.eezeetel.controller.mobcustomer.feign;

import feign.Body;
import feign.HeaderMap;
import feign.Headers;
import feign.RequestLine;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

import java.util.Map;

public interface FeignAPI {

    @RequestLine("POST ")
//    @Headers()
//    @Body()
    void post(@HeaderMap Map<String, String> headers);

    @RequestLine("GET ")
    void get();

    @RequestLine("POST ")
    @Body("application/x-www-form-urlencoded")
//    @Headers("Content-Type: application/x-www-form-urlencoded")
    String postWHeader(@HeaderMap Map<String, String> headerMap,
                       @RequestBody Map<String, String> bodyMap);
}
