CREATE TABLE [dbo].[Course] (
    [CourseID]     INT           NOT NULL,
    [Title]        NVARCHAR (60) NULL,
    [Credits]      INT           NOT NULL,
    [DepartmentID] INT           DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_dbo.Course] PRIMARY KEY CLUSTERED ([CourseID] ASC),
    CONSTRAINT [FK_dbo.Course_dbo.Department_DepartmentID] FOREIGN KEY ([DepartmentID]) REFERENCES [dbo].[Department] ([DepartmentID]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_DepartmentID]
    ON [dbo].[Course]([DepartmentID] ASC);

