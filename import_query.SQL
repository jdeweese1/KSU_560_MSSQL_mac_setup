RESTORE DATABASE [WWI] FROM DISK = N'/var/opt/mssql/data/wwi.bak'
WITH MOVE 'WWI_Primary'  TO N'/var/opt/mssql/data/WWI.mdf', 
MOVE 'WWI_UserData' TO N'/var/opt/mssql/data/WWI_UserData.ndf',
MOVE 'WWI_Log' TO N'/var/opt/mssql/data/WWI.ldf',
MOVE 'wwi_inmemory_data_1' to N'/var/opt/mssql/data/WWI_InMemory.ndf'
