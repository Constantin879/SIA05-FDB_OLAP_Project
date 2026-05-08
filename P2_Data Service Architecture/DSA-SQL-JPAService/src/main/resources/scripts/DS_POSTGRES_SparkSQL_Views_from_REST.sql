----------------------------------------------------------------------------------
--- DS2_ORACLE_SparkSQL_Views.sql
----------------------------------------------------------------------------------



-- PENTRU_tab_interactions_din_Postgres --
---------------------------------------------------------------------------------
SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8091/DSA_SQL_JPAService/rest/ECOMMERCE/InteractionsView');
----------------------------------------------------------------------------------
-- 1. CREATE JSON View
SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'INTERACTIONS_JSON_VIEW',
               'http://localhost:8091/DSA_SQL_JPAService/rest/ECOMMERCE/InteractionsView');

SELECT * FROM INTERACTIONS_JSON_VIEW;

-- 2. Create SQL View
-- DROP VIEW INTERACTIONS_VIEW;
CREATE OR REPLACE VIEW INTERACTIONS_VIEW AS
select v.*
FROM INTERACTIONS_JSON_VIEW as json_view LATERAL VIEW explode(json_view.array) AS v;
-- 3. Test Remote View
select * FROM INTERACTIONS_VIEW;




-- PENTRU_tab_products_din_Postgres --
---------------------------------------------------------------------------------
SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8091/DSA_SQL_JPAService/rest/ECOMMERCE/ProductsView');
----------------------------------------------------------------------------------
-- 1. CREATE JSON View
SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'PRODUCTS_JSON_VIEW',
               'http://localhost:8091/DSA_SQL_JPAService/rest/ECOMMERCE/ProductsView');

SELECT * FROM PRODUCTS_JSON_VIEW;

-- 2. Create SQL View
-- DROP VIEW PRODUCTS_VIEW;
CREATE OR REPLACE VIEW PRODUCTS_VIEW AS
select v.*
FROM PRODUCTS_JSON_VIEW as json_view LATERAL VIEW explode(json_view.array) AS v;
-- 3. Test Remote View
select * FROM PRODUCTS_VIEW;