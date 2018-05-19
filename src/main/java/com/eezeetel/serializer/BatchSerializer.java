package com.eezeetel.serializer;

import com.eezeetel.entity.TBatchInformation;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 07.12.2016.
 */
public class BatchSerializer extends JsonSerializer<TBatchInformation> {

    @Override
    public void serialize(TBatchInformation value, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", value.getSequenceId());

        jgen.writeObjectFieldStart("productsaleinfo");
        jgen.writeNumberField("id", value.getProductsaleinfo().getId());
        jgen.writeEndObject();

        jgen.writeObjectFieldStart("product");
        jgen.writeNumberField("id", value.getProduct().getId());
        jgen.writeStringField("name", value.getProduct().getProductName());
        jgen.writeEndObject();

        jgen.writeObjectFieldStart("user");
        jgen.writeStringField("login", value.getUser().getLogin());
        jgen.writeEndObject();

        jgen.writeObjectFieldStart("supplier");
        jgen.writeNumberField("id", value.getSupplier().getId());
        jgen.writeStringField("name", value.getSupplier().getSupplierName());

        jgen.writeObjectFieldStart("supplierType");
        jgen.writeNumberField("id", value.getSupplier().getSupplierType().getId());
        jgen.writeStringField("name", value.getSupplier().getSupplierType().getSupplierType());
        jgen.writeEndObject();

        jgen.writeEndObject();

        jgen.writeStringField("batchId", value.getBatchId());
        jgen.writeNumberField("quantity", value.getQuantity());
        jgen.writeNumberField("availableQuantity", value.getAvailableQuantity());

        jgen.writeEndObject();
    }
}
