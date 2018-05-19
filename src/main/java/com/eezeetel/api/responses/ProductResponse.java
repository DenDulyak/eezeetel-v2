package com.eezeetel.api.responses;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * Created by Denis Dulyak on 10.02.2017.
 */
@Getter
@Setter
public class ProductResponse<T> extends BaseResponse {

    private List<T> suppliers;
    private List<T> products;
}
