package org.j4di.integration.views.factproductreviews;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface FACT_PRODUCT_REVIEWS_VIEW_Repository extends JpaRepository<FACT_PRODUCT_REVIEWS_VIEW, Long> {

    @Query(value = "SELECT * FROM default.fact_product_reviews", nativeQuery = true)
    List<FACT_PRODUCT_REVIEWS_VIEW> get_FACT_PRODUCT_REVIEWS_VIEW();
}
