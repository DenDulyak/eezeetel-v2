package com.eezeetel.api.responses;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 09.02.2017.
 */
@Getter
@Setter
public class BalanceResponse extends BaseResponse {

    private BigDecimal balance;
}
