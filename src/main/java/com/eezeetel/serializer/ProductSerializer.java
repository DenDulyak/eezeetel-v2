package com.eezeetel.serializer;

import com.eezeetel.entity.TMasterProductinfo;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 06.12.2016.
 */
public class ProductSerializer extends JsonSerializer<TMasterProductinfo> {

    @Override
    public void serialize(TMasterProductinfo value, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", value.getId());

        jgen.writeObjectFieldStart("user");
        jgen.writeStringField("login", value.getUser().getLogin());
        jgen.writeEndObject();

        jgen.writeObjectFieldStart("productType");
        jgen.writeNumberField("id", value.getProductType().getId());
        jgen.writeStringField("name", value.getProductType().getProductType());
        jgen.writeEndObject();

        jgen.writeObjectFieldStart("supplier");
        jgen.writeNumberField("id", value.getSupplier().getId());
        jgen.writeStringField("name", value.getSupplier().getSupplierName());
        jgen.writeEndObject();

        jgen.writeStringField("name", value.getProductName());
        jgen.writeNumberField("faceValue", value.getProductFaceValue());
        jgen.writeNumberField("costPrice", value.getCostPrice());

        jgen.writeEndObject();
    }
}
