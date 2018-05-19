package com.eezeetel.serializer;

import com.eezeetel.entity.TMasterProducttype;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 28.07.2016.
 */
public class ProductTypeSerializer extends JsonSerializer<TMasterProducttype> {

    @Override
    public void serialize(TMasterProducttype productType, JsonGenerator jgen, SerializerProvider serializerProvider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", productType.getId());

        jgen.writeObjectFieldStart("productCategory");
        jgen.writeNumberField("id", productType.getProductCategory().getId());
        jgen.writeStringField("name", productType.getProductCategory().getName());
        jgen.writeEndObject();

        jgen.writeStringField("productType", productType.getProductType());
        jgen.writeStringField("productTypeDescription", productType.getProductTypeDescription());
        jgen.writeBooleanField("active", productType.getActive());
        jgen.writeStringField("notes", productType.getNotes());
        jgen.writeNumberField("reserved1", productType.getReserved1() == null ? -1 : productType.getReserved1());
        jgen.writeStringField("reserved2", productType.getReserved2());

        jgen.writeEndObject();
    }
}
