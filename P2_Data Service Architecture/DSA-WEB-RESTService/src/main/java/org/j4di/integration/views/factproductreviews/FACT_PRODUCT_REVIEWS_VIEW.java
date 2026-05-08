package org.j4di.integration.views.factproductreviews;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "fact_product_reviews")
public class FACT_PRODUCT_REVIEWS_VIEW {

    @Id
    private Long product_id;

    private String category;
    private String brand;
    private String segment;

    private Double scor_total_interactiuni;
    private Long total_reviews;
    private Double rating_mediu;
}
