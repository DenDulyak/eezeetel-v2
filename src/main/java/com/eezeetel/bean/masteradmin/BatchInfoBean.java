package com.eezeetel.bean.masteradmin;

import com.eezeetel.serializer.DateSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

/**
 * Created by Denis Dulyak on 15.01.2016.
 */
@Getter
@Setter
public class BatchInfoBean {

    private Integer id;
    private String productName;
    private Float faceValue;
    private Integer beginningQuantity;
    private Integer availableQuantity;
    private Integer sales;
    private Integer transactions;
    @JsonSerialize(using = DateSerializer.class)
    private Date arrivalDate;
    @JsonSerialize(using = DateSerializer.class)
    private Date expiryDate;
    private String firstCardId;
    private String lastCardId;
}
