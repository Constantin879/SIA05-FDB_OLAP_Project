

####/*Consolidation and Multidimensional Views*/


------------------------------------------------------------------------------
/*MEMBRU 1*/

/*1. view  CONSOLIDARE1  */

CREATE OR REPLACE VIEW vw_consolidare AS
SELECT 
    u.user_id,
    u.user_name,
    u.city,
    u.segment,
    
    p."product_id",
    p."product_name",
    p."category",
    p."sub_category",
    p."brand",
    
    i."event_type",
    i."event_value",
    
    TO_NUMBER(r.rating) AS rating
FROM users_full_mongodb u
JOIN "interactions"@PG i 
    ON u.user_id = i."user_id"
JOIN "products"@PG p 
    ON p."product_id" = i."product_id"
LEFT JOIN reviews_ext r 
    ON r.product_id = p."product_id";
    
    
SELECT * FROM vw_consolidare FETCH FIRST 5 ROWS ONLY;
/*View-ul evidentiaza comportamentul utilizatorilor in functie de segment si produse,
prin tipul si intensitatea interactiunilor, precum si prin evaluarile (rating-urile) acestora*/




    
/*2. FACT view - tabela de fapte1*/

CREATE OR REPLACE VIEW fact_activitate AS
SELECT 
    "product_id",
    user_id,
    "category",
    "sub_category",
    "brand",
    segment,
    
    COUNT(*) AS nr_interactii,
    SUM("event_value") AS scor_activitate,
    AVG(rating) AS rating_mediu
FROM vw_consolidare
GROUP BY 
    "product_id",
    user_id,
    "category",
    "sub_category",
    "brand",
    segment;
    
SELECT * FROM fact_activitate FETCH FIRST 5 ROWS ONLY;

/*View-ul agrega activitatea utilizatorilor asupra produselor,
evidentiind numarul de interactiuni, intensitatea acestora si rating-ul mediu,
in functie de produs, categorie si segment*/



/*3. DIMENSIUNI */


/*3.1.dim_produs + rating + interactiuni*/
CREATE OR REPLACE VIEW dim_user_product AS
SELECT DISTINCT
    user_id,
    user_name,
    city,
    segment,
    
    "product_id",
    "product_name",
    "category",
    "brand",
    
    "event_type",
    rating
FROM vw_consolidare;

SELECT * FROM dim_user_product FETCH FIRST 10 ROWS ONLY;

/*View-ul evidentiaza relatia dintre utilizatori si produse,
incluzand caracteristicile utilizatorilor, ale produselor si tipurile de interactiuni,
impreuna cu evaluarile (rating-urile) asociate*/



/*3.2. dim_produs + rating + interactiuni*/
CREATE OR REPLACE VIEW dim_product_fullP AS
SELECT DISTINCT
    "product_id",
    "product_name",
    "category",
    "sub_category",
    "brand",
    
    "event_type",
    "event_value",
    rating
FROM vw_consolidare;

SELECT * FROM dim_product_fullP FETCH FIRST 10 ROWS ONLY;

/*View-ul evidentiaza caracteristicile produselor impreuna cu tipurile si intensitatea interactiunilor,
precum si evaluarile (rating-urile) asociate acestora*/



/*3.3. dim_utilizator + activitate + rating*/
 CREATE OR REPLACE VIEW dim_user_activity AS
SELECT DISTINCT
    user_id,
    user_name,
    city,
    segment,
    
    "event_type",
    "event_value",
    rating
FROM vw_consolidare; 

SELECT * FROM dim_user_activity FETCH FIRST 10 ROWS ONLY;

/*View-ul evidentiaza activitatea utilizatorilor,
incluzand tipurile si intensitatea interactiunilor,
precum si evaluarile (rating-urile) asociate acestora*/





--------------------------------------------------------------------------------

/*MEMBRU 2*/

/*1. view consolidare2*/
CREATE OR REPLACE VIEW vw_consolidare_product_reviews AS
SELECT 
    u.user_id,
    u.segment,
    
    p."product_id",
    p."product_name",
    p."category",
    p."brand",
    
    i."event_type",
    SUM(i."event_value") AS scor_interactiuni,
    
    COUNT(r.review_id) AS nr_reviews,
    AVG(TO_NUMBER(r.rating)) AS rating_mediu
FROM users_full_mongodb u
JOIN "interactions"@PG i
    ON u.user_id = i."user_id"
JOIN "products"@PG p
    ON p."product_id" = i."product_id"
LEFT JOIN reviews_ext r
    ON p."product_id" = r.product_id
GROUP BY 
    u.user_id,
    u.segment,
    p."product_id",
    p."product_name",
    p."category",
    p."brand",
    i."event_type";
    
SELECT * FROM vw_consolidare_product_reviews FETCH FIRST 5 ROWS ONLY;

/*View-ul integreaza si agrega date despre utilizatori, produse si review-uri,
evidentiind intensitatea interactiunilor, numarul de evaluari si rating-ul mediu,
in functie de utilizator, produs si tipul interactiunii*/



/*2. View tabela de fapte2*/

CREATE OR REPLACE VIEW fact_product_reviews AS
SELECT 
    "product_id",
    "category",
    "brand",
    segment,
    
    SUM(scor_interactiuni) AS scor_total_interactiuni,
    SUM(nr_reviews) AS total_reviews,
    AVG(rating_mediu) AS rating_mediu
