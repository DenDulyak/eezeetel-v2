package com.eezeetel.bean;

import com.eezeetel.entity.TCardInfo;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 10.09.2015.
 */
@Getter
@Setter
@NoArgsConstructor
public class CardInfoBean {

    private Long sequenceId;
    private Integer productInfoId;
    private String batchInformationId;
    private String cardId;
    private String cardPin;
    private Long transactionId;
    private Boolean isSold;
    private String printInfo;

    public CardInfoBean(TCardInfo card, String printInfo) {
        this.sequenceId = card.getId();
        this.productInfoId = card.getProduct().getId();
        this.batchInformationId = card.getBatch().getBatchId();
        this.cardId = card.getCardId();
        this.cardPin = card.getCardPin();
        this.isSold = card.getIsSold();
        this.printInfo = printInfo;
    }
}
