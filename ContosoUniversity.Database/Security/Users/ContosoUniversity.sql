CREATE USER [ContosoUniversity]
	FOR LOGIN [ContosoUniversity]
	WITH DEFAULT_SCHEMA = dbo

GO

GRANT CONNECT TO [ContosoUniversity]

GO

ALTER ROLE [db_webapp] ADD MEMBER [ContosoUniversity]

GO