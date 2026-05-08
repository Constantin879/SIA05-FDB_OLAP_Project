package org.j4di.access.views.products;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PRODUCTS_VIEW_Repository extends JpaRepository<PRODUCTS_VIEW, Integer> {

    // 1. JPQL Query (Înlocuitor pentru findAll() care nu merge în Hive)
    @Query("SELECT p FROM PRODUCTS_VIEW p")
    List<PRODUCTS_VIEW> get_PRODUCTS_VIEW();

    // 2. JPQL Query filtrat (Similar cu cel pentru customerId)
    // Am ales filtrarea după category, fiind cea mai comună pentru produse
    @Query("SELECT p FROM PRODUCTS_VIEW p WHERE p.category = :category")
    List<PRODUCTS_VIEW> get_PRODUCTS_VIEW_ByCategory(@Param("category") String category);

    // 3. JDBC SQL Query (Native Query)
    // Folosește interfața PRODUCTS_PG_VIEW pentru proiecție, exact ca la Invoices
    @Query(nativeQuery = true,
            value = """
                    SELECT p.product_id, p.product_name, p.category, 
                           p.brand, p.price, p.stock_quantity
                    FROM PRODUCTS_VIEW p
                    """)
    List<PRODUCTS_PG_VIEW> get_PRODUCTS_PG_VIEW();
}
