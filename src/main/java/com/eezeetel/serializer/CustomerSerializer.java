package com.eezeetel.serializer;

import com.eezeetel.entity.TMasterCustomerinfo;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 24.05.2016.
 */
public class CustomerSerializer extends JsonSerializer<TMasterCustomerinfo> {

    @Override
    public void serialize(TMasterCustomerinfo customer, JsonGenerator jgen, SerializerProvider sProvider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", customer.getId());
        jgen.writeStringField("customerType", customer.getCustomerType().getCustomerType());
        jgen.writeStringField("createdBy", customer.getCreatedBy().getLogin());
        jgen.writeStringField("introducedBy", customer.getIntroducedBy().getLogin());

        jgen.writeObjectFieldStart("group");
        jgen.writeNumberField("id", customer.getGroup().getId());
        jgen.writeStringField("name", customer.getGroup().getName());
        jgen.writeEndObject();

        jgen.writeStringField("companyName", customer.getCompanyName());
        jgen.writeStringField("firstName", customer.getFirstName());
        jgen.writeStringField("lastName", customer.getLastName());
        jgen.writeStringField("middleName", customer.getMiddleName());
        jgen.writeStringField("addressLine1", customer.getAddressLine1());
        jgen.writeStringField("addressLine2", customer.getAddressLine2());
        jgen.writeStringField("addressLine3", customer.getAddressLine3());
        jgen.writeStringField("city", customer.getCity());
        jgen.writeStringField("state", customer.getState());
        jgen.writeStringField("postalCode", customer.getPostalCode());
        jgen.writeStringField("country", customer.getCountry());
        jgen.writeStringField("primaryPhone", customer.getPrimaryPhone());
        jgen.writeStringField("secondaryPhone", customer.getSecondaryPhone());
        jgen.writeStringField("mobilePhone", customer.getMobilePhone());
        jgen.writeStringField("websiteAddress", customer.getWebsiteAddress());
        jgen.writeStringField("emailId", customer.getEmailId());

        jgen.writeEndObject();
    }
}
