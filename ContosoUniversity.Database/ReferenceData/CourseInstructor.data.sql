IF NOT EXISTS (SELECT TOP 1 * FROM dbo.CourseInstructor)

BEGIN
INSERT INTO [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (2021, 9)
INSERT INTO [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (2042, 9)
INSERT INTO [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (1045, 10)
INSERT INTO [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (1050, 11)
INSERT INTO [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (3141, 11)
INSERT INTO [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (1050, 12)
INSERT INTO [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (4022, 13)
INSERT INTO [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (4041, 13)
END