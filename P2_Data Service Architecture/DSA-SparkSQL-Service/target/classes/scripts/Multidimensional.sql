

------------------------------------------------
------------------------------------------------

-----------/*TEMA 3*/------------------

------------------------------------------------

------ Preparing ---------------------------------------------------------------
--- DSA-SQL-JPAService access to: PostgreSQL Data Source [Interactions, Products]
--- DSA-DOC-CSVService: CSV Data Source [Reviews]
--- DSA-NoSQL-MongoDBService: MongoDB Data Source [Profile] from userss
--------------------------------------------------------------------------------
-- Data Source Remote/External Views -------------------------------------------


-- Data Source Remote/External Views -------------------------------------------
-- Oracle DSA-SQL-JPAService
SELECT * FROM PRODUCTS_VIEW;
select * from INTERACTIONS_VIEW;


--- Excel DSA-DOC-CSVService
select * FROM REVIEWS_CSV_VIEW;

--- XML DSA-NoSQL-MongoDBService
select * from USERSPROFILE_VIEW;


-----------------------------------------------------------


/*COLEG 1*/

/*1. view  CONSOLIDARE1  */
CREATE OR REPLACE VIEW vw_consolidare AS
SELECT
    u.user_id,
    u.user_name,
    u.city,
    u.segment,
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category,
    p.brand,
    i.event_type,
    i.event_value,
    r.rating 
FROM usersprofile_view u
JOIN interactions_view i ON u.user_id = i.user_id
JOIN products_view p ON p.product_id = i.product_id
LEFT JOIN reviews_csv_view r ON r.product_id = i.product_id AND r.user_id = i.user_id;

SELECT * FROM vw_consolidare LIMIT 5;




/*View-ul evidentiaza comportamentul utilizatorilor în functie de segment si produse,
prin tipul si intensitatea interactiunilor, precum si prin evaluările (rating-urile) acestora*/







/*2. FACT view - tabela de fapte1*/

CREATE OR REPLACE VIEW fact_activitate AS
SELECT
    product_id,
    user_id,
    category,
    sub_category,
    brand,
    segment,
    COUNT(*) AS nr_interactii,
    SUM(event_value) AS scor_activitate,
    AVG(rating) AS rating_mediu
FROM vw_consolidare
GROUP BY product_id, user_id, category, sub_category, brand, segment;


/*View-ul agregă activitatea utilizatorilor asupra produselor,
evidentiind numărul de interac?iuni, intensitatea acestora si rating-ul mediu,
în functie de produs, categorie ?i segment*/




/*INTEROGRE PE fact_activitate*/
/*Care este nivelul total de activitate al utilizatorilor pe categorii de produse si segmente?*/


SELECT
    segment,
    category,
    SUM(nr_interactii) AS total_interactii,
    SUM(scor_activitate) AS scor_total
FROM fact_activitate
GROUP BY segment, category
ORDER BY scor_total DESC;




/*INTEROGRE2 PE fact_activitate*/


SELECT
    brand,
    AVG(rating_mediu) AS rating_reprezentativ,
    SUM(nr_interactii) AS popularitate
FROM fact_activitate
GROUP BY brand
ORDER BY rating_reprezentativ DESC;




/*INTEROGRE3 PE fact_activitate*/


SELECT
    segment,
    sub_category,
    SUM(nr_interactii) AS total_interactii,
    AVG(rating_mediu) AS rating_mediu
FROM fact_activitate
GROUP BY segment, sub_category
ORDER BY total_interactii DESC;






/*3. DIMENSIUNI */

/*dimensiune user*/

CREATE OR REPLACE VIEW dim_user AS
SELECT DISTINCT
    user_id,
    user_name,
    city,
    segment
FROM usersprofile_view;






/*interogare dim_user*/
/*Care este distributia utilizatorilor în functie de segment si oras?*/
/* INTEROGARE dim_user */
SELECT
    segment,
    city,
    COUNT(*) AS nr_useri
FROM dim_user
GROUP BY segment, city
ORDER BY nr_useri DESC;

/*Distributia utilizatorilor arată concentrarea acestora pe anumite segmente si orase,
oferind perspective asupra bazei de clienti*/





