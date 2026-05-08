package org.datasource.springdata.views;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProductsViewRepository extends JpaRepository<ProductsView, Long>{
    // JPQL
    @Query("SELECT o FROM ProductsView o")
    default List<ProductsView> getProductsViewList() {
        return null;
    }

    //SQL
    @Query(value = "SELECT * FROM products", nativeQuery = true)
    List<ProductsView> getProductsList();


}
