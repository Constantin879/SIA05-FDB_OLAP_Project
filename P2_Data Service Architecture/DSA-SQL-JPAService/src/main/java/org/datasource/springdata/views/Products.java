package org.datasource.springdata.views;

public interface Products {
    Integer getProduct_id();

    String getProduct_name();

    String getCategory();

    String getSub_category();

    String getBrand();

    Integer getPrice();

    Integer getDiscount();

    Integer getStock_quantity();

    Double getAverage_rating();

    Integer getTotal_reviews();

    java.time.LocalDateTime getCreatedAt();
}