/*dimensiune produs*/
/* DIMENSIUNE PRODUS */
CREATE OR REPLACE VIEW dim_product AS
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category,
    brand
FROM products_view;


/*interogare dim_produs*/
/*Cum sunt distribuite produsele în functie de categorie si brand?*/
/* INTEROGARE dim_produs */
SELECT
    category,
    brand,
    COUNT(*) AS nr_produse
FROM dim_product
GROUP BY category, brand
ORDER BY nr_produse DESC;










/*dimensiune segment*/
/* DIMENSIUNE SEGMENT */
CREATE OR REPLACE VIEW dim_segment AS
SELECT DISTINCT
    user_id,
    segment,
    city,
    age,
    gender,
    signup_date
FROM usersprofile_view;

SELECT * FROM dim_segment LIMIT 5;



/*interogare dim_segment*/
/* Care este distributia utilizatorilor în functie de segment, oras si gen?*/
SELECT
    segment,
    city,
    gender,
    COUNT(DISTINCT user_id) AS nr_useri
FROM dim_segment
GROUP BY segment, city, gender
ORDER BY nr_useri DESC;











/*dimensiuni cu 3 surse*/

/*dim_produs + rating + interactiuni*/
CREATE OR REPLACE VIEW dim_user_product AS
SELECT DISTINCT
    user_id,
    user_name,
    city,
    segment,
    product_id,
    product_name,
    category,
    brand,
    event_type,
    rating
FROM vw_consolidare;

/* Vizualizare rezultate dim_user_product */
SELECT * FROM dim_user_product LIMIT 10;

/*/*View-ul eviden?iază rela?ia dintre utilizatori ?i produse,
incluzând caracteristicile utilizatorilor, ale produselor ?i tipurile de interac?iuni,
împreună cu evaluările (rating-urile) asociate*/*/



/*dim_produs + rating + interacTiuni*/
/* VIEW DETALIAT PRODUSE (dim_produs + rating + interacțiuni) */

CREATE OR REPLACE VIEW dim_product_fullP AS
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category,
    brand,
    event_type,
    event_value,
    rating
FROM vw_consolidare;

/* Verificare rezultate dim_product_fullP */
SELECT * FROM dim_product_fullP LIMIT 10;

/*View-ul evidentiaza caracteristicile produselor impreuna cu tipurile si intensitatea interactiunilor,
precum si evaluarile (rating-urile) asociate acestora*/



/*dim_utilizator + activitate + rating*/
CREATE OR REPLACE VIEW dim_user_activity AS
SELECT DISTINCT
    user_id,
    user_name,
    city,
    segment,
    event_type,
    event_value,
    rating
FROM vw_consolidare;

/* Verificare rezultate dim_user_activity */
SELECT * FROM dim_user_activity LIMIT 10;

/*View-ul eviden?iază activitatea utilizatorilor,
incluzând tipurile ?i intensitatea interac?iunilor,
precum ?i evaluările (rating-urile) asociate acestora*/





/*4. view analytic OLAP_cube*/


CREATE OR REPLACE VIEW olap_cube AS
SELECT
    COALESCE(category, 'TOTAL') AS category,
    COALESCE(brand, 'TOTAL') AS brand,
    COALESCE(segment, 'TOTAL') AS segment,
    COUNT(*) AS total_interactiuni,
    SUM(event_value) AS scor_total
FROM vw_consolidare
GROUP BY CUBE (
    category,
    brand,
    segment
);

/* Vizualizare rezultate OLAP Cube */
SELECT * FROM olap_cube LIMIT 10;

/*View-ul olap_cube realizează o analiză multidimensională a interactiunilor,
agregând datele pe categorii, branduri ?i segmente de utilizatori,
folosind operatorul CUBE pentru a genera toate combina?iile posibile, inclusiv subtotaluri si total general*/
/*Cine (segment) interactionează cu ce (categorie + brand) si cât de mult*/


/*5. View OLAP rollup*/
/*dim_utilizator + activitate + rating*/
CREATE OR REPLACE VIEW dim_user_activity AS
SELECT DISTINCT
    user_id,
    user_name,
    city,
    segment,
    event_type,
    event_value,
    rating
