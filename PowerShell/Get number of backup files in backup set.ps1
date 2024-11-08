<# GET NUMBER OF BACKUP FILES IN THE BACKUP SET #>
<# YOU CAN USE ANY FILE IN THE SET FOR THE URL #>
$backupFileURLLabelCheck = "<full URL of blob backup>"
$query = "RESTORE LabelOnly FROM URL = '$backupFileURLLabelCheck'"
$labelQueryResult = invoke-sqlcmd -ServerInstance $targetForRestores -database master -Query $query -TrustServerCertificate
$NumberOfBackupfiles =  $labelQueryResult.familyCount
$NumberOfBackupfiles
