package org.j4di.analytical.views.olapfullsegmentcategoryevent;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "olap_full_segment_category_event")
public class OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW {

    @Id
    private String segment;

    private String category;
    private String event_type;

    private Double scor_total;
    private Long total_reviews;
    private Double rating_mediu;
}
