package com.eezeetel.bean.report;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Created by Denis Dulyak on 23.11.2015.
 */
@Getter
@Setter
public class DetailSales {

    private Integer productId;
    private String productName;
    private Float faceValue;
    private Integer transactions;
    private Integer sales;
    private Integer singlePurchases;
    private Integer multiplepurchases;

    private Integer transactionId;
    private Date transactionTime;
    private String customer;
    private String userName;
    private Float purchasePrice;

    public static DetailSales findByProductId(Integer productId, List<DetailSales> sales) {
        Optional<DetailSales> detailSales = sales.stream().filter(s -> s.getProductId().equals(productId)).findFirst();
        return detailSales.isPresent() ? detailSales.get() : null;
    }
}
