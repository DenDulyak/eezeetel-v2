package com.eezeetel.serializer;

import com.eezeetel.entity.TMasterSuppliertype;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by Denis Dulyak on 22.07.2016.
 */
public class SupplierTyperSerializer extends JsonSerializer<TMasterSuppliertype> {

    @Override
    public void serialize(TMasterSuppliertype suppliertype, JsonGenerator jgen, SerializerProvider serializerProvider) throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", suppliertype.getId());
        jgen.writeStringField("supplierType", suppliertype.getSupplierType());
        jgen.writeStringField("description", suppliertype.getDescription());
        jgen.writeBooleanField("active", suppliertype.getActive());
        jgen.writeStringField("notes", suppliertype.getNotes());
        jgen.writeNumberField("reserved1", suppliertype.getReserved1() == null ? -1 : suppliertype.getReserved1());
        jgen.writeStringField("reserved2", suppliertype.getReserved2());
        jgen.writeBooleanField("isSim", suppliertype.getIsSim() == null ? false : suppliertype.getIsSim());

        jgen.writeEndObject();
    }
}
