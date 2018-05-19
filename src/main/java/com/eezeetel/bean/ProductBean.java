package com.eezeetel.bean;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 07.09.2015.
 */
@Getter
@Setter
public class ProductBean {

    private Integer id;
    private String name;
    private Float faceValue;
    private Integer availableQuantity;
    private String img;
}
