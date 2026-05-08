----------------------------------------------------------------------------------
--- DSA_CSV_SparkSQL_Views.sql
----------------------------------------------------------------------------------

--pentru Reviews CSV din C: local
----------------------------------------------------------------------------------
SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8097/DSA-DOC-CSVService/rest/ecommerce/ReviewsView');

----------------------------------------------------------------------------------
-- 1. Create JSON View
SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'REVIEWS_CSV_JSON_VIEW',
               'http://localhost:8097/DSA-DOC-CSVService/rest/ecommerce/ReviewsView');

SELECT * FROM REVIEWS_CSV_JSON_VIEW;
-- 2. Create Remote View
-- DROP VIEW REVIEWS_CSV_JSON_VIEW;
CREATE OR REPLACE VIEW REVIEWS_CSV_VIEW AS
select v.*
FROM REVIEWS_CSV_JSON_VIEW as json_view LATERAL VIEW explode(json_view.array) AS v;
-- 3. Test Remote View
select * FROM REVIEWS_CSV_VIEW;