FROM vw_consolidare;

SELECT * FROM dim_user_activity LIMIT 10;

/*View-ul calculează numărul total de interactiuni si scorul total agregat pe categorii si branduri,
incluzând subtotaluri pe categorie si total general.*/




/*interogare olap*/
/*Care sunt combinatiile de categorie, brand si segment care generează cele mai multe interactiuni?*/

SELECT *
FROM olap_cube
WHERE segment != 'TOTAL'
  AND category != 'TOTAL'
  AND brand != 'TOTAL'
ORDER BY scor_total DESC;
/*Rezultatele evidentiază combinatiile cele mai relevante dintre categorie, brand si tip de utilizator,
permitând identificarea zonelor cu activitate intensă.*/


/*interogare2 olap*/
/*Care sunt cele mai populare combina?ii de categorie si brand la nivel global (indiferent de segment)?*/
SELECT
    category,
    brand,
    SUM(total_interactiuni) AS total
FROM olap_cube
WHERE segment = 'TOTAL'
  AND category != 'TOTAL'
  AND brand != 'TOTAL'
GROUP BY category, brand
ORDER BY total DESC;


/*interogare3 olap*/
/* Interogare CUBE pentru Segment și Categorie */
SELECT
    COALESCE(segment, 'TOTAL') AS segment,
    COALESCE(category, 'TOTAL') AS category,
    COUNT(*) AS total_interactii
FROM vw_consolidare
GROUP BY CUBE(segment, category)
ORDER BY segment, category;



/*interogare fact+olap*/
/*Care este nivelul de activitate al utilizatorilor (măsurat prin numărul de interactiuni si scorul total al acestora),
analizat pe tipuri de utilizatori (segment), categorii de produse si branduri?*/

/* Analiză detaliată: Segment, Categorie și Brand */
SELECT 
    u.segment,
    p.category,
    p.brand,
    SUM(f.nr_interactii) AS total_interactiuni,
    SUM(f.scor_activitate) AS scor_total
FROM fact_activitate f
JOIN dim_user u 
    ON f.user_id = u.user_id
JOIN dim_product p 
    ON f.product_id = p.product_id
GROUP BY 
    u.segment,
    p.category,
    p.brand
ORDER BY scor_total DESC;

/*Rezultatele evidentiază modul în care diferitele segmente de utilizatori interactionează cu produsele,
permitând identificarea categoriilor si brandurilor care generează cel mai ridicat nivel de activitate.*/




/*6. view olap_segment*/

/* 6. view olap_segment */

CREATE OR REPLACE VIEW olap_segment AS
SELECT
    COALESCE(segment, 'TOTAL') AS segment,
    COALESCE(category, 'TOTAL') AS category,
    COALESCE(brand, 'TOTAL') AS brand,
    COUNT(*) AS total_interactiuni,
    SUM(event_value) AS scor_total
FROM vw_consolidare
GROUP BY CUBE (
    segment,
    category,
    brand
);

/* Vizualizare rezultate ordonate conform cerinței */
SELECT * FROM olap_segment ORDER BY segment, category, brand;

/*View-ul OLAP olap_segment realizează o analiză multidimensională a interac?iunilor în func?ie de segmentul utilizatorilor, categorie ?i brand,
utilizând operatorul CUBE pentru a genera toate combina?iile posibile, inclusiv totaluri ?i subtotaluri.
Datele provin dintr-un view de consolidare care integrează MongoDB, PostgreSQL ?i CSV.*/














--------------------------------------------------------------------------------

/*COLEG 2*/

/*1. view consolidare2*/

CREATE OR REPLACE VIEW vw_consolidare_product_reviews AS
SELECT
    u.user_id,
    u.segment,
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    i.event_type,
    SUM(i.event_value) AS scor_interactiuni,
    COUNT(r.review_id) AS nr_reviews,
    AVG(CAST(r.rating AS DOUBLE)) AS rating_mediu
FROM usersprofile_view u       -- Tabelul din poza 4
JOIN interactions_view i        -- Tabelul din poza 2 (Alias i)
    ON u.user_id = i.user_id
JOIN products_view p            -- Tabelul din poza 1 (Alias p - AICI ERA DEFECTUL)
    ON p.product_id = i.product_id
