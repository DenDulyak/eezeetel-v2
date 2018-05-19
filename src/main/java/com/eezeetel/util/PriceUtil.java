package com.eezeetel.util;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 11.07.2016.
 */
public class PriceUtil {

    public static final BigDecimal ONE_HUNDRED = new BigDecimal(100);
    public static final BigDecimal TEN = new BigDecimal(10);
    public static final BigDecimal VAT_RATE = new BigDecimal("1.2");

    public static BigDecimal addPercentage(String price, Integer percent) {
        return addPercentage(new BigDecimal(price), new BigDecimal(percent + ""));
    }

    public static BigDecimal addPercentage(BigDecimal price, BigDecimal percent) {
        return price.add(getPercent(price, percent));
    }

    public static BigDecimal getPercent(BigDecimal price, BigDecimal percent) {
        return price.divide(ONE_HUNDRED).multiply(percent).setScale(2, BigDecimal.ROUND_HALF_UP);
    }
}
