package org.j4di.integration.views.vwconsolidarefullanalysis;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface VW_CONSOLIDARE_FULL_ANALYSIS_VIEW_Repository extends JpaRepository<VW_CONSOLIDARE_FULL_ANALYSIS_VIEW, Long> {

    @Query(value = "SELECT * FROM default.vw_consolidare_full_analysis", nativeQuery = true)
    List<VW_CONSOLIDARE_FULL_ANALYSIS_VIEW> get_VW_CONSOLIDARE_FULL_ANALYSIS_VIEW();
}