LEFT JOIN reviews_csv_view r    -- Tabelul din poza 3 (Alias r)
    ON p.product_id = r.product_id
GROUP BY
    u.user_id,
    u.segment,
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    i.event_type;

/* Verificare */
SELECT * FROM vw_consolidare_product_reviews LIMIT 10;

/*View-ul integrează ?i agregă date despre utilizatori, produse ?i review-uri,
eviden?iind intensitatea interac?iunilor, numărul de evaluări ?i rating-ul mediu,
în func?ie de utilizator, produs ?i tipul interac?iunii*/



/*2. View tabela de fapte2*/
/* Creare View Fact Product Reviews */

CREATE OR REPLACE VIEW fact_product_reviews AS
SELECT
    product_id,
    category,
    brand,
    segment,
    SUM(scor_interactiuni) AS scor_total_interactiuni,
    SUM(nr_reviews) AS total_reviews,
    AVG(rating_mediu) AS rating_mediu
FROM vw_consolidare_product_reviews
GROUP BY
    product_id,
    category,
    brand,
    segment;

/* Vizualizare rezultate fact_product_reviews */
SELECT * FROM fact_product_reviews LIMIT 10;

/*View-ul agregă activitatea produselor,
eviden?iind scorul total al interac?iunilor, numărul total de review-uri ?i rating-ul mediu,
în func?ie de produs, categorie, brand ?i segment*/




/*3. VIEW dimensiune 3 surse*/

CREATE OR REPLACE VIEW dim_product_full AS
SELECT DISTINCT
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category,
    p.brand,
    u.segment,
    COUNT(r.review_id) OVER (PARTITION BY p.product_id) AS nr_reviews,
    AVG(CAST(r.rating AS DOUBLE)) OVER (PARTITION BY p.product_id) AS rating_mediu
FROM products_view p             
JOIN interactions_view i         
    ON p.product_id = i.product_id
JOIN usersprofile_view u         
    ON u.user_id = i.user_id
LEFT JOIN reviews_csv_view r     
    ON p.product_id = r.product_id;

/* Verificare rezultat */
SELECT * FROM dim_product_full LIMIT 10;


/*View-ul eviden?iază caracteristicile produselor în func?ie de segmentul utilizatorilor,
incluzând numărul de review-uri ?i rating-ul mediu asociat fiecărui produs*/

/*Interogarea evidentiază distributia produselor pe categorii, branduri si segmente de utilizatori, impreună cu evaluările si numarul de review-uri*/





/*4. view olap_cube */
/* 4. view olap_cube - Analiză Multidimensională Review-uri și Interacțiuni */

CREATE OR REPLACE VIEW olap_product_reviews AS
SELECT
    COALESCE(category, 'TOTAL') AS category,
    COALESCE(brand, 'TOTAL') AS brand,
    COALESCE(segment, 'TOTAL') AS segment,

    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews,
    AVG(rating_mediu) AS rating_mediu
FROM vw_consolidare_product_reviews
GROUP BY CUBE (
    category,
    brand,
    segment
);

/* Vizualizare rezultate OLAP Cube */
SELECT * FROM olap_product_reviews LIMIT 10;




/*5. view olap_rollup  */
CREATE OR REPLACE VIEW olap_product_reviews_rollup AS
SELECT
    NVL("category",'TOTAL') AS category,
    NVL("brand",'TOTAL') AS brand,

    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews
FROM vw_consolidare_product_reviews
GROUP BY ROLLUP("category","brand");

SELECT * FROM olap_product_reviews_rollup LIMIT 10;

/*View-ul realizează o analiză multidimensională a interac?iunilor ?i review-urilor,
agregând datele pe categorii, branduri ?i segmente de utilizatori,
utilizând operatorul CUBE pentru a genera toate combina?iile posibile, inclusiv subtotaluri ?i total general*/





/*6. view olap_segment */

CREATE OR REPLACE VIEW olap_segment_category_reviews AS
SELECT
    NVL(segment,'TOTAL') AS segment,
    NVL("category",'TOTAL') AS category,

    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews
