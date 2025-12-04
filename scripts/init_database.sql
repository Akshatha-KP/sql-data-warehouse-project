--System database where other databases can be created

USE MASTER;
GO

---- Drop and recreate the 'DataWarehouse' database

IF EXISTS(Select 1 from sys.databases where name ='DataWarehouse')

--Force all users off immediately and allow only one connection
--**Warning - The below SQL statement can disrupt other users or services because it kills active sessions.
--So in production, you usually plan downtime or use it carefully

BEGIN
ALTER DATABASE DataWarehouse 
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;   
	DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE Datawarehouse ;
USE Datawarehouse;

CREATE SCHEMA bronze; 
GO -- batch seperator used by SQL Tools

CREATE SCHEMA silver;
GO -- batch seperator used by SQL Tools

CREATE SCHEMA gold;
GO -- batch seperator used by SQL Tools
