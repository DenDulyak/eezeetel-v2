package com.eezeetel.enums;

/**
 * Created by Denis Dulyak on 20.01.2016.
 */
public enum FeatureType {

    /*0*/CALLING_CARDS("Calling Cards"),
    /*1*/MOBILE_VOUCHERS("Mobile Vouchers"),
    /*2*/TRANSFER_TO("Transfer-To"),
    /*3*/DING("Ding"),
    /*4*/SIMS("SIMS"),
    /*5*/BULK_UPLOAD("Bulk Upload"),
    /*6*/MOBILE_UNLOCKING("Mobile Unlocking"),
    /*7*/PINLESS_CALLING_CARDS("Pinless Calling Cards"),
    /*8*/CREDIT_LIMIT("Credit Limit"),
    /*9*/PRINT_BY_CONFIRM("Print by confirm"),
    /*10*/MOBIPOPUP("Mobitopup"),
    /*11*/LOCAL_MOBILE_VOUCHERS("Local Mobile Vouchers"),
    /*12*/EEZEETEL_PINLESS("EezeeTel Pinless");

    FeatureType(String description) { this.description = description; }

    private String description;
    public String getDescription() { return description; }
}
