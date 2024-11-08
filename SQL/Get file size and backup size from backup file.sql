declare @filename nvarchar(max) = '<full path to blob URL>'

CREATE TABLE #RestoreFilelistOnly (
    [LogicalName]           NVARCHAR(128),
    [PhysicalName]          NVARCHAR(260),
    [Type]                  CHAR(1),
    [FileGroupName]         NVARCHAR(128),
    [Size]                  NUMERIC(20,0),
    [MaxSize]               NUMERIC(20,0),
    [FileID]                BIGINT,
    [CreateLSN]             NUMERIC(25,0),
    [DropLSN]               NUMERIC(25,0),
    [UniqueID]              UNIQUEIDENTIFIER,
    [ReadOnlyLSN]           NUMERIC(25,0),
    [ReadWriteLSN]          NUMERIC(25,0),
    [BackupSizeInBytes]     BIGINT,
    [SourceBlockSize]       INT,
    [FileGroupID]           INT,
    [LogGroupGUID]          UNIQUEIDENTIFIER,
    [DifferentialBaseLSN]   NUMERIC(25,0),
    [DifferentialBaseGUID]  UNIQUEIDENTIFIER,
    [IsReadOnly]            BIT,
    [IsPresent]             BIT,
    [TDEThumbprint]         VARBINARY(32), 
    [SnapshotUrl]           NVARCHAR(360)
)

INSERT INTO #RestoreFilelistOnly EXEC('RESTORE FILELISTONLY FROM URL = ''' + @filename + '''')
 
SELECT PhysicalName, CONVERT(DECIMAL(10,3),(Size/1024/1024)) as FileSizeMB, CONVERT(DECIMAL(10,3),(BackupSizeInBytes/1024/1024)) as BackupSizeMB
FROM #RestoreFilelistOnly


drop table #RestoreFilelistOnly
