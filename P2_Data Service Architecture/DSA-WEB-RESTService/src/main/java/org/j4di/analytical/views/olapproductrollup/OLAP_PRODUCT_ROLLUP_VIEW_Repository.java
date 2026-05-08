package org.j4di.analytical.views.olapproductrollup;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface OLAP_PRODUCT_ROLLUP_VIEW_Repository extends JpaRepository<OLAP_PRODUCT_ROLLUP_VIEW, String> {

    @Query(value = "SELECT * FROM default.olap_product_reviews_rollup", nativeQuery = true)
    List<OLAP_PRODUCT_ROLLUP_VIEW> get_OLAP_PRODUCT_ROLLUP_VIEW();
}
