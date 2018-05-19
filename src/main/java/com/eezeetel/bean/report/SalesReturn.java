package com.eezeetel.bean.report;

import com.eezeetel.entity.TMasterProductinfo;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class SalesReturn {

    private Integer productId;
    private String productName;
    private Float faceValue;
    private String supplierName;
    private Integer sales;
    private boolean calculateVat;

    public SalesReturn(TMasterProductinfo product) {
        this.productId = product.getId();
        this.productName = product.getProductName();
        this.faceValue = product.getProductFaceValue();
        this.supplierName = product.getSupplier().getSupplierName();
        this.calculateVat = product.getCalculateVat() == 1;
        this.sales = 0;
    }
}
