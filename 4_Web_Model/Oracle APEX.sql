/*INTEROGARI prezentate in aplicatia Oracle APEX*/




/*1. Primul Grid care contine datele View-ului olap_segment_category_reviews*/
CREATE OR REPLACE VIEW olap_segment_category_reviews AS
SELECT 
    NVL(segment,'TOTAL') AS segment,
    NVL("category",'TOTAL') AS category,
    
    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews
FROM vw_consolidare_product_reviews
GROUP BY CUBE(segment, "category");


SELECT * FROM olap_segment_category_reviews ORDER BY segment, category;
/*View-ul analizeaza interactiunile si review-urile în functie de segment si categorie, 
folosind operatorul CUBE pentru a genera toate combinatiile si totalurile agregate*/


URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/grid-olap-segment-category-reviews?session=2290798860496






/*2. Interogare 1 - Pie */
/*Scor total pe categorie*/
SELECT category, SUM(scor_total) as scor_total_ctg FROM OLAP_SEGMENT_CATEGORY_REVIEWS
WHERE category <> 'TOTAL'
GROUP BY category;



URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/scor-total-ctg?session=2290798860496





/*3. Interogare 2 - Grid*/  
/*Top 5 branduri pe categorie(cele mai performante top 5 branduri din fiecare categorie)*/

SELECT *
FROM (
    SELECT 
        category,
        brand,
        SUM(scor_total) AS scor_total,
        RANK() OVER (PARTITION BY category ORDER BY SUM(scor_total) DESC) AS pozitie
    FROM olap_product_reviews
    WHERE category <> 'TOTAL'
      AND brand <> 'TOTAL'
    GROUP BY category, brand
)
WHERE pozitie <= 5;


URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/top-5-brands-by-category?session=2290798860496





/*4. Interogare 3 - Grid*/
/*Segmentul cel mai activ pe categorie*/
SELECT *
FROM (
    SELECT 
        category,
        segment,
        SUM(scor_total) AS scor_total,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(scor_total) DESC) AS rn
    FROM olap_segment
    WHERE category <> 'TOTAL'
      AND segment <> 'TOTAL'
    GROUP BY category, segment
)
WHERE rn = 1;
/* deci cine cumpara cel mai mult pe fiecare categorie*/


URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/the-most-active-segment-by-category?session=2290798860496




/*5. Interogare 4 - Grid*/
/*produse populare, dar slab evaluate*/
SELECT 
    "product_id",
    "category",
    "brand",
    scor_total_interactiuni,
    rating_mediu
FROM fact_product_reviews
WHERE scor_total_interactiuni > (
        SELECT AVG(scor_total_interactiuni) FROM fact_product_reviews  
    )
  AND rating_mediu < (
        SELECT AVG(rating_mediu) FROM fact_product_reviews
    )
ORDER BY scor_total_interactiuni DESC;


URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/popular-products-with-low-ratings?session=2290798860496


/*6. Interogare 4.1 - Grid*/
/*Adica: */
/*media pentru popularitate(interactiuni)=3,14. Deci mai mult decat aceasta valoare, ca fiind populare*/
SELECT 
    AVG(scor_total_interactiuni) AS media_interactiuni
FROM fact_product_reviews;

URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/average-for-popularity?session=2290798860496

/*7. Interogare 4.2 - Grid*/
/*media pentru evaluare(rating)=4,06. Deci sub aceasta valoare, ca fiind slab evaluate*/
SELECT 
    AVG(rating_mediu) AS media_rating
FROM fact_product_reviews;


URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/rating-average?session=2290798860496






/*8. Interogare 5 - Grid*/
/* Ce brand domina pe fiecare tip de segment*/
SELECT *
FROM (
    SELECT 
        segment,
        brand,
        SUM(scor_total) AS scor_total,
        ROW_NUMBER() OVER (
            PARTITION BY segment 
            ORDER BY SUM(scor_total) DESC
        ) AS rn
    FROM olap_full_segment_brand
    WHERE brand <> 'TOTAL'
      AND segment <> 'TOTAL'
    GROUP BY segment, brand
)
WHERE rn = 1;


URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/brand-that-dominates-each-type-of-segment?session=2290798860496






/*9. Interogare 6 - Grid*/
/*Produse cu crestere exponentiala a interesului (event_type insight)*/

SELECT 
    "product_id",
    "category",
    "event_type",
    SUM(scor_interactiuni) AS scor_total
FROM vw_consolidare_full_analysis
GROUP BY "product_id", "category", "event_type"
HAVING SUM(scor_interactiuni) > (
    SELECT AVG(total_scor)
    FROM (
        SELECT 
            SUM(scor_interactiuni) AS total_scor
        FROM vw_consolidare_full_analysis
        GROUP BY "product_id", "event_type"
    )
)
ORDER BY scor_total DESC;


URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/products-with-exponential-growth-in-interest?session=2290798860496


/*10. Interogare 6.1 - Grid*/
/*media scorurilor la nivel de produs=7,10*/
SELECT 
    AVG(total_scor) AS media_scor_produse
FROM (
    SELECT 
        "product_id",
        SUM(scor_interactiuni) AS total_scor
    FROM vw_consolidare_full_analysis
    GROUP BY "product_id"
);


/*Interogarea 6 identifică produsele care generează un nivel de interes peste medie, 
comparând scorul total al interactiunilor cu media scorurilor la nivel de produs.*/

URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/average-product-level-scores?session=2290798860496








/*11. Interogare 7 - Grid*/
/*segmente care dau rating mare, dar interactioneaza putin*/
SELECT 
    segment,
    ROUND(AVG(rating_mediu),2) AS rating_mediu,
    ROUND(AVG(scor_total),2) AS activitate_medie
FROM fact_full_analysis
GROUP BY segment
HAVING AVG(rating_mediu) > (
        SELECT AVG(rating_mediu) FROM fact_full_analysis
    )
   AND AVG(scor_total) < (
        SELECT AVG(scor_total) FROM fact_full_analysis
    );
/*aici avem categoria de clienti pretentiosi*/


URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/segment-that-give-high-ratings-but-little-interaction?session=2290798860496








/*12. Interogare 8 - Grid*/
/*Categoria de produse populare si bine evaluate*/

SELECT 
    "product_id",
    "category",
    "brand",
    scor_total_interactiuni,
    rating_mediu
FROM fact_product_reviews
WHERE scor_total_interactiuni > (
        SELECT AVG(scor_total_interactiuni) FROM fact_product_reviews
    )
  AND rating_mediu > (
        SELECT AVG(rating_mediu) FROM fact_product_reviews
    )
ORDER BY rating_mediu DESC;
/*aici avem produsele ideale*/


URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/popular-and-well-rated-product-category?session=2290798860496







/*13. Interogare 9 - Grid*/
/*Impactul evenimentului asupra ratingului*/

SELECT 
    "event_type",
    COUNT(*) AS nr_interactiuni,
    ROUND(AVG(rating_mediu),2) AS rating_mediu,
    
    RANK() OVER (ORDER BY AVG(rating_mediu) DESC) AS ranking_rating
FROM vw_consolidare_full_analysis
GROUP BY "event_type";
/*ce evenimente duc la un rating mai mare(purchase vs. view)*/


URL: http://localhost:8080/ords/r/ecommerce1/ecommerce/the-impact-of-the-event-on-the-rating?session=2290798860496
