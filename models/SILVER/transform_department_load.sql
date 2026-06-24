{{ config({ "materialized":'table',
 "transient":true,
 "alias":'walmart_date_dim',
 "pre_hook": macros_copy_csv('DEPARTMENT'),
 "schema": 'SILVER'
})}}

WITH transform_dept AS(
SELECT
    STORE AS STORE
    , DEPT AS DEPT
    , DATE	AS DATE
    , WEEKLY_SALES AS WEEKLY_SALES
    , ISHOLIDAY AS ISHOLIDAY
    , INSERT_DTS AS INSERT_DTS
    , UPDATE_DTS AS UPDATE_DTS
    , SOURCE_FILE_NAME AS SOURCE_FILE_NAME
    , SOURCE_FILE_ROW_NUMBER AS SOURCE_FILE_ROW_NUMBER
FROM {{source('source1','DEPARTMENT')}}
)

SELECT *
FROM transform_dept

    -- ROW_NUMBER() OVER (
    --     PARTITION BY DEPT, STORE_DATE 
    --     ORDER BY STORE_DATE ASC ) 
    --     AS DATE_ID

