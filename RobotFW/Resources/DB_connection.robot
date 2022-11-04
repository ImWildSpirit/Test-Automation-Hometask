*** Settings ***
Library           OperatingSystem
Library           String
Library           Dialogs
Library           DatabaseLibrary

*** Variables ***
${DB_NAME}        AdventureWorks2014
${DB_USER_NAME}    testuser
${DB_USER_PASSWORD}    Qwerty124
${DB_HOST}        127.0.0.1
${DB_PORT}        1433

*** Keywords ***
Connect
    [Tags]    AdventureWorks2014
    Connect to Database    pymssql    ${DB_NAME}    ${DB_USER_NAME}    ${DB_USER_PASSWORD}    ${DB_HOST}    ${DB_PORT}

Disconnect
    [Tags]    AdventureWorks2014
    Disconnect from Database
