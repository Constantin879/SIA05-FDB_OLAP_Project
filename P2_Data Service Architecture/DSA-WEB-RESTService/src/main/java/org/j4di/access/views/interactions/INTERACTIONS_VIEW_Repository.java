package org.j4di.access.views.interactions;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface INTERACTIONS_VIEW_Repository extends JpaRepository<INTERACTIONS_VIEW, Integer> {

    // 1. JPQL Query (Înlocuitor pentru findAll() din cauza hive-jdbc)
    @Query("SELECT i FROM INTERACTIONS_VIEW i")
    List<INTERACTIONS_VIEW> get_INTERACTIONS_VIEW();

    // 2. Filtrare după user_id (similar cu customerId de la Invoices)
    @Query("SELECT i FROM INTERACTIONS_VIEW i WHERE i.user_id = :userId")
    List<INTERACTIONS_VIEW> get_INTERACTIONS_VIEW_ByUserId(@Param("userId") Integer userId);

    // 3. Filtrare după product_id (util pentru a vedea interacțiunile pe un produs specific)
    @Query("SELECT i FROM INTERACTIONS_VIEW i WHERE i.product_id = :productId")
    List<INTERACTIONS_VIEW> get_INTERACTIONS_VIEW_ByProductId(@Param("productId") Integer productId);

    // 4. JDBC SQL Query (Native Query)
    // Notă: Dacă nu ai o interfață de tip "INTERACTIONS_PG_VIEW",
    // am mapat rezultatul tot pe clasa de bază sau poți selecta coloane specifice.
    @Query(nativeQuery = true,
            value = """
                    SELECT i.interaction_id, i.user_id, i.product_id, 
                           i.event_type, i.event_value, i.time_stamp
                    FROM INTERACTIONS_VIEW i
                    """)
    List<INTERACTIONS_VIEW> get_INTERACTIONS_SUMMARY();
}
