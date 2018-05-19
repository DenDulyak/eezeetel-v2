package com.eezeetel.api.responses;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 09.02.2017.
 */
@Getter
@Setter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class BaseResponse {

    private Integer errorCode;
    private String errorText;
}
