
###/*Analytical Views*/###




-------------------------------------------------------------------------------
/*MEMBRU 1*/




/*1. view analytic OLAP_cube*/

CREATE OR REPLACE VIEW olap_cube AS
SELECT 
    NVL("category", 'TOTAL') AS category,
    NVL("brand", 'TOTAL') AS brand,
    NVL(segment, 'TOTAL') AS segment,
    COUNT(*) AS total_interactiuni,
    SUM("event_value") AS scor_total
FROM vw_consolidare
GROUP BY CUBE (
    "category",
    "brand",
    segment
);

SELECT * FROM olap_cube FETCH FIRST 10 ROWS ONLY;

/*View-ul olap_cube realizeaza o analiza multidimensionala a interactiunilor, 
agregand datele pe categorii, branduri si segmente de utilizatori, 
folosind operatorul CUBE pentru a genera toate combinatiile posibile, inclusiv subtotaluri si total general*/
/*Cine (segment) interactioneaza cu ce (categorie + brand) si cat de mult*/


/*2. View OLAP rollup*/
CREATE OR REPLACE VIEW olap_rollup AS
SELECT 
    NVL("category",'TOTAL') AS category,
    NVL("brand",'TOTAL') AS brand,
    COUNT(*) AS total_interactiuni
FROM vw_consolidare
GROUP BY ROLLUP("category","brand");

SELECT * FROM olap_rollup ORDER BY category, brand;

/*View-ul calculeaza numarul total de interactiuni si scorul total agregat pe categorii si branduri,
incluzand subtotaluri pe categorie si total general.*/



/*3. view olap_segment*/

CREATE OR REPLACE VIEW olap_segment AS
SELECT 
    NVL(segment, 'TOTAL') AS segment,
    NVL("category", 'TOTAL') AS category,
    NVL("brand", 'TOTAL') AS brand,
    
    COUNT(*) AS total_interactiuni,
    SUM("event_value") AS scor_total
FROM vw_consolidare
GROUP BY CUBE (
    segment,
    "category",
    "brand"
);

SELECT * FROM olap_segment ORDER BY segment, category, brand;
    
/*View-ul OLAP olap_segment realizeaza o analiza multidimensionala a interactiunilor in functie de segmentul utilizatorilor, categorie si brand,
utilizand operatorul CUBE pentru a genera toate combinatiile posibile, inclusiv totaluri si subtotaluri.
Datele provin dintr-un view de consolidare care integreaza MongoDB, PostgreSQL si CSV.*/




--------------------------------------------------------------------------------

/*MEMBRU 2*/



/*1. view olap_cube */
CREATE OR REPLACE VIEW olap_product_reviews AS
SELECT 
    NVL("category", 'TOTAL') AS category,
    NVL("brand", 'TOTAL') AS brand,
    NVL(segment, 'TOTAL') AS segment,
    
    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews,
    AVG(rating_mediu) AS rating_mediu
FROM vw_consolidare_product_reviews
GROUP BY CUBE (
    "category",
    "brand",
    segment
);

SELECT *FROM olap_product_reviews FETCH FIRST 10 ROWS ONLY;
/*View-ul realizeaza o analiza multidimensionala a interactiunilor si review-urilor,
agregand datele pe categorii, branduri si segmente de utilizatori,
utilizand operatorul CUBE pentru a genera toate combinatiile posibile, inclusiv subtotaluri si total general*/



/*2. view olap_rollup  */
CREATE OR REPLACE VIEW olap_product_reviews_rollup AS
SELECT 
    NVL("category",'TOTAL') AS category,
    NVL("brand",'TOTAL') AS brand,
    
    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews
FROM vw_consolidare_product_reviews
GROUP BY ROLLUP("category","brand");

SELECT *FROM olap_product_reviews_rollup FETCH FIRST 10 ROWS ONLY;

/*View-ul realizeaza o agregare ierarhica a interactiunilor si review-urilor,
pe categorii si branduri de produse,
utilizand operatorul ROLLUP pentru a genera subtotaluri si totalul general*/





/*3. view olap_segment */
CREATE OR REPLACE VIEW olap_segment_category_reviews AS
SELECT 
    NVL(segment,'TOTAL') AS segment,
    NVL("category",'TOTAL') AS category,
    
    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews
FROM vw_consolidare_product_reviews
GROUP BY CUBE(segment, "category");


SELECT * FROM olap_segment_category_reviews ORDER BY segment, category;
/*View-ul realizeaza o analiza multidimensionala a interactiunilor si review-urilor,
agregand datele pe segmente de utilizatori si categorii de produse,
utilizand operatorul CUBE pentru a genera toate combinatiile posibile, inclusiv subtotaluri si totaluri*/

/*View-ul evidentiaza interactiunile si review-urile in functie de segment si categorie,
permitand analiza comparativa intre diferite segmente de utilizatori si tipuri de produse*/



--------------------------------------------------------------------------------

/*MEMBRU 3*/




/*1. view olap_cube*/

CREATE OR REPLACE VIEW olap_full_segment_category_event AS
SELECT 
    NVL(segment,'TOTAL') AS segment,
    NVL("category",'TOTAL') AS category,
    NVL("event_type",'TOTAL') AS event_type,
    
    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews,
    AVG(rating_mediu) AS rating_mediu
FROM vw_consolidare_full_analysis
GROUP BY CUBE(
    segment,
    "category",
    "event_type"
);


SELECT * FROM olap_full_segment_category_event ORDER BY scor_total DESC;
/*View-ul realizeaza o analiza multidimensionala a interactiunilor si review-urilor,
agregand datele pe segmente, categorii si tipuri de interactiuni,
utilizand operatorul CUBE pentru a genera toate combinatiile posibile, inclusiv subtotaluri si totaluri*/



/*2. view olap_rollup*/

CREATE OR REPLACE VIEW olap_full_category_brand_rollup AS
SELECT 
    NVL("category",'TOTAL') AS category,
    NVL("brand",'TOTAL') AS brand,
    
    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews
FROM vw_consolidare_full_analysis
GROUP BY ROLLUP(
    "category",
    "brand"
);

SELECT * FROM olap_full_category_brand_rollup ORDER BY category, brand;

/*View-ul realizeaza o agregare ierarhica a interactiunilor si review-urilor,
pe categorii si branduri de produse,
utilizand operatorul ROLLUP pentru a genera subtotaluri si totalul general*/




/*3. view olap_segment*/
CREATE OR REPLACE VIEW olap_full_segment_brand AS
SELECT 
    NVL(segment,'TOTAL') AS segment,
    NVL("brand",'TOTAL') AS brand,
    
    SUM(scor_interactiuni) AS scor_total,
    AVG(rating_mediu) AS rating_mediu
FROM vw_consolidare_full_analysis
GROUP BY CUBE(
    segment,
    "brand"
);


SELECT * FROM olap_full_segment_brand ORDER BY scor_total DESC;

/*View-ul realizeaza o analiza multidimensionala a interactiunilor si rating-urilor,
agregand datele pe segmente de utilizatori si branduri,
utilizand operatorul CUBE pentru a genera toate combinatiile posibile, inclusiv subtotaluri si totaluri*/

