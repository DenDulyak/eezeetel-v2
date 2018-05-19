package com.eezeetel.serializer;

import com.eezeetel.entity.TMasterProductsaleinfo;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 06.12.2016.
 */
public class ProductSaleSerializer extends JsonSerializer<TMasterProductsaleinfo> {

    @Override
    public void serialize(TMasterProductsaleinfo value, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", value.getId());

        jgen.writeObjectFieldStart("product");
        jgen.writeNumberField("id", value.getProduct().getId());
        jgen.writeStringField("name", value.getProduct().getProductName());
        jgen.writeEndObject();

        jgen.writeStringField("tollFreeNumber1", value.getTollFreeNumber1());
        jgen.writeStringField("tollFreeNumber2", value.getTollFreeNumber2());
        jgen.writeStringField("localAcessNumber1", value.getLocalAcessNumber1());
        jgen.writeStringField("localAcessNumber2", value.getLocalAcessNumber2());

        jgen.writeEndObject();
    }
}
