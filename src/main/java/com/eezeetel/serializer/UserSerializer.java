package com.eezeetel.serializer;

import com.eezeetel.entity.User;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 09.05.2016.
 */
public class UserSerializer extends JsonSerializer<User> {

    @Override
    public void serialize(User user, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        jgen.writeStartObject();

        jgen.writeStringField("login", user.getLogin());

        jgen.writeObjectFieldStart("group");
        jgen.writeNumberField("groupId", user.getGroup().getId());
        jgen.writeStringField("groupName", user.getGroup().getName());
        jgen.writeEndObject();

        jgen.writeObjectFieldStart("userType");
        jgen.writeNumberField("id", user.getUserType().getId());
        jgen.writeStringField("name", user.getUserType().getName());
        jgen.writeEndObject();

        jgen.writeStringField("userFirstName", user.getUserFirstName());
        jgen.writeStringField("userLastName", user.getUserLastName());
        jgen.writeStringField("userMiddleName", user.getUserMiddleName());
        jgen.writeStringField("userCompanyName", user.getUserCompanyName());
        jgen.writeStringField("addressLine1", user.getAddressLine1());
        jgen.writeStringField("addressLine2", user.getAddressLine2());
        jgen.writeStringField("addressLine3", user.getAddressLine3());
        jgen.writeStringField("city", user.getCity());
        jgen.writeStringField("state", user.getState());
        jgen.writeStringField("postalCode", user.getPostalCode());
        jgen.writeStringField("country", user.getCountry());
        jgen.writeStringField("primaryPhone", user.getPrimaryPhone());
        jgen.writeStringField("secondaryPhone", user.getSecondaryPhone());
        jgen.writeStringField("mobilePhone", user.getMobilePhone());
        jgen.writeStringField("emailId", user.getEmailId());
        //jgen.writeStringField("password", user.getPassword());
        //jgen.writeStringField("password2", user.getPassword2());
        jgen.writeBooleanField("userActiveStatus", user.getUserActiveStatus());
        jgen.writeStringField("userCreatedBy", user.getUserCreatedBy());
        jgen.writeObjectField("userCreationTime", user.getUserCreationTime());
        jgen.writeObjectField("userModifiedTime", user.getUserModifiedTime());
        jgen.writeStringField("notes", user.getNotes());
        jgen.writeStringField("reserved2", user.getReserved2());

        jgen.writeEndObject();
    }
}
