package org.j4di.analytical.views.olapfullsegmentcategoryevent;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW_Repository
        extends JpaRepository<OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW, String> {

    @Query(value = "SELECT * FROM default.olap_full_segment_category_event", nativeQuery = true)
    List<OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW> get_OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW();
}
