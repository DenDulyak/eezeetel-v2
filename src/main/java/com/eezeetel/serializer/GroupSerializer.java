package com.eezeetel.serializer;

import com.eezeetel.entity.TMasterCustomerGroups;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 15.06.2016.
 */
public class GroupSerializer extends JsonSerializer<TMasterCustomerGroups> {

    @Override
    public void serialize(TMasterCustomerGroups group, JsonGenerator jgen, SerializerProvider serializerProvider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", group.getId());

        jgen.writeObjectFieldStart("defaultCustomer");
        jgen.writeNumberField("id", group.getDefaultCustomer().getId());
        jgen.writeStringField("companyName", group.getDefaultCustomer().getCompanyName());
        jgen.writeEndObject();

        jgen.writeObjectFieldStart("createdBy");
        jgen.writeStringField("login", group.getCreatedBy().getLogin());
        jgen.writeEndObject();

        jgen.writeStringField("companyName", group.getName());
        jgen.writeObjectField("customerSince", group.getCustomerSince());
        jgen.writeStringField("notes", group.getNotes());
        jgen.writeBooleanField("active", group.getActive());

        jgen.writeEndObject();
    }
}

