declare @URLPath nvarchar(max) = '<full URL to blob backup>'

CREATE TABLE #RestoreLabelOnly (
	[MediaName]					NVARCHAR(128),
    [MediaSetID]				NVARCHAR(260),
    [FamilyCount]               INT,
    [FamilySequenceNumber]      NVARCHAR(128),
    [MediaFamilyID]             NVARCHAR(128),
    [MediaSequenceNumber]       INT,
    [MediaLabelPresent]         INT,
    [MediaDescription]          NVARCHAR(128),
    [SoftwareName]              NVARCHAR(128),
    [SoftwareVendorID]          NVARCHAR(128),
    [MediaDate]					datetime2(7),
    [MirrorCount]				INT,
    [IsCompressed]				INT
)

INSERT INTO #RestoreLabelOnly EXEC('RESTORE LabelOnly FROM URL = ''' + @URLPath + '''')
 
SELECT familycount, *
FROM #RestoreLabelOnly


drop table #RestoreLabelOnly
