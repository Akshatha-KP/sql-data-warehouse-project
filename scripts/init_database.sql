
/*
========================================================================
Create Database and Schemas
========================================================================

This SQL script resets and prepares a clean environment for the DataWarehouse database. 
It starts by switching to the system master database and checking whether an existing version of DataWarehouse is present. 
If it exists, the script forces all active connections to close, removes the database safely, and recreates a fresh instance. 
This ensures a clean starting point without leftover objects or conflicting structures from previous versions.

After the new database is created, the script switches context to it and sets up the foundational bronze, silver, and gold schemas. 
These schemas represent progressive layers of data processing - raw data, cleaned data, and analytics-ready curated data. 
GO batch separators are used throughout to break the script into logical execution blocks so that SQL Server tools process each step correctly and without conflict.

***Warning: This script uses SINGLE_USER WITH ROLLBACK IMMEDIATE, which immediately terminates active user sessions and rolls back their transactions. 
Running it in a production or shared environment can disrupt other users or dependent applications.
Always plan downtime or coordinate with stakeholders before executing this script on a live system.
*/


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
