package com.eezeetel.api.responses;

import com.eezeetel.serializer.DateTimeSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
public class PurchaseResporse extends BaseResponse {

    private Long transactionId;
    @JsonSerialize(using = DateTimeSerializer.class)
    private Date transactionTime;
    private Integer productId;
    private String productName;
    private BigDecimal productValue;
    private String cardId;
    private String cardPin;
    private String cardInfo;
    private BigDecimal price;
    private BigDecimal balance;
}
