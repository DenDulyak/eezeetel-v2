package com.eezeetel.bean;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 14.10.2015.
 */
@Getter
@Setter
public class ResponseContainer<T> {

    private T data;
    private long count = 0;
    private int page = 1;
    private int begin = 0;
    private int end = 0;
    private int status = 0;
    private String message;
}