FROM vw_consolidare_product_reviews
GROUP BY 
    "product_id",
    "category",
    "brand",
    segment;

SELECT * FROM fact_product_reviews FETCH FIRST 10 ROWS ONLY;

/*View-ul agrega activitatea produselor,
evidentiind scorul total al interactiunilor, numarul total de review-uri si rating-ul mediu,
in functie de produs, categorie, brand si segment*/




/*3. VIEW dimensiune 3 surse*/

CREATE OR REPLACE VIEW dim_product_full AS
SELECT DISTINCT
    p."product_id",
    p."product_name",
    p."category",
    p."sub_category",
    p."brand",
    
    u.segment,
    
    COUNT(r.review_id) OVER (PARTITION BY p."product_id") AS nr_reviews,
    AVG(TO_NUMBER(r.rating)) OVER (PARTITION BY p."product_id") AS rating_mediu
FROM "products"@PG p
JOIN "interactions"@PG i
    ON p."product_id" = i."product_id"
JOIN users_full_mongodb u
    ON u.user_id = i."user_id"
LEFT JOIN reviews_ext r
    ON p."product_id" = r.product_id;


SELECT *FROM dim_product_full FETCH FIRST 10 ROWS ONLY;
/*View-ul evidentiaza caracteristicile produselor in functie de segmentul utilizatorilor,
incluzand numarul de review-uri si rating-ul mediu asociat fiecarui produs*/

/*Interogarea evidentiaza distributia produselor pe categorii, branduri si segmente de utilizatori, impreuna cu evaluarile si numarul de review-uri*/






--------------------------------------------------------------------------------

/*MEMBRU 3*/
    
/*1. View consolidare 3*/

CREATE OR REPLACE VIEW vw_consolidare_full_analysis AS
SELECT 
    u.user_id,
    u.user_name,
    u.segment,
    u.city,
    
    p."product_id",
    p."product_name",
    p."category",
    p."brand",
    
    i."event_type",
    SUM(i."event_value") AS scor_interactiuni,
    
    COUNT(r.review_id) AS nr_reviews,
    AVG(TO_NUMBER(r.rating)) AS rating_mediu
FROM users_full_mongodb u
JOIN "interactions"@PG i
    ON u.user_id = i."user_id"
JOIN "products"@PG p
    ON p."product_id" = i."product_id"
LEFT JOIN reviews_ext r
    ON p."product_id" = r.product_id
GROUP BY 
    u.user_id,
    u.user_name,
    u.segment,
    u.city,
    p."product_id",
    p."product_name",
    p."category",
    p."brand",
    i."event_type";
    
SELECT * FROM vw_consolidare_full_analysis FETCH FIRST 10 ROWS ONLY;
/*View-ul integreaza si agrega date despre utilizatori, produse si interactiuni,
evidentiind comportamentul acestora prin intensitatea interactiunilor,
numarul de review-uri si rating-ul mediu, in functie de utilizator, segment si produs*/



/*2. view tabela de fapte 3*/
CREATE OR REPLACE VIEW fact_full_analysis AS
SELECT 
    "product_id",
    user_id,
    "category",
    "brand",
    segment,
    
    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews,
    AVG(rating_mediu) AS rating_mediu
FROM vw_consolidare_full_analysis
GROUP BY 
    "product_id",
    user_id,
    "category",
    "brand",
    segment;
    
SELECT * FROM fact_full_analysis FETCH FIRST 10 ROWS ONLY;

/*View-ul agrega activitatea utilizatorilor asupra produselor,
evidentiind scorul total al interactiunilor, numarul de review-uri si rating-ul mediu,
in functie de produs, utilizator, categorie, brand si segment*/


/*DIMENSIUNI*/
/*3.1 view dim_user_full 3 surse*/

CREATE OR REPLACE VIEW dim_user_full AS
SELECT DISTINCT
    user_id,
    user_name,
    segment,
    city,
    
    "category",
    "brand",
    
    "event_type",
    rating_mediu
FROM vw_consolidare_full_analysis;

SELECT * FROM dim_user_full FETCH FIRST 10 ROWS ONLY;

/* View-ul evidentiaza caracteristicile utilizatorilor impreuna cu interactiunile acestora,
incluzand segmentul, locatia, produsele asociate si rating-urile aferente*/





/*3.2 view dimensiune produs  extinsa 3 surse*/

CREATE OR REPLACE VIEW dim_product_fulll AS
SELECT DISTINCT
    "product_id",
    "product_name",
    "category",
    "brand",
    
    segment,
    "event_type",
    rating_mediu
FROM vw_consolidare_full_analysis;

SELECT * FROM dim_product_fulll FETCH FIRST 10 ROWS ONLY;

/*View-ul evidentiaza caracteristicile produselor impreuna cu segmentul utilizatorilor,
tipurile de interactiuni si evaluarile (rating-urile) asociate acestora*/



/*3.3 view dimensiune comportament extinsa 3 surse*/
CREATE OR REPLACE VIEW dim_behavior_full AS
SELECT DISTINCT
    "event_type",
    
    segment,
    city,
    
    "category",
    "brand",
    
    rating_mediu
FROM vw_consolidare_full_analysis;

SELECT * FROM dim_behavior_full FETCH FIRST 10 ROWS ONLY;
/*View-ul evidentiaza tipurile de interactiuni ale utilizatorilor,
in functie de segment, locatie si produse, impreuna cu evaluarile (rating-urile) asociate*/



