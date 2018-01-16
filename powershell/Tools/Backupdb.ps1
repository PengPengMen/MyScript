import-module sqlps; 
$dbname = Get-Content D:\backup_sqldb\Srcipts\DBName.txt
#$dbname -is [array]
for($i=0;$i -lt $dbname.Count; $i++){
   $db = $dbname[$i]
   $instance = '192.168.2.223,1433'   
   $targetDir = 'D:\backup_sqldb\backupfile'
   $datestr = Get-Date -format yyyyMMddHHmmss  
   $backupFile = $targetDir + '\' + $db + '_' + $datestr + '.bak'
   try{
   Backup-SqlDatabase -ServerInstance $instance -Database $db -CompressionOption On -Checksum -BackupFile $backupFile  
   $db+"数据库，在"+$datestr+"备份完成" >> D:\backup_sqldb\backuplog\backuolog.txt 
   }Catch{
    $db+"数据库，在"+$datestr+"备份失败！" >> D:\backup_sqldb\backuplog\backupErrorlog.txt 
   }
}

