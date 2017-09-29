USE [jeefwtwo]
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[GetDaiLiData]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetDaiLiData]
GO

CREATE  function [dbo].[GetDaiLiData](@dwSpreaderID int)
 returns @table table(
 LevelNum int, UserID int, SpreaderID int
)
as
begin
	DECLARE @LevelNum int = 0;
    ;with temp (LevelNum, UserID, SpreaderID) as 
    (
		SELECT @LevelNum+1, UserID, SpreaderID from QPAccountsDBLink.QPAccountsDB.dbo.AccountsInfo where [SpreaderID] = @dwSpreaderID
		UNION ALL
		SELECT temp.LevelNum+1, a.UserID, a.SpreaderID from QPAccountsDBLink.QPAccountsDB.dbo.AccountsInfo a
		INNER JOIN temp ON a.[SpreaderID] = temp.[UserID]
    )
    insert into @table  (LevelNum, UserID, SpreaderID)
    select LevelNum, UserID, SpreaderID from temp 
    return 
end
go


