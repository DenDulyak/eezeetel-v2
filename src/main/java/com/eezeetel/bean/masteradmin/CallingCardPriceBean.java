package com.eezeetel.bean.masteradmin;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 09.03.2016.
 */
@Getter
@Setter
public class CallingCardPriceBean {

    private Integer id;
    private String country;
    private String landlinePrice;
    private String mobilePrice;
}
