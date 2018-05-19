package com.eezeetel.serializer;

import com.eezeetel.entity.PhoneTopupCountry;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 15.06.2016.
 */
public class PhoneTopupCountrySerializer extends JsonSerializer<PhoneTopupCountry> {

    @Override
    public void serialize(PhoneTopupCountry country, JsonGenerator jgen, SerializerProvider serializerProvider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", country.getId());
        jgen.writeStringField("name", country.getName());
        jgen.writeStringField("iso", country.getIso());
        jgen.writeStringField("phoneCode", country.getPhoneCode());
        jgen.writeBooleanField("availableInDing", country.getAvailableInDing());
        jgen.writeBooleanField("availableInMobitopup", country.getAvailableInMobitopup());
        jgen.writeNumberField("mobitopupCountryId", country.getMobitopupCountryId() == null ? 0 : country.getMobitopupCountryId());

        jgen.writeEndObject();
    }
}
