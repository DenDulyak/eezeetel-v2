package com.eezeetel.mobitopup.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 25.03.2016.
 */
@Getter
@Setter
@NoArgsConstructor
public class Balance extends MobitopupResponse {

    private String auth_key;
    private String balance;
    private String currency;

    public Balance(Integer error_code, String error_text) {
        super(error_code, error_text);
    }
}
