# 版本:V1.0
# 时间:2017-11-17
# 作者:门鹏鹏
# 使用方法:先安装it.wiechecki.mysql-cmdlet.msi，然后运行该脚本文件。
Clear-Host
set-ExecutionPolicy RemoteSigned  #允许脚本运行
Import-Module MySqlCmdlets
[string] $PasswordFlie = 'D:\serveinfo\file.txt'
[string] $username ="root"
[string] $database = "serverinfo"
$password = ConvertTo-SecureString -String ",ysqlpassword" -AsPlainText -Force
Connect-MySqlServer -Server 192.168.2.223 -UserName $username -Password $password -Database $database
Write-Host "Mysql connctiond successd"


#获取基础信息到数据库serverInfo表中
$localTime = Get-Date
$ComputerName = '' 
$ipv4=[System.Net.Dns]::GetHostAddresses($ComputerName) |Where-Object { $_.AddressFamily -eq 'InterNetwork'} |Select-Object -ExpandProperty IPAddressToString
$OSVersion = Get-CimInstance -ClassName Win32_OperatingSystem |select Caption, Version | Out-String
$OSVersion = $OSVersion.Trim(" .-`t`n`r")
$hostname = HOSTNAME |Out-String
$cpu = "{0:0.0} %" -f (Get-Counter -Counter "\Processor(_Total)\% Processor Time" | foreach {$_.CounterSamples[0].CookedValue} )|Out-String
$memory=(Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory /1gb 
$memory = " {0:0.0} GB" -f ($([Math]::Round($memory,2))) | Out-String 

$mem1 =0 + (gwmi win32_OperatingSystem).TotalVisibleMemorySize
$mem2 =0 + (gwmi win32_OperatingSystem).FreePhysicalMemory
$memsize = "{0:0.0} %" -f ([Math]::round((($mem1 - $mem2)/$mem1) * 100 ,3  ) )| Out-String

Invoke-MySqlQuery  -Query "INSERT INTO  baseinfo  VALUES ('$localTime','$ipv4','$OSVersion','$hostname','$cpu','$memory','$memsize')"

#获取各个磁盘的信息，并保存到数据库中
$Server = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property name
#$Disks =  gwmi –computername $Server win32_logicaldisk -filter "drivetype=3"
$Disks =  Get-WmiObject win32_logicaldisk  |  Where-Object {$_.drivetype -eq 3}


foreach ($Disk in $Disks) 
  { 
    $diskid = $Disk | Select-Object -Property DeviceID | Out-String
    $diskid = $diskid.Trim(" .-`t`n`r")
    Write-Host $diskid
    $Size = "{0:0.0} GB" -f ($Disk.Size / 1GB ) | Out-String
    $FreeSpace = " {0:0.0} GB" -f ($Disk.FreeSpace / 1GB) | Out-String
    $Used = ([int64]$Disk.size - [int64]$Disk.freespace) | Out-String
    $SpaceUsed = " {0:0.0} GB" -f ($Used / 1GB) | Out-String
    # $Percent ="{0:0.0} %" -f ($Used * 100 / $Disk.Size)
    $Percent = "{0:0.0} %" -f ([int64]$Used * 100 / [int64]$Disk.Size) | Out-String
    Write-Host $Disk.deviceid $Disk.volumename"盘总空间: $Size"  
    Write-Host $Disk.deviceid $Disk.volumename"空闲空间: $FreeSpace" 
    Write-Host $Disk.deviceid $Disk.volumename"使用空间:  $SpaceUsed" 
    Write-Host $Disk.deviceid $Disk.volumename"使用百分比:  $Percent "  
    Invoke-MySqlQuery  -Query "INSERT INTO  diskinfo  VALUES ('$hostname','$localTime','$diskid','$Size','$FreeSpace','$SpaceUsed','$Percent')"
} 
