import pyodbc

server = '127.0.0.1'
database = 'AdventureWorks2014'
username = 'testuser'
password = 'Qwerty124'

cnxn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password)
cursor = cnxn.cursor()
