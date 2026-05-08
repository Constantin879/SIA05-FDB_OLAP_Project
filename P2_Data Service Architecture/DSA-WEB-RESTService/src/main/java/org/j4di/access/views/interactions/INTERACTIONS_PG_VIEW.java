package org.j4di.access.views.interactions;

public interface INTERACTIONS_PG_VIEW {
    Integer getInteraction_id();

    Integer getUser_id();

    Integer getProduct_id();

    String getEvent_type();

    Double getEvent_value();

    String getTime_stamp();

    String getDevice_type();

    String getSession_id();
}
