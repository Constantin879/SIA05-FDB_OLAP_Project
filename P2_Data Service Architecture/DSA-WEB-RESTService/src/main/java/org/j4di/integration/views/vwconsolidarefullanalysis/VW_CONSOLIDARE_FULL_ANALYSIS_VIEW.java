package org.j4di.integration.views.vwconsolidarefullanalysis;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "vw_consolidare_full_analysis")
public class VW_CONSOLIDARE_FULL_ANALYSIS_VIEW {

    @Id
    private Long user_id; // ATENȚIE: Nu e unic în acest View!

    private String user_name;
    private String segment;
    private String city;

    private Long product_id;
    private String product_name;
    private String category;
    private String brand;

    private String event_type; // Adăugat din SELECT

    private Double scor_interactiuni; // SUM(i.event_value)
    private Long nr_reviews;          // COUNT(r.review_id)
    private Double rating_mediu;      // AVG(r.rating)
}
