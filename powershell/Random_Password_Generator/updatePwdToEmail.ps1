## 时间:2017-11-30
## 作者:门鹏鹏
## 修改当前账户的密码  使用的是随机密码，修改密码之后发生邮件到指定的账户


#发送邮件通知函数
Function Send-mailTest($bodycontent){
   
     $From = "menpengpeng@163.com"
     $To = "menpp@cityfun.com.cn"
     #$To = $toemail
     $Subject = "相城前置机密码修改" 
     $Body = $bodycontent
     #$Body = "这是测试"
     $smtpServer = "smtp.163.com"
     $smtpPort = 25
     $username = "menpengpeng"
     $password = "email password"

     $SMTPMessage = New-Object System.Net.Mail.MailMessage($From, $To, $Subject, $Body)
     $SMTPClient = New-Object Net.Mail.SmtpClient($smtpServer, $SmtpPort) 
     $SMTPClient.EnableSsl = $false 
     $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($username, $password); 
     $SMTPClient.Send($SMTPMessage)
}

#----------随机密码生成器---------------
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
#-----------------------------------------------

# 更新密码

#————————————————————————————————————————————
#技术实现
$datestr = Get-Date -format yyyyMMddHHmmss 
#$MyEmil = "menpp@cityfun.com.cn"
#$masterEmail = "menpengpeng@qq.com"
$password = passwd
Write-Host $password
net user administrator $password
$datestr+"  XCQZJServer Password Update  "+$password >> D:\xcserver\userpasswordlog.txt
$NewPwd = $datestr+",密码已更新，新密码   " +$password+"   请查收!"
Send-mailTest($NewPwd)

