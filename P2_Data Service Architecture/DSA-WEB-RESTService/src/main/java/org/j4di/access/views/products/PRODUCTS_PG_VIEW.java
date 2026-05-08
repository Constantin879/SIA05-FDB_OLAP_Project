package org.j4di.access.views.products;

public interface PRODUCTS_PG_VIEW {
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

    String getCreatedAt();
}
