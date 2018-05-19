package com.eezeetel.serializer;

import com.eezeetel.entity.TMasterCustomertype;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 29.07.2016.
 */
public class CustomerTypeSerializer extends JsonSerializer<TMasterCustomertype> {

    @Override
    public void serialize(TMasterCustomertype customerType, JsonGenerator jgen, SerializerProvider sProvider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", customerType.getId());
        jgen.writeStringField("customerType", customerType.getCustomerType());
        jgen.writeStringField("customerTypeDescription", customerType.getCustomerTypeDescription());
        jgen.writeNumberField("customerTypeActiveStatus", customerType.getCustomerTypeActiveStatus());
        jgen.writeStringField("notes", customerType.getNotes());
        jgen.writeNumberField("reserved1", customerType.getReserved1() == null ? -1 : customerType.getReserved1());
        jgen.writeStringField("reserved2", customerType.getReserved2());

        jgen.writeEndObject();
    }
}
