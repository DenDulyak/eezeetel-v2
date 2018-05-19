package com.eezeetel.bean;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 06.10.2015.
 */
@Getter
@Setter
public class ProductSalesByGroup {

    private Integer productId;
    private String productName;
    private Float faceValue;
    private Integer sales;
    private Integer eezeetelSales;
    private Integer gsmSales;
    private Integer kasGlobalSales;
    private Integer kupaySales;
    private Integer fastTelSales;
}
