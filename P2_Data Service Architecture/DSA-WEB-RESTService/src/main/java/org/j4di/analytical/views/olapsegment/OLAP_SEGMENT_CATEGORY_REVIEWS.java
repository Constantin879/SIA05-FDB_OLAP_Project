
package org.j4di.analytical.views.olapsegment;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;


@Data
@Entity
@Table(name = "olap_segment_category_reviews")
public class OLAP_SEGMENT_CATEGORY_REVIEWS {

    @Id
    private String segment;
    private String category;

    private Double scor_total;
    private Long total_reviews;
}
