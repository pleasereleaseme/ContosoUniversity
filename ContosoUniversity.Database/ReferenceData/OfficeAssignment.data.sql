IF NOT EXISTS (SELECT TOP 1 * FROM dbo.OfficeAssignment)

BEGIN
INSERT INTO [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (10, N'Smith 17')
INSERT INTO [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (11, N'Gowan 27')
INSERT INTO [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (12, N'Thompson 304')
END