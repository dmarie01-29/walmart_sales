{{ config({ "materialized":'table',
 "transient":true,
 "alias":'walmart_date_dim',
 "pre_hook": macros_copy_csv('DEPARTMENT'),
 "schema": 'SILVER'
})}}

WITH transform AS(
SELECT
(
    ROW_NUMBER() OVER (
        PARTITION BY DEPT, STORE_DATE 
        ORDER BY DATE ASC AS DATE_ID
    , STORE_DATE AS STORE_DATE
    , IS_HOLIDAY AS IS_HOLIDAY
    ,INSERT_DTS AS INSERT_DTS
    ,UPDATE_DTS AS UPDATE_DTS
    ,SOURCE_FILE_NAME AS SOURCE_FILE_NAME
    ,SOURCE_FILE_ROW_NUMBER AS SOURCE_FILE_ROW_NUMBER
FROM {{source('source','DEPARTMENT')}}
)

SELECT *
FROM transform