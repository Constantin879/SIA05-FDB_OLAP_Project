
#####/*SQL Developer Web - REST*/#####
######################################


###/* REST Web Services (JSON)*/###


/*1. View_Resursa_REST_1: olap_full_segment_category_event*/

BEGIN
    ORDS.ENABLE_OBJECT(
        P_ENABLED      => TRUE,
        P_SCHEMA      => 'ECOMMERCE',
        P_OBJECT      =>  'OLAP_FULL_SEGMENT_CATEGORY_EVENT',
        P_OBJECT_TYPE      => 'VIEW',
        P_OBJECT_ALIAS      => 'olap_full_segment_category_event',
        P_AUTO_REST_AUTH      => TRUE
    );
    
END;


URL: http://localhost:8080/ords/ecommerce/olap_full_segment_category_event/ 




/*2. View_Resursa_REST_2: olap_full_category_brand_rollup*/

BEGIN
    ORDS.ENABLE_OBJECT(
        P_ENABLED      => TRUE,
        P_SCHEMA      => 'ECOMMERCE',
        P_OBJECT      =>  'OLAP_FULL_CATEGORY_BRAND_ROLLUP',
        P_OBJECT_TYPE      => 'VIEW',
        P_OBJECT_ALIAS      => 'olap_full_category_brand_rollup',
        P_AUTO_REST_AUTH      => TRUE
    );
END;

URL: http://localhost:8080/ords/ecommerce/olap_full_category_brand_rollup/



/*3. View_Resursa_REST_3: olap_product_reviews_rollup */

BEGIN
    ORDS.ENABLE_OBJECT(
        P_ENABLED      => TRUE,
        P_SCHEMA      => 'ECOMMERCE',
        P_OBJECT      =>  'OLAP_PRODUCT_REVIEWS_ROLLUP',
        P_OBJECT_TYPE      => 'VIEW',
        P_OBJECT_ALIAS      => 'olap_product_reviews_rollup',
        P_AUTO_REST_AUTH      => TRUE
    );
    
END;


URL: http://localhost:8080/ords/ecommerce/olap_product_reviews_rollup/ 






/*4. View_Resursa_REST_4: vw_consolidare_full_analysis*/

BEGIN
    ORDS.ENABLE_OBJECT(
        P_ENABLED      => TRUE,
        P_SCHEMA      => 'ECOMMERCE',
        P_OBJECT      =>  'VW_CONSOLIDARE_FULL_ANALYSIS',
        P_OBJECT_TYPE      => 'VIEW',
        P_OBJECT_ALIAS      => 'vw_consolidare_full_analysis',
        P_AUTO_REST_AUTH      => TRUE
    );
END;


URL: http://localhost:8080/ords/ecommerce/vw_consolidare_full_analysis/ 





####/*Dashboard & Charts*/###



/*1. Dashboard ECOMMERCE*/

--  DEFINE MODULE
BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name => 'com.oracle.dbtools.dashboard.ECOMMERCE',
        p_base_path => '/sdw/dashboards/ECOMMERCE/',
        p_items_per_page=> 0,
        p_status => 'PUBLISHED',
        p_comments=> 'ECOMMERCE'
    );
    
END;


URL: http://localhost:8080/ords/ecommerce/_sdw/dashboards/?name=ECOMMERCE




/*2. Chart vw_consolidare_product_reviews*/

--  DEFINE MODULE
BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name => 'com.oracle.dbtools.chart.vw_consolidare_product_reviews',
        p_base_path => '/sdw/charts/vw_consolidare_product_reviews/',
        p_items_per_page=> 0,
        p_status => 'PUBLISHED',
        p_comments=> 'vw_consolidare_product_reviews'
    );
    
END;


URL: http://localhost:8080/ords/ecommerce/_sdw/charts/?name=vw_consolidare_product_reviews




/*3. Chart olap_full_segment_brand*/

--  DEFINE MODULE
BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name => 'com.oracle.dbtools.chart. olap_full_segment_brand',
        p_base_path => '/sdw/charts/ olap_full_segment_brand /',
        p_items_per_page=> 0,
        p_status => 'PUBLISHED',
        p_comments=> 'olap_full_segment_brand'
    );
    
END;


URL: http://localhost:8080/ords/ecommerce/_sdw/charts/?name=%20olap_full_segment_brand%20




/*4. Chart vw_consolidare_full_analysis*/

--  DEFINE MODULE
BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name => 'com.oracle.dbtools.chart.vw_consolidare_full_analysis',
        p_base_path => '/sdw/charts/vw_consolidare_full_analysis/',
        p_items_per_page=> 0,
        p_status => 'PUBLISHED',
        p_comments=> 'vw_consolidare_full_analysis'
    );
    
END;


URL: http://localhost:8080/ords/ecommerce/_sdw/charts/?name=vw_consolidare_full_analysis