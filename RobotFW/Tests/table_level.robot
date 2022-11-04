*** Settings ***
Documentation     SQL Table Level Tests
Default Tags      AdventureWorks2014
Library           OperatingSystem
Library           String
Library           Dialogs
Library           DatabaseLibrary
Resource          ../Resources/DB_connection.robot

*** Test Cases ***
Count unique values for every column in the table. Query validates if any column populated fully null values
    [Documentation]    Setup:
    ...    Trigger Step function with [Person].[Address] table and await run finish.
    ...
    ...    Test Steps:
    ...    Run query and validate query execution result with listed in Expected result column
    ...
    ...    Expected result:
    ...    0. AdventureWorks2014 DB with [Person].[Address] table is present.
    ...    1. Step function finished successfully.
    ...    2. Pass result = 0, fail <> 0
    [Tags]    Person.Address
    [Template]
    Connect
    Execute SQL String    DECLARE @query NVARCHAR(MAX)\nselect @query = STRING_AGG(\n CAST(\n \ \ \ \ \ \ \ \ \ 'SELECT '\n \ \ \ \ \ \ \ \ \ + '''' + COLUMN_NAME + '''' + 'as column_name,' +\n+ 'COUNT(DISTINCT CAST(' + COLUMN_NAME + ' AS NVARCHAR(MAX))) as cnt_unique_values\nFROM ' + TABLE_SCHEMA + '.' + TABLE_NAME\nAS NVARCHAR(MAX)), ' UNION ALL ')\nfrom INFORMATION_SCHEMA.COLUMNS\nwhere TABLE_CATALOG='AdventureWorks2014' AND TABLE_SCHEMA = 'Person' AND TABLE_NAME = 'Address'\ndeclare @result table (column_name nvarchar(max), cnt int)\ninsert into @result\nEXEC SP_EXECUTESQL @query\nselect count(cnt) from @result where cnt = 0 \ \ \ \ \ \ \ \n    0
    Disconnect from Database

Query validates if PostalCode column contains invalid postal codes
    [Documentation]    Setup:
    ...    Trigger Step function with [Person].[Address] table and await run finish.
    ...
    ...    Test Steps:
    ...    Run query and validate query execution result with listed in Expected result column
    ...
    ...    Expected result:
    ...    0. AdventureWorks2014 DB with [Person].[Address] table is present.
    ...    1. Step function finished successfully.
    ...    2. Pass result = 0, fail <> 0
    [Tags]    Person.Address
    Connect
    Execute Sql String    SELECT SUM( CASE WHEN ISNUMERIC(pa.PostalCode) = 1 AND psp.CountryRegionCode NOT IN ('CA', 'GB') THEN 0 --for all postal codes exept Canada and GB\nWHEN pa.PostalCode LIKE '%[A-Z]%' AND pa.PostalCode LIKE '%[0-9]%' AND psp.CountryRegionCode IN ('CA', 'GB') THEN 0 --For Canada and GB\nWHEN (ISNUMERIC(pa.PostalCode) = 1 OR (CHARINDEX('-',pa.PostalCode) = 6 AND LEN(SUBSTRING(pa.PostalCode,CHARINDEX('-',pa.PostalCode)+1,LEN(pa.PostalCode))) = 4)) \nAND psp.[Name] = 'Oregon' THEN 0 --for US / Oregon\nELSE 1 END) as postal_codes_validity\nFROM [Person].[Address] pa JOIN [Person].[StateProvince] psp\non pa.StateProvinceID = psp.StateProvinceID    0
    Disconnect from Database

Query validates if Status column MAX and MIN value corresponds to required
    [Documentation]    Setup:
    ...    Trigger Step function with [Production].[Document] table and await run finish.
    ...
    ...    Test Steps:
    ...    Run query and validate query execution result with listed in Expected result column
    ...
    ...    Expected result:
    ...    0. AdventureWorks2014 DB with [Production].[Document] table is present.
    ...    1. Step function finished successfully.
    ...    2. Pass result = 0, fail <> 0
    [Tags]    [Production].[Document]
    [Template]
    Connect
    Execute SQL String    select \nCASE WHEN MAX([Status]) = 3 AND MIN([Status]) = 1 THEN 1 ELSE 0 END as Status_min_max\nFROM [Production].[Document]    0
    Disconnect from Database

Query validates if FolderFlag column assigned correctly
    [Documentation]    Setup:
    ...    Trigger Step function with [Production].[Document] table and await run finish.
    ...
    ...    Test Steps:
    ...    Run query and validate query execution result with listed in Expected result column
    ...
    ...    Expected result:
    ...    0. AdventureWorks2014 DB with [Production].[Document] table is present.
    ...    1. Step function finished successfully.
    ...    2. Pass result = 0, fail <> 0
    [Tags]    [Production].[Document]
    [Template]
    Connect
    Execute SQL String    SELECT COUNT(*) FROM\n(SELECT DocumentNode, CAST(FolderFlag as INT) as FolderFlag FROM [Production].[Document]\nEXCEPT\nSELECT DocumentNode, CAST(CASE WHEN PATINDEX('%.%',[FileName]) = 0 THEN 1 ELSE 0 END as INT) as FolderFlag \nFROM [Production].[Document])tbl    0
    Disconnect from Database

Query validates if UnitMeasureCode column values contain only upper case characters
    [Documentation]    Setup:
    ...    Trigger Step function with [Production].[UnitMeasure] table and await run finish.
    ...
    ...    Test Steps:
    ...    Run query and validate query execution result with listed in Expected result column
    ...
    ...    Expected result:
    ...    0. AdventureWorks2014 DB with [Production].[UnitMeasure] table is present.
    ...    1. Step function finished successfully.
    ...    2. Pass result = 0, fail <> 0
    [Tags]    [Production].[UnitMeasure]
    [Template]
    Connect
    Execute SQL String    SELECT COUNT(*) as cnt FROM [Production].[UnitMeasure]\nWHERE UPPER([UnitMeasureCode]) COLLATE Latin1_General_CS_AS != [UnitMeasureCode]    0
    Disconnect from Database

Query validates if Name column mapped accordingly to UnitMeasureCode and does not contain duplicates
    [Documentation]    Setup:
    ...    Trigger Step function with [Production].[UnitMeasure] table and await run finish.
    ...
    ...    Test Steps:
    ...    Run query and validate query execution result with listed in Expected result column
    ...
    ...    Expected result:
    ...    0. AdventureWorks2014 DB with [Production].[UnitMeasure] table is present.
    ...    1. Step function finished successfully.
    ...    2. Pass result = 0, fail <> 0
    [Tags]    [Production].[UnitMeasure]
    [Template]
    Connect
    Execute SQL String    SELECT COUNT(*) as result FROM\n(SELECT [Name], COUNT(*) OVER (PARTITION BY UnitMeasureCode) cnt\nFROM [Production].[UnitMeasure]\nGROUP BY UnitMeasureCode, [Name]\n)tbl\nWHERE cnt <> 1    0
    Disconnect from Database
