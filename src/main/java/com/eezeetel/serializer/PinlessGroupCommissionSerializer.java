package com.eezeetel.serializer;

import com.eezeetel.entity.PinlessGroupCommission;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

public class PinlessGroupCommissionSerializer extends JsonSerializer<PinlessGroupCommission> {

    @Override
    public void serialize(PinlessGroupCommission value, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", value.getId());

        jgen.writeObjectFieldStart("group");
        jgen.writeNumberField("id", value.getGroup().getId());
        jgen.writeStringField("name", value.getGroup().getName());
        jgen.writeEndObject();

        jgen.writeNumberField("percent", value.getPercent());

        jgen.writeEndObject();
    }
}
