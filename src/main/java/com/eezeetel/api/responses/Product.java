package com.eezeetel.api.responses;

import com.eezeetel.entity.TMasterProductinfo;
import com.eezeetel.entity.TMasterSupplierinfo;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@JsonInclude(value = JsonInclude.Include.NON_NULL)
public class Product {

    private Integer id;
    private String name;

    private Integer type;

    private BigDecimal value;
    private BigDecimal price;
    private Boolean available;

    public Product(TMasterSupplierinfo supplier) {
        this.id = supplier.getId();
        this.name = supplier.getSupplierName();
        Short typeId = supplier.getSupplierType().getId();
        if (typeId == 10 || typeId == 12) {
            /* Voucher */
            this.type = 0;
        }
        if (typeId == 8 || typeId == 9) {
            /* Calling Card */
            this.type = 1;
        }
    }

    public Product(TMasterProductinfo product) {
        this.id = product.getId();
        this.name = product.getProductName();
        this.value = new BigDecimal(product.getProductFaceValue() + "");
    }
}