FROM vw_consolidare_product_reviews
GROUP BY CUBE(segment, "category");


SELECT * FROM olap_segment_category_reviews ORDER BY segment, category;
/*View-ul realizează o analiză multidimensională a interac?iunilor ?i review-urilor,
agregând datele pe segmente de utilizatori ?i categorii de produse,
utilizând operatorul CUBE pentru a genera combina?iile posibile, inclusiv subtotaluri ?i totaluri*/

/*View-ul analizeaza interactiunile si review-urile în functie de segment si categorie,
folosind operatorul CUBE pentru a genera toate combinatiile si totalurile agregate*/














--------------------------------------------------------------------------------

/*COLEG 3*/

/*1. View consolidare 3*/
/*Care este comportamentul utilizatorilor în functie de segment si categorie de produse,
analizat prin intensitatea interactiunilor si evaluarile (ratingurile) produselor?*/


/* Creare View pentru Analiză Consolidată */
CREATE OR REPLACE VIEW vw_consolidare_full_analysis AS
SELECT
    u.user_id,
    u.user_name,
    u.segment,
    u.city,

    p.product_id,
    p.product_name,
    p.category,
    p.brand,

    i.event_type,
    SUM(i.event_value) AS scor_interactiuni,
    COUNT(r.review_id) AS nr_reviews,
    AVG(CAST(r.rating AS DOUBLE)) AS rating_mediu
FROM usersprofile_view u
JOIN interactions_view i
    ON u.user_id = i.user_id
JOIN products_view p
    ON p.product_id = i.product_id
LEFT JOIN reviews_csv_view r
    ON p.product_id = r.product_id
GROUP BY
    u.user_id,
    u.user_name,
    u.segment,
    u.city,
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    i.event_type;

/* Interogare pentru vizualizarea rezultatelor */
SELECT * FROM vw_consolidare_full_analysis LIMIT 10;
/*View-ul integrează ?i agregă date despre utilizatori, produse ?i interac?iuni,
eviden?iind comportamentul acestora prin intensitatea interac?iunilor,
numărul de review-uri ?i rating-ul mediu, în func?ie de utilizator, segment ?i produs*/



/*2. view tabela de fapte 3*/
CREATE OR REPLACE VIEW fact_full_analysis AS
SELECT
    product_id,
    user_id,
    category,
    brand,
    segment,
    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews,
    AVG(rating_mediu) AS rating_mediu
FROM vw_consolidare_full_analysis
GROUP BY
    product_id,
    user_id,
    category,
    brand,
    segment;

/* Verificare Rezultate */
SELECT * FROM fact_full_analysis LIMIT 10;

/*View-ul agregă activitatea utilizatorilor asupra produselor,
eviden?iind scorul total al interac?iunilor, numărul de review-uri ?i rating-ul mediu,
în func?ie de produs, utilizator, categorie, brand ?i segment*/




/*dim_user*/

CREATE OR REPLACE VIEW dim_user_full AS
SELECT DISTINCT
    user_id,
    user_name,
    segment,
    city
FROM vw_consolidare_full_analysis;

/* Verificare Rezultate */
SELECT * FROM dim_user_full LIMIT 10;


/*dim_product*/

CREATE OR REPLACE VIEW dim_product_full AS
SELECT DISTINCT
    product_id,
    product_name,
    category,
    brand
FROM vw_consolidare_full_analysis;

/* Verificare Rezultate */
SELECT * FROM dim_product_full LIMIT 10;




/*3.1 view dim_user_full 3 surse*/


CREATE OR REPLACE VIEW dim_user_full AS
SELECT DISTINCT
    user_id,
    user_name,
    segment,
    city,
    category,   
    brand,       
    event_type,  
    rating_mediu
FROM vw_consolidare_full_analysis;

/* Verificare Rezultate */
SELECT * FROM dim_user_full LIMIT 10;

/* View-ul eviden?iază caracteristicile utilizatorilor împreună cu interac?iunile acestora,
incluzând segmentul, loca?ia, produsele asociate ?i rating-urile aferente*/





/*3.2 view dimensiune produs  extinsa 3 surse*/

