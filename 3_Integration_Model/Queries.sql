/* INTEROGARI(fara view-uri) */


/*INTEROGARE 1*/
/*Care sunt produsele cu rating ridicat >=4 (din CSV), ce tip de interactiuni(event) au utilizatorii cu ele (din PostgreSQL) 
si cine sunt acesti utilizatori (din MongoDB)? */



SELECT 
    p."product_name",
    p."category",
    u.user_name,
    u.email,
    r.rating,
    i."event_type",
    i."event_value"
FROM "products"@PG p
JOIN "interactions"@PG i 
    ON p."product_id" = i."product_id"
JOIN reviews_ext r 
    ON r.product_id = p."product_id"
JOIN userss_view_mongodb u 
    ON u.user_id = i."user_id"
WHERE r.rating >= 4
  AND p."price" > 100;

/*Rezultatul arată corelatia dintre evaluarea produselor si comportamentul utilizatorilor.*/




/*INTEROGARE 2*/
/*Care sunt produsele cele mai populare în functie de numărul de utilizatori, rating mediu si intensitatea interactiunilor?*/

SELECT 
    p."product_name",
    COUNT(DISTINCT i."user_id") AS nr_utilizatori,
    AVG(r.rating) AS rating_mediu,
    SUM(i."event_value") AS total_interactiuni
FROM "products"@PG p
JOIN "interactions"@PG i 
    ON p."product_id" = i."product_id"
JOIN reviews_ext r 
    ON r.product_id = p."product_id"
JOIN userss_view_mongodb u 
    ON u.user_id = i."user_id"
GROUP BY p."product_name"
ORDER BY total_interactiuni DESC;



/*INTEROGARE 3*/
/*Care utilizatori sunt cei mai activi si ce comportament au asupra produselor bine evaluate?*/

SELECT 
    u.user_name,
    COUNT(i."interaction_id") AS nr_interactiuni,
    SUM(i."event_value") AS scor_activitate,
    AVG(r.rating) AS rating_mediu_produse
FROM userss_view_mongodb u
JOIN "interactions"@PG i 
    ON u.user_id = i."user_id"
JOIN "products"@PG p 
    ON p."product_id" = i."product_id"
JOIN reviews_ext r 
    ON r.product_id = p."product_id"
GROUP BY u.user_name
ORDER BY scor_activitate DESC;

/*INTEROGARE 4*/
/*Cum diferă comportamentul utilizatorilor în functie de tipul lor (New, Regular, Premium)?*/

WITH user_type AS (
    SELECT 
        user_id,
        city,
        MAX(CASE 
            WHEN segment IN ('New','Regular','Premium') 
            THEN segment 
        END) AS tip_user
    FROM users_full_mongodb
    GROUP BY user_id, city
)
SELECT 
    u.tip_user,
    u.city,
    COUNT(DISTINCT u.user_id) AS nr_useri,
    COUNT(i."interaction_id") AS nr_interactiuni,
    SUM(i."event_value") AS scor_activitate,
    AVG(r.rating) AS rating_mediu
FROM user_type u
JOIN "interactions"@PG i 
    ON u.user_id = i."user_id"
JOIN "products"@PG p 
    ON p."product_id" = i."product_id"
JOIN reviews_ext r 
    ON r.product_id = p."product_id"
WHERE u.tip_user IS NOT NULL
GROUP BY u.tip_user, u.city
ORDER BY scor_activitate DESC;


/*Analiza arată că utilizatorii Regular sunt cei mai activi si contribuie cel mai mult la interactiuni. 
Utilizatorii noi au un comportament variabil, fiind uneori foarte activi, iar alteori mai putin implicati. 
Utilizatorii Premium sunt mai selectivi si preferă produse bine evaluate. De asemenea, există diferente de activitate între orase. */



/*INTEROGARE 5*/
/*CUBE */

/* Care este numărul total de interactiuni pentru produse, 
analizat pe categorii, branduri si tipuri de evenimente, 
incluzând si totaluri agregate pe fiecare nivel (categorie, brand, tip eveniment si total general)*/


SELECT 
    NVL(p."category", 'TOTAL') AS category,
    NVL(p."brand", 'TOTAL') AS brand,
    NVL(i."event_type", 'TOTAL') AS event_type,
    COUNT(*) AS total_interactiuni
FROM "products"@PG p
JOIN "interactions"@PG i
    ON p."product_id" = i."product_id"
GROUP BY CUBE (
    p."category",
    p."brand",
    i."event_type"
)
ORDER BY 
    category,
    brand,
    CASE 
        WHEN event_type = 'view' THEN 1
        WHEN event_type = 'add_to_cart' THEN 2
        WHEN event_type = 'purchase' THEN 3
        WHEN event_type = 'TOTAL' THEN 4
    END;





/*INTEROGARE 6*/
/*ROLLUP*/

/* Care este numărul total de interactiuni pentru produse, 
agregat pe categorii si branduri, incluzând subtotaluri pe categorie si totalul general?  */

SELECT 
    NVL(p."category", 'TOTAL') AS category,
    NVL(p."brand", 'TOTAL') AS brand,
    COUNT(*) AS total_interactiuni
FROM "interactions"@PG i
JOIN "products"@PG p 
    ON i."product_id" = p."product_id"
GROUP BY ROLLUP (p."category", p."brand")
ORDER BY category, brand;

