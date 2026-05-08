package org.datasource.springdata.views;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface InteractionsViewRepository extends JpaRepository<InteractionsView, Long> {
    // JPQL
    @Query("SELECT o FROM InteractionsView o")
    List<InteractionsView> getInteractionsViewList();

    //SQL
    @Query(value = "SELECT * FROM interactions", nativeQuery = true)
    List<Interactions> getInteractionsList();

}

/*
https://thorben-janssen.com/spring-data-jpa-dto-native-queries/
*/