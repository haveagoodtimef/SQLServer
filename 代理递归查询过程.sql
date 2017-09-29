USE jeefwtwo
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SaveDaiLiData]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SaveDaiLiData]
GO


CREATE PROC SaveDaiLiData
	@dwSpreaderID INT
AS

-- 属性设置
SET NOCOUNT ON
-- 执行逻辑
BEGIN

IF @dwSpreaderID <=0 OR @dwSpreaderID IS NULL
RETURN 1

DECLARE @tableName NVARCHAR(20);
SET @tableName = 'DaiLiData'+CONVERT(VARCHAR(60),@dwSpreaderID)
print(@tableName)

DECLARE @Sql NVARCHAR(500);
SET @Sql = ''

SET @Sql='
IF  (OBJECT_ID('''+@tableName+''') IS NOT NULL ) DROP TABLE '+@tableName+'
CREATE TABLE '+@tableName+'([LevelNum] [int] NULL,[UserID] [int] NULL,[SpreaderID] [int] NULL)'
PRINT @Sql
Exec(@Sql)
SET @Sql = ''

DECLARE @LevelNum INT 		
DECLARE @UserID INT 			
DECLARE @SpreaderID INT
DECLARE m_cursor CURSOR FAST_FORWARD FOR 
SELECT LevelNum, UserID, SpreaderID FROM dbo.GetDaiLiData(@dwSpreaderID)

--打开游标 
OPEN m_cursor 
--取第一条记录 
FETCH NEXT FROM m_cursor INTO @LevelNum, @UserID, @SpreaderID
WHILE @@FETCH_STATUS=0
BEGIN
	SET @Sql = 'INSERT INTO '+@tableName+' VALUES ('+STR(@LevelNum)+','+STR(@UserID)+','+STR(@SpreaderID)+')'
	PRINT @Sql
	Exec(@Sql)
	FETCH NEXT FROM m_cursor INTO @LevelNum, @UserID, @SpreaderID
END
-- 关闭游标
CLOSE m_cursor
-- 释放游标
DEALLOCATE m_cursor
SET @Sql = ''
	
END
RETURN 0
GO