package org.j4di.integration.views.dimproductfull;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "dim_product_full")
public class DIM_PRODUCT_FULL_VIEW {

    @Id
    private Long product_id;

    private String product_name;
    private String category;

    private String sub_category;
    private String brand;
    private String segment;

    private Long nr_reviews;
    private Double rating_mediu;
}