CREATE OR REPLACE VIEW dim_product_full_ext AS
SELECT DISTINCT
    product_id,
    product_name,
    category,
    brand,
    segment,
    event_type,
    rating_mediu
FROM vw_consolidare_full_analysis;

/* Verificare Rezultate */
SELECT * FROM dim_product_full_ext LIMIT 10;

/*View-ul eviden?iază caracteristicile produselor împreună cu segmentul utilizatorilor,
tipurile de interac?iuni ?i evaluările (rating-urile) asociate acestora*/



/*3.3 view dimensiune comportament extinsa 3 surse*/

CREATE OR REPLACE VIEW dim_behavior_full AS
SELECT DISTINCT
    event_type,      
    segment,
    city,
    category,        
    brand,           
    rating_mediu
FROM vw_consolidare_full_analysis;

/* Verificare Rezultate */
SELECT * FROM dim_behavior_full LIMIT 10;
/*View-ul eviden?iază tipurile de interac?iuni ale utilizatorilor,
în func?ie de segment, loca?ie ?i produse, împreună cu evaluările (rating-urile) asociate*/





/*4. view olap_cube*/

CREATE OR REPLACE VIEW olap_full_segment_category_event AS
SELECT
    NVL(segment, 'TOTAL') AS segment,
    NVL(category, 'TOTAL') AS category,    
    NVL(event_type, 'TOTAL') AS event_type, 

    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews,
    AVG(rating_mediu) AS rating_mediu
FROM vw_consolidare_full_analysis
GROUP BY CUBE(
    segment,
    category,
    event_type
);

/* Interogare pentru vizualizarea rezultatelor, ordonate după scor */
SELECT * 
FROM olap_full_segment_category_event 
ORDER BY scor_total DESC 
LIMIT 20;
/*View-ul realizează o analiză multidimensională a interac?iunilor ?i review-urilor,
agregând datele pe segmente, categorii ?i tipuri de interac?iuni,
utilizând operatorul CUBE pentru a genera toate combina?iile posibile, inclusiv subtotaluri ?i totaluri*/



/*5. view olap_rollup*/

CREATE OR REPLACE VIEW olap_full_category_brand_rollup AS
SELECT
    NVL(category, 'TOTAL') AS category,
    NVL(brand, 'TOTAL') AS brand,

    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews
FROM vw_consolidare_full_analysis
GROUP BY ROLLUP(
    category,
    brand
);

/* Vizualizare rezultate ierarhice */
SELECT * 
FROM olap_full_category_brand_rollup 
ORDER BY category, brand;

/*View-ul realizează o agregare ierarhică a interac?iunilor ?i review-urilor,
pe categorii ?i branduri de produse,
utilizând operatorul ROLLUP pentru a genera subtotaluri ?i totalul general*/




/*6. view olap_segment*/

CREATE OR REPLACE VIEW olap_full_segment_brand AS
SELECT
    NVL(segment, 'TOTAL') AS segment,
    NVL(brand, 'TOTAL') AS brand,             

    SUM(scor_interactiuni) AS scor_total,
    AVG(rating_mediu) AS rating_mediu
FROM vw_consolidare_full_analysis
GROUP BY CUBE(
    segment,
    brand                                    
);

/* Vizualizare rezultate ordonate după impact (scor) */
SELECT * 
FROM olap_full_segment_brand 
ORDER BY scor_total DESC 
LIMIT 20;

/*View-ul realizează o analiză multidimensională a interac?iunilor ?i rating-urilor,
agregând datele pe segmente de utilizatori ?i branduri,
utilizând operatorul CUBE pentru a genera toate combina?iile posibile, inclusiv subtotaluri ?i totaluri*/


















/* Aici INTEROGARI_VIEW -uri de utilizat in aplicatia APEX*/



/*1. Primul Grid care contine datele View-ului olap_segment_category_reviews*/

CREATE OR REPLACE VIEW olap_segment_category_reviews AS
SELECT
    NVL(segment, 'TOTAL') AS segment,
    NVL(category, 'TOTAL') AS category, 

    SUM(scor_interactiuni) AS scor_total,
    SUM(nr_reviews) AS total_reviews
FROM vw_consolidare_product_reviews
GROUP BY CUBE(
    segment, 
    category                           
);

