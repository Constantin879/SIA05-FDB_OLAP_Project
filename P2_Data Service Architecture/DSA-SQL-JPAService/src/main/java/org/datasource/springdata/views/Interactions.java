package org.datasource.springdata.views;

public interface Interactions {
    Integer getInteraction_id();

    Integer getUser_id();

    Integer getProduct_id();

    String getEvent_type();

    Double getEvent_value();

    java.time.LocalDateTime getTime_stamp();

    String getDevice_type();

    String getSession_id();
}
