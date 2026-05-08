
package org.j4di.analytical.views.olapsegment;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface OLAP_SEGMENT_CATEGORY_REVIEWS_Repository
        extends JpaRepository<OLAP_SEGMENT_CATEGORY_REVIEWS, String> {

    // Această metodă va rula query-ul SQL nativ în Spark/Hive
    @Query(value = "SELECT * FROM olap_segment_category_reviews", nativeQuery = true)
    List<OLAP_SEGMENT_CATEGORY_REVIEWS> get_OLAP_SEGMENT_CATEGORY_REVIEWS();
}
