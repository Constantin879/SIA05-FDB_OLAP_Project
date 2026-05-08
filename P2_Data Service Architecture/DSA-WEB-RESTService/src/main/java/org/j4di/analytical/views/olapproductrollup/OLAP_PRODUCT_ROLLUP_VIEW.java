package org.j4di.analytical.views.olapproductrollup;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "olap_product_reviews_rollup")
public class OLAP_PRODUCT_ROLLUP_VIEW {
    @Id
    private String category;
    private String brand;
    private Double scor_total;
    private Long total_reviews;
}
