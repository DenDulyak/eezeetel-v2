package com.eezeetel.api.responses;

import com.google.gson.annotations.SerializedName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TouchAPIResponse {

    @SerializedName("code")
    private Integer code;

    @SerializedName("header")
    private String headers;

    @SerializedName("msg")
    private String msg;
}