/* Vizualizare rezultate ordonate pentru raport */
SELECT * 
FROM olap_segment_category_reviews 
ORDER BY segment, category;
/*View-ul analizeaza interactiunile si review-urile în functie de segment si categorie,
folosind operatorul CUBE pentru a genera toate combinatiile si totalurile agregate*/




/*2. Interogare 1 - Pie */
/* Scor total pe categorie - extragere din Cub OLAP */
SELECT 
    category, 
    SUM(scor_total) AS scor_total_ctg 
FROM olap_segment_category_reviews
WHERE category <> 'TOTAL' 
  AND segment = 'TOTAL' 
GROUP BY category;






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





/*4. Interogare 3 - Grid*/
/*Segmentul cel mai activ pe categorie*/

SELECT 
    category,
    segment,
    scor_total
FROM (
    SELECT
        category,
        segment,
        SUM(scor_total) AS scor_total,
        /* Numerotăm segmentele în interiorul fiecărei categorii, începând cu cel mai mare scor */
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(scor_total) DESC) AS rn
    FROM olap_full_segment_category_event  -- View-ul de tip CUBE creat anterior
    WHERE category <> 'TOTAL'
      AND segment <> 'TOTAL'
    GROUP BY category, segment
) subquery
WHERE rn = 1
ORDER BY scor_total DESC;
/* deci cine cumpara cel mai mult pe fiecare categorie*/






/*5. Interogare 4-Grid*/
/*produse populare, dar slab evaluate*/

/*OPTIMIZAREinterogare*/
WITH medii AS (
    /* Calculăm mediile o singură dată */
    SELECT 
        AVG(scor_total) as avg_scor, 
        AVG(rating_mediu) as avg_rating 
    FROM fact_full_analysis
)
SELECT
    f.product_id,                  
    f.category,                    
    f.brand,                       
    f.scor_total,                  
    f.rating_mediu
FROM fact_full_analysis f
CROSS JOIN medii m
WHERE f.scor_total > m.avg_scor
  AND f.rating_mediu < m.avg_rating
ORDER BY f.scor_total DESC;





/*6. SubInterogare 4.1 -Grid*/
/*Adica: */
/*media pentru popularitate(interactiuni)=3,14. Deci mai mult decat aceasta valoare, ca fiind populare*/
SELECT
    AVG(scor_total) AS media_interactiuni
FROM fact_full_analysis;




/*7. SubInterogare 4.2 -Grid*/
/*media pentru evaluare(rating)=4,06. Deci sub aceasta valoare, ca fiind slab evaluate*/
SELECT
    AVG(rating_mediu) AS media_rating
FROM fact_full_analysis;




/*8. Interogare 5 - Grid*/
/* Ce brand domina pe fiecare tip de segment*/

SELECT 
    segment,
    brand,
    scor_total
FROM (
    SELECT
        segment,
        brand,
        SUM(scor_total) AS scor_total,
        /* Clasament pentru a găsi brandul nr. 1 în fiecare segment */
        ROW_NUMBER() OVER (
            PARTITION BY segment 
            ORDER BY SUM(scor_total) DESC
        ) AS rn
    FROM olap_full_segment_brand
    WHERE brand <> 'TOTAL'
      AND segment <> 'TOTAL'
    GROUP BY segment, brand
) subquery
WHERE rn = 1
ORDER BY scor_total DESC;





/*9. Interogare 6 - Grid*/
/*Produse cu crestere exponentiala a interesului (event_type insight)*/

WITH scoruri_per_produs AS (
    /* Calculăm scorul total pentru fiecare pereche produs-eveniment */
    SELECT
        product_id,
        category,
        event_type,
        SUM(scor_interactiuni) AS scor_total
    FROM vw_consolidare_full_analysis
    GROUP BY product_id, category, event_type
),
media_globala AS (
    /* Calculăm media scorurilor de mai sus o singură dată */
    SELECT AVG(scor_total) AS prag_interes
    FROM scoruri_per_produs
)
SELECT
    s.product_id,
    s.category,
    s.event_type,
    s.scor_total
FROM scoruri_per_produs s
CROSS JOIN media_globala m
WHERE s.scor_total > m.prag_interes
ORDER BY s.scor_total DESC;






