<# GET NUMBER OF BACKUP FILES IN THE BACKUP SET #>
$query = "RESTORE LabelOnly FROM URL = '$backupFileURLLabelCheck'"
$labelQueryResult = invoke-sqlcmd -ServerInstance $targetForRestores -database master -Query $query -TrustServerCertificate
$NumberOfBackupfiles =  $labelQueryResult.familyCount
$NumberOfBackupfiles
