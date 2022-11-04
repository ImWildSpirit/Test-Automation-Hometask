import os

import pyodbc
import pandas as pd

import pytest
#from py.xml import html
from datetime import datetime

query_NullValues = """ select * from (
SELECT 'AddressID' as column_name, COUNT(DISTINCT CAST(AddressID AS NVARCHAR(MAX))) as cnt_unique_values       
FROM Person.Address 
UNION ALL 
SELECT 'AddressLine1' as column_name,COUNT(DISTINCT CAST(AddressLine1 AS NVARCHAR(MAX))) as cnt_unique_values       
FROM Person.Address 
UNION ALL 
SELECT 'AddressLine2' as column_name, COUNT(DISTINCT CAST(AddressLine2 AS NVARCHAR(MAX))) as cnt_unique_values       
FROM Person.Address 
UNION ALL SELECT 'City' as column_name,COUNT(DISTINCT CAST(City AS NVARCHAR(MAX))) as cnt_unique_values       
FROM Person.Address 
UNION ALL SELECT 'StateProvinceID' as column_name,COUNT(DISTINCT CAST(StateProvinceID AS NVARCHAR(MAX))) as cnt_unique_values       
FROM Person.Address 
UNION ALL 
SELECT 'PostalCode' as column_name,COUNT(DISTINCT CAST(PostalCode AS NVARCHAR(MAX))) as cnt_unique_values       
FROM Person.Address 
UNION ALL 
SELECT 'SpatialLocation' as column_name,COUNT(DISTINCT CAST(SpatialLocation AS NVARCHAR(MAX))) as cnt_unique_values       
FROM Person.Address 
UNION ALL 
SELECT 'rowguid' as column_name,COUNT(DISTINCT CAST(rowguid AS NVARCHAR(MAX))) as cnt_unique_values       
FROM Person.Address 
UNION ALL 
SELECT 'ModifiedDate' as column_name,COUNT(DISTINCT CAST(ModifiedDate AS NVARCHAR(MAX))) as cnt_unique_values      
FROM Person.Address
)tbl
WHERE cnt_unique_values = 0"""

query_PostalCode = """SELECT 
SUM( CASE WHEN ISNUMERIC(pa.PostalCode) = 1 AND psp.CountryRegionCode NOT IN ('CA', 'GB') THEN 0 
WHEN pa.PostalCode LIKE '%[A-Z]%' AND pa.PostalCode LIKE '%[0-9]%' AND psp.CountryRegionCode IN ('CA', 'GB') THEN 0 
WHEN (ISNUMERIC(pa.PostalCode) = 1 OR (CHARINDEX('-',pa.PostalCode) = 6 AND LEN(SUBSTRING(pa.PostalCode,CHARINDEX('-',pa.PostalCode)+1,LEN(pa.PostalCode))) = 4)) 
AND psp.[Name] = 'Oregon' THEN 0
ELSE 1
END
) as postal_codes_validity
FROM [Person].[Address] pa JOIN [Person].[StateProvince] psp
on pa.StateProvinceID = psp.StateProvinceID"""

query_Status = """select 
CASE WHEN MAX([Status]) = 3 AND MIN([Status]) = 1 THEN 1 ELSE 0 END as Status_min_max
FROM [Production].[Document]"""

query_FolderFlag = """SELECT COUNT(*) FROM
(SELECT DocumentNode, CAST(FolderFlag as INT) as FolderFlag FROM [Production].[Document]
EXCEPT
SELECT DocumentNode, CAST(CASE WHEN PATINDEX('%.%',[FileName]) = 0 THEN 1 ELSE 0 END as INT) as FolderFlag 
FROM [Production].[Document])tbl"""

query_UnitMeasureCode = """SELECT COUNT(*) as cnt FROM [Production].[UnitMeasure]
WHERE UPPER([UnitMeasureCode]) COLLATE Latin1_General_CS_AS != [UnitMeasureCode]"""

query_Name = """SELECT COUNT(*) as result FROM
(SELECT [Name], COUNT(*) OVER (PARTITION BY UnitMeasureCode) cnt
FROM [Production].[UnitMeasure]
GROUP BY UnitMeasureCode, [Name]
)tbl
WHERE cnt <> 1"""

server = '127.0.0.1'
database = 'AdventureWorks2014'
username = 'testuser'
password = 'Qwerty124'


def dq_checker(query):
    cnxn = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password)
    cursor = cnxn.cursor()
    df = pd.read_sql(query, cnxn)
    if df.empty:
        return True
    else:
        return df.head()


def test_AddressNulls():
    assert dq_checker(query_NullValues) == True, \
        'Address table columns do not appear to be populated fully NULL values'


def test_PostalCode():
    assert dq_checker(query_PostalCode).values == [[0]], \
        'Postal Code column in Address table has correct values'


def test_Status():
    assert dq_checker(query_Status).values == [[1]], \
        ' Status column MAX and MIN values correspond to required'


def test_FolderFlag():
    assert dq_checker(query_FolderFlag).values == [[0]], \
        'FolderFlag column assigned correctly'


def test_UnitMeasureCode():
    assert dq_checker(query_UnitMeasureCode).values == [[0]], \
        'UnitMeasureCode values contain only upper case characters'


def test_UnitMeasureName():
    assert dq_checker(query_Name).values == [[0]], \
        'Name column does not contain duplicates'

