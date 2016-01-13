CREATE TABLE [dbo].[OfficeAssignment] (
    [InstructorID] INT           NOT NULL,
    [Location]     NVARCHAR (50) NULL,
    CONSTRAINT [PK_dbo.OfficeAssignment] PRIMARY KEY CLUSTERED ([InstructorID] ASC),
    CONSTRAINT [FK_dbo.OfficeAssignment_dbo.Instructor_InstructorID] FOREIGN KEY ([InstructorID]) REFERENCES [dbo].[Person] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IX_InstructorID]
    ON [dbo].[OfficeAssignment]([InstructorID] ASC);

