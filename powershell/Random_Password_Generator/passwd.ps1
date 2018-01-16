# author:menpengpeng
# date:2018-01-04
# Email:menpengpeng@163.com
# Function：随机密码生成方法
function passwd
{ 
$figure=1,2,3,4,5,6,7,8,9; 
$capital="Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M"; 
$lowercase="q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m"; 
$specialCharacter="~","!","@","#","$","%","^","&","*","(",")","-","+"; 
$order=New-Object System.Collections.ArrayList; 
for($i=0;$i -lt 8;$i++) 
{ 
[void]$order.Add($i); 
} 
$newOrder=@(); 
for($i=0;$i -lt 8;$i++) 
{ 
$produceOrder=Get-Random -InputObject $order; 
$newOrder+=$produceOrder; 
$order.Remove($produceOrder); 
} 
$newPassword=@(); 
foreach($i in $newOrder) 
{ 
if($i -eq 0) 
{ 
$index=Get-Random -Maximum 8; 
$newPassword+=$figure[$index]; 
} 
if($i -eq 1) 
{ 
$index=Get-Random -Maximum 8; 
$newPassword+=$figure[$index]; 
} 
if($i -eq 2) 
{ 
$index=Get-Random -Maximum 25; 
$newPassword+=$capital[$index]; 
} 
if($i -eq 3) 
{ 
$index=Get-Random -Maximum 25; 
$newPassword+=$capital[$index]; 
} 
if($i -eq 4) 
{ 
$index=Get-Random -Maximum 25; 
$newPassword+=$lowercase[$index]; 
} 
if($i -eq 5) 
{ 
$index=Get-Random -Maximum 25; 
$newPassword+=$lowercase[$index]; 
} 
if($i -eq 6) 
{ 
$index=Get-Random -Maximum 12; 
$newPassword+=$specialCharacter[$index]; 
} 
if($i -eq 7) 
{ 
$index=Get-Random -Maximum 12; 
$newPassword+=$specialCharacter[$index]; 
} 
} 
return $newPassword -join ""; 
} 
passwd