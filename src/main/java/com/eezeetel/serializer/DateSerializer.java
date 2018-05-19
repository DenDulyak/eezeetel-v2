package com.eezeetel.serializer;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by Denis Dulyak on 06.12.2016.
 */
public class DateSerializer extends JsonSerializer<Date> {

    public static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    public void serialize(Date date, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        jgen.writeString(dateFormat.format(date));
    }
}
