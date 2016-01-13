CREATE TABLE [dbo].[CourseInstructor] (
    [CourseID]     INT NOT NULL,
    [InstructorID] INT NOT NULL,
    CONSTRAINT [PK_dbo.CourseInstructor] PRIMARY KEY CLUSTERED ([CourseID] ASC, [InstructorID] ASC),
    CONSTRAINT [FK_dbo.CourseInstructor_dbo.Course_CourseID] FOREIGN KEY ([CourseID]) REFERENCES [dbo].[Course] ([CourseID]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.CourseInstructor_dbo.Instructor_InstructorID] FOREIGN KEY ([InstructorID]) REFERENCES [dbo].[Person] ([ID]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_CourseID]
    ON [dbo].[CourseInstructor]([CourseID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_InstructorID]
    ON [dbo].[CourseInstructor]([InstructorID] ASC);

