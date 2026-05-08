package org.datasource.csv.reviews;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @AllArgsConstructor @NoArgsConstructor(force = true)
public class ReviewsView {
	Long review_id;
	Long user_id;
	Long product_id;
	Long rating;
	String review_text;
	//LocalDate review_date
	String review_date;
}