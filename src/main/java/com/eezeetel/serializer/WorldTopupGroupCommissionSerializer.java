package com.eezeetel.serializer;

import com.eezeetel.entity.WorldTopupGroupCommission;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 13.07.2016.
 */
public class WorldTopupGroupCommissionSerializer extends JsonSerializer<WorldTopupGroupCommission> {

    @Override
    public void serialize(WorldTopupGroupCommission groupCommission, JsonGenerator jgen, SerializerProvider serializerProvider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", groupCommission.getId());

        jgen.writeObjectFieldStart("country");
        jgen.writeNumberField("id", groupCommission.getCountry().getId());
        jgen.writeStringField("name", groupCommission.getCountry().getName());
        jgen.writeStringField("iso", groupCommission.getCountry().getIso());
        jgen.writeBooleanField("availableInDing", groupCommission.getCountry().getAvailableInDing());
        jgen.writeBooleanField("availableInMobitopup", groupCommission.getCountry().getAvailableInMobitopup());
        jgen.writeEndObject();

        jgen.writeObjectFieldStart("group");
        jgen.writeNumberField("groupId", groupCommission.getGroup().getId());
        jgen.writeStringField("groupName", groupCommission.getGroup().getName());
        jgen.writeEndObject();

        jgen.writeNumberField("percent", groupCommission.getPercent());

        jgen.writeEndObject();
    }
}
