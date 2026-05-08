package org.j4di.access.views.reviews;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "reviews_csv_view") // Numele exact din DBeaver
public class REVIEWS_VIEW {

    @Id
    private Long review_id; // Cheia primară din tabelă

    private Long product_id;
    private Long rating;
    private String review_date;
    private String review_text;
    private Long user_id;
}
