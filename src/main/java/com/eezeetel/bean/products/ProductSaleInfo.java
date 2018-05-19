package com.eezeetel.bean.products;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 19.10.2015.
 */
@Getter
@Setter
public class ProductSaleInfo {

    private Integer salesBetweenDate;
    private Integer salesUntilDate;
    private Integer transactions;
    private Integer purchaseType;
    private Integer productId;

    public static void init(ProductSaleInfo saleInfo) {
        if (saleInfo.getSalesBetweenDate() == null) {
            saleInfo.setSalesBetweenDate(0);
        }
        if (saleInfo.getSalesUntilDate() == null) {
            saleInfo.setSalesUntilDate(0);
        }
        if (saleInfo.getTransactions() == null) {
            saleInfo.setTransactions(0);
        }
    }
}
