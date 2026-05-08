package org.j4di.access.views.reviews;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface REVIEWS_VIEW_Repository extends JpaRepository<REVIEWS_VIEW, Long> {

    @Query(value = "SELECT * FROM default.reviews_csv_view", nativeQuery = true)
    List<REVIEWS_VIEW> get_REVIEWS_VIEW();
}
