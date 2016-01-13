IF NOT EXISTS (SELECT TOP 1 * FROM dbo.Department)

BEGIN
SET IDENTITY_INSERT [dbo].[Department] ON
INSERT INTO [dbo].[Department] ([DepartmentID], [Name], [Budget], [StartDate], [InstructorID]) VALUES (1, N'Temp1', CAST(0.0000 AS Money), N'2014-12-23 00:00:00', 9)
INSERT INTO [dbo].[Department] ([DepartmentID], [Name], [Budget], [StartDate], [InstructorID]) VALUES (2, N'English', CAST(350000.0000 AS Money), N'2007-09-01 00:00:00', 9)
INSERT INTO [dbo].[Department] ([DepartmentID], [Name], [Budget], [StartDate], [InstructorID]) VALUES (3, N'Mathematics', CAST(100000.0000 AS Money), N'2007-09-01 00:00:00', 10)
INSERT INTO [dbo].[Department] ([DepartmentID], [Name], [Budget], [StartDate], [InstructorID]) VALUES (4, N'Engineering', CAST(350000.0000 AS Money), N'2007-09-01 00:00:00', 11)
INSERT INTO [dbo].[Department] ([DepartmentID], [Name], [Budget], [StartDate], [InstructorID]) VALUES (5, N'Economics', CAST(100000.0000 AS Money), N'2007-09-01 00:00:00', 12)
SET IDENTITY_INSERT [dbo].[Department] OFF
END