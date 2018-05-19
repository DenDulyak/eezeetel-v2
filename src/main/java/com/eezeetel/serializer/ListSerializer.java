package com.eezeetel.serializer;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import org.apache.commons.lang.StringUtils;

import java.io.IOException;
import java.util.List;

/**
 * Created by Denis Dulyak on 23.09.2016.
 */
public class ListSerializer extends JsonSerializer<List> {

    @Override
    public void serialize(List value, JsonGenerator jgen, SerializerProvider provider) throws IOException, JsonProcessingException {
        jgen.writeString(StringUtils.join(value, ", "));
    }
}
