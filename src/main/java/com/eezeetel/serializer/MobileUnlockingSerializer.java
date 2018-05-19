package com.eezeetel.serializer;

import com.eezeetel.entity.MobileUnlocking;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 09.05.2016.
 */
public class MobileUnlockingSerializer extends JsonSerializer<MobileUnlocking> {

    @Override
    public void serialize(MobileUnlocking mobileUnlocking, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", mobileUnlocking.getId());
        jgen.writeStringField("title", mobileUnlocking.getTitle());

        jgen.writeObjectFieldStart("supplier");
        jgen.writeNumberField("id", mobileUnlocking.getSupplier().getId());
        jgen.writeStringField("name", mobileUnlocking.getSupplier().getSupplierName());
        jgen.writeEndObject();

        jgen.writeStringField("deliveryTime", mobileUnlocking.getDeliveryTime());
        jgen.writeNumberField("purchasePrice", mobileUnlocking.getPurchasePrice());
        jgen.writeStringField("transactionCondition", mobileUnlocking.getTransactionCondition());
        jgen.writeStringField("notes", mobileUnlocking.getNotes());
        jgen.writeBooleanField("active", mobileUnlocking.getActive());

        jgen.writeEndObject();
    }
}
