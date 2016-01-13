CREATE TABLE [dbo].[Enrollment] (
    [EnrollmentID] INT IDENTITY (1, 1) NOT NULL,
    [CourseID]     INT NOT NULL,
    [StudentID]    INT NOT NULL,
    [Grade]        INT NULL,
    CONSTRAINT [PK_dbo.Enrollment] PRIMARY KEY CLUSTERED ([EnrollmentID] ASC),
    CONSTRAINT [FK_dbo.Enrollment_dbo.Course_CourseID] FOREIGN KEY ([CourseID]) REFERENCES [dbo].[Course] ([CourseID]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.Enrollment_dbo.Person_StudentID] FOREIGN KEY ([StudentID]) REFERENCES [dbo].[Person] ([ID]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_CourseID]
    ON [dbo].[Enrollment]([CourseID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StudentID]
    ON [dbo].[Enrollment]([StudentID] ASC);

