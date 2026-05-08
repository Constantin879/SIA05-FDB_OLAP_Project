package org.j4di.integration.views.dimproductfull;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DIM_PRODUCT_FULL_VIEW_Repository extends JpaRepository<DIM_PRODUCT_FULL_VIEW, Long> {

    @Query(value = "SELECT * FROM default.dim_product_full", nativeQuery = true)
    List<DIM_PRODUCT_FULL_VIEW> get_DIM_PRODUCT_FULL_VIEW();
}