/*10. SubInterogare 6 - Grid*/
/*media scorurilor la nivel de produs=7,10*/

SELECT
    AVG(total_scor) AS media_scor_produse
FROM (
    SELECT
        product_id,
        SUM(scor_interactiuni) AS total_scor
    FROM vw_consolidare_full_analysis
    GROUP BY product_id
) subquery_medie;

/*Interogarea identifică produsele care generează un nivel de interes peste medie,
comparând scorul total al interactiunilor cu media scorurilor la nivel de produs.*/





/*11. Interogare 7 - Grid*/
/*segmente care dau rating mare, dar interactioneaza putin*/

WITH statistici_globale AS (
    SELECT 
        AVG(rating_mediu) AS prag_rating,
        AVG(scor_total) AS prag_activitate
    FROM fact_full_analysis
)
SELECT
    f.segment,
    ROUND(AVG(f.rating_mediu), 2) AS rating_mediu,
    ROUND(AVG(f.scor_total), 2) AS activitate_medie
FROM fact_full_analysis f
CROSS JOIN statistici_globale g
GROUP BY f.segment, g.prag_rating, g.prag_activitate
HAVING AVG(f.rating_mediu) > g.prag_rating
   AND AVG(f.scor_total) < g.prag_activitate
ORDER BY rating_mediu DESC;
/*aici avem categoria de clienti pretentiosi*/






/*12. Interogare 8 - Grid*/
/*Categoria de produse populare si bine evaluate*/

WITH praguri_globale AS (
    SELECT 
        AVG(scor_total) AS avg_activitate, 
        AVG(rating_mediu) AS avg_rating 
    FROM fact_full_analysis
)
SELECT
    f.product_id,
    f.category,
    f.brand,
    f.scor_total,
    f.rating_mediu
FROM fact_full_analysis f
CROSS JOIN praguri_globale p
WHERE f.scor_total > p.avg_activitate
  AND f.rating_mediu > p.avg_rating
ORDER BY f.rating_mediu DESC, f.scor_total DESC;
/*aici avem produsele ideale*/






/*13. Interogare 9 - Grid*/
/*Impactul evenimentului asupra ratingului*/

SELECT
    event_type,
    COUNT(*) AS nr_interactiuni,
    ROUND(AVG(rating_mediu), 2) AS rating_mediu,
    /* Clasament bazat pe ratingul mediu per tip de eveniment */
    RANK() OVER (ORDER BY AVG(rating_mediu) DESC) AS ranking_rating
FROM vw_consolidare_full_analysis
GROUP BY event_type;
/*ce evenimente duc la un rating mai mare(purchase vs. view)*/






--/* REST Service URLs - Ingestie Date Brute - DOAR INFORMATIVE */

-- Ingestie din SQL (JPA Service)
-- URL: http://localhost:8091/DSA_SQL_JPAService/rest/ECOMMERCE/InteractionsView
-- URL: http://localhost:8091/DSA_SQL_JPAService/rest/ECOMMERCE/ProductsView

-- Ingestie din MongoDB (NoSQL Service)
-- URL: http://localhost:8093/DSA-NoSQL-MongoDBService/rest/ecommerce/UserProfileView

-- Ingestie din CSV (DOC-CSV Service)
-- URL: http://localhost:8097/DSA-DOC-CSVService/rest/ecommerce/ReviewsView




  --/* REST Service URLs - Livrare Rezultate Analize (Port 9990)
  --/* Acestea sunt punctele de acces pentru rezultatele procesate de Spark  -- DE ACCESAT IN BROWSER

-- 1. URL pentru Analiza Consolidată (Toate datele unite)
-- http://localhost:9990/DSA-SparkSQL-Service/rest/view/vw_consolidare_full_analysis

-- 2. URL pentru Matricea 4-Grid (Interacțiuni vs Rating)
-- http://localhost:9990/DSA-SparkSQL-Service/rest/view/fact_full_analysis

-- 3. URL pentru Cubul OLAP (Statistici pe Segment și Brand)
-- http://localhost:9990/DSA-SparkSQL-Service/rest/view/olap_full_segment_brand


