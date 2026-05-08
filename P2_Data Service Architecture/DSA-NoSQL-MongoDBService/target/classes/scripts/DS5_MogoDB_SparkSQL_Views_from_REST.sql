----------------------------------------------------------------------------------
--- DS5_MogoDB_SparkSQL_Views.sql
----------------------------------------------------------------------------------

--pentru userss din MongoDB (ECOMMERCE)
----------------------------------------------------------------------------------

SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8093/DSA-NoSQL-MongoDBService/rest/ecommerce/UserProfileView');

-- 1. Create JSON View
SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'USERSPROFILE_JSON_VIEW',
               'http://localhost:8093/DSA-NoSQL-MongoDBService/rest/ecommerce/UserProfileView');

SELECT * FROM USERSPROFILE_JSON_VIEW;
-- 2. Create Remote View
-- DROP VIEW departaments_view;
CREATE OR REPLACE VIEW USERSPROFILE_VIEW AS
select v.profile.*, explode(v.segments) as segment
FROM USERSPROFILE_JSON_VIEW as json_view LATERAL VIEW explode(json_view.array) AS v;

select * from USERSPROFILE_VIEW;

select distinct age, city  from USERSPROFILE_VIEW;