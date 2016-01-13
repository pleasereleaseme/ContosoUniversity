/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
:r ".\ReferenceData\Person.data.sql"
GO
:r ".\ReferenceData\Department.data.sql"
GO
:r ".\ReferenceData\Course.data.sql"
GO
:r ".\ReferenceData\CourseInstructor.data.sql"
GO
:r ".\ReferenceData\Enrollment.data.sql"
GO
:r ".\ReferenceData\OfficeAssignment.data.sql"
GO