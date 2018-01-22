# 作者:门鹏鹏 20180122
# 版本:V1.0
# 修改系统主机名称并加到公司的域环境中

#-----------------------------------
# 1.修改IP地址
function updateip ($ip) {
    $wmi = Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
    $wmi.EnableStatic($ip, "255.255.255.0")
    $wmi.SetGateways("192.168.2.254")
    $wmi.SetDNSServerSearchOrder("192.168.2.101")
}

function hostname_yu($hostname) {
    $Username = '域用户'
    $Password = '域密码'
    $Pass = ConvertTo-SecureString $Password -AsPlainText -Force
    $Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$Pass
    Add-Computer -NewName $hostname -DomainName cf.local -Credential $Cred 
}

function reboot ($select) {
    if( $select -eq "y" -and $select -eq "Y"){
       Restart-Computer 
    }elseif ($select -eq "n" -and $select -eq "N") {
        Write-Host "稍后请手动重新启动" 
    }else{
        Write-Host "输入错误" 
    }
}
Write-Host "------1:设置IP地址-------" -ForegroundColor Green
$ip=Read-Host "请输入要设置的IP地址:" 
updateip($ip)
Write-Host "------2:计算机名并加域-------" -ForegroundColor Green
$hostname = Read-Host "请输入要设置的计算机名称:"
hostname_yu($hostname)
Write-Host "------3:重启服务器，输入y or n-------" -ForegroundColor Green
$selcet=Read-host "请输入重启服务器的选择:"
reboot($selce)