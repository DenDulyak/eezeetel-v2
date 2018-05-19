package com.eezeetel.serializer;

import com.eezeetel.entity.TMasterSupplierinfo;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 06.12.2016.
 */
public class SupplierSerializer extends JsonSerializer<TMasterSupplierinfo> {

    @Override
    public void serialize(TMasterSupplierinfo value, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", value.getId());

        jgen.writeObjectFieldStart("supplierType");
        jgen.writeNumberField("id", value.getSupplierType().getId());
        jgen.writeStringField("name", value.getSupplierType().getSupplierType());
        jgen.writeEndObject();

        jgen.writeObjectFieldStart("user");
        jgen.writeStringField("login", value.getUser().getLogin());
        jgen.writeEndObject();

        jgen.writeStringField("name", value.getSupplierName());

        jgen.writeEndObject();
    }
}
