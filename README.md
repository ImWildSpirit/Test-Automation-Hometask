# Test Automation Hometask

This is a project for testing AdventureWorks tables using PyTest and Robot frameworks

**Table of contents**

-  General info
-  Technologies
-  Setup

**General info**
This project for running PyTest and Robot frameworks and perform basic testing of data from "AdventureWorks2014" database via SQL statements.

```
Task:

1. Create 2 DIFFERENT test cases for data checks on "AdventureWorks2014" database (3 different tables) 
and document them (name, steps, expected results).

Tables to use: 
* [Person].[Address]
* [Production].[Document]
* [Production].[UnitMeasure]

As a result you should have 6 diferent test cases for 3 different tables (2 per table).

2. Create a project for running Pytest tests.
3. Automate test cases from step 1 so that they can connect to MS SQL DB from SQL Module on your localhost.
4. Store a test report.
```


**Technologies**

Project is created with: Python 3.9.8

```
import pyodbc
import pandas
install pytest
```

# PyTest Framework

**Setup**

To run this project install 'pytest'.

Run the following command in your command line:
`pip install -U pytest`

To generate report execute following command in command line:
`pip install pytest-html`

Execute script.
Run the following command in your command line:
`pytest -v database_tests.py --html=C:\Git\PyTest\Results\report.html`

Once tests executed review report in C:\Git\PyTest\Results\ folder

# Robot Framework

**Setup**

To create and run test cases use Ride.py

## How to install Ride from scratch to work with Robot Framework please review following video:
https://www.youtube.com/watch?v=8h5knh2jLCA&ab_channel=AutomationStepbyStep

Note: RIDE might not work with python3, so please use following command to install proper 
Ride version: pip install -U https://github.com/robotframework/RIDE/archive/master.zip 

## To launch Ride please open command promt and use following command: Ride.py

## Required additional installation modules and libraries
DatabaseLibrary: pip install -U robotframework-databaselibrary
pymssql module: pip install pymssql

## Useful links for syntax of Database Library
https://github.com/franz-see/Robotframework-Database-Library/blob/master/test/MSSQL_DB_Tests.robot
https://franz-see.github.io/Robotframework-Database-Library/api/0.6/DatabaseLibrary.html

## Connection settings is saved in Resources/DB_connection.robot
Please use following file and change variables values to proper

## Report is saved after TC run in default folder and can be copied to another directory. Currently it is located in Results folder, alongside with log files.
