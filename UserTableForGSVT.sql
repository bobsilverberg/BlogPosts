
CREATE TABLE dbo.tblUser (
	[UserId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[UserName] [varchar](100) NOT NULL,
	[UserPass] [varchar](50) NOT NULL,
	[Nickname] [varchar](50) NOT NULL,
	[Salary] [decimal](9,2) NOT NULL
)

GO