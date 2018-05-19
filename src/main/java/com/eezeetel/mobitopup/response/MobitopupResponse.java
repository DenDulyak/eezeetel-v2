package com.eezeetel.mobitopup.response;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 25.03.2016.
 */
@Getter
@Setter
public abstract class MobitopupResponse {

    private Integer error_code;
    private String error_text;

    public MobitopupResponse() {
    }

    public MobitopupResponse(Integer error_code, String error_text) {
        this.error_code = error_code;
        this.error_text = error_text;
    }
}
