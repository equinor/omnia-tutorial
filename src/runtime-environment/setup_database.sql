/* Script for creating a table and view to hold processed production data */

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Create the table - we expect all rows to contain valid data */
CREATE TABLE [dbo].[ProductionData](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[Wellbore] [varchar](50) NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Oil] [decimal](5, 5) NOT NULL,
	[Gas] [decimal](5, 5) NOT NULL
) ON [PRIMARY]
GO

/* Default values for oil and gas */
ALTER TABLE [dbo].[ProductionData] ADD  CONSTRAINT [DF_Production_Oil]  DEFAULT ((0)) FOR [Oil]
GO
ALTER TABLE [dbo].[ProductionData] ADD  CONSTRAINT [DF_Production_Gas]  DEFAULT ((0)) FOR [Gas]
GO

/* Create a view to abstract away from internal details - here we just expose all fields */
CREATE VIEW [dbo].[Production]
AS
SELECT        dbo.ProductionData.*
FROM            dbo.ProductionData
GO

