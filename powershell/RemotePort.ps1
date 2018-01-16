# author:menpengpeng
# date:2018-01-04
# Email:menpengpeng@163.com
# Function：对远程端口进行修改的powershell脚本
Write-Host
Write-Host 1:自定义远程桌面端口 -ForegroundColor 10
Write-Host 2:恢复系统默认的远程端口 -ForegroundColor 11

Write-Host 
Write-Host
Write-Host "请从上面的列表中选择 1 or 2"
$opt = Read-Host
switch ($opt) {
    1 { 
        Write-Host 
        write-Host "--------------修改远程桌面的默认端口3389---------" -ForegroundColor Red 
        $PortNumber = Read-Host "现在请输入要指定的端口号（1024-655525)\n"
        $originaltcp = (Get-ItemProperty -Path "hklm:SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp").PortNumber
        Write-Host "\Tds\tcp当前远程端口值:" + $originaltcp -ForegroundColor Red
        $result1= Set-ItemProperty -Path 'hklm:SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp' -Name 'PortNumber' -Value $PortNumber
        $resulttcp = (Get-ItemProperty -Path "hklm:SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp").PortNumber
        if($resulttcp -eq $PortNumber)
        {
           Write-Host "已经完成RDP的TCP端口的修改" -ForegroundColor Green
        }
        else {
            Write-Host "修改RDP-TCP端口失败" -ForegroundColor Red
        }

        $originalrdp =  (Get-ItemProperty -Path "hklm:SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp").PortNumber
        Write-Host "\Tds\tcp当前远程端口值:" + $originalrdp -ForegroundColor Red
        $result2= Set-ItemProperty -Path 'hklm:SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber' -Value $PortNumber
        $resultrdp = (Get-ItemProperty -Path "hklm:SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp").PortNumber
        if($resultrdp -eq $PortNumber)
        {
           Write-Host "已经完成RDP的TCP端口的修改" -ForegroundColor Green
        }
        else {
            Write-Host "修改RDP-TCP端口失败" -ForegroundColor Red
        }

        #重启远程桌面服务
        Write-Host "正在重启 Remote Desktop Services …" -ForegroundColor DarkYellow 
        Restart-Service TermService -Force
        Write-Host "远程服务已经重启成功" -ForegroundColor Green
        
        #运行自定义远程端口通过防火墙
        Write-Host "-------添加防火墙策略，允许现有 RDP 端口" + $PortNumber "入站------"
        $result3=New-NetFirewallRule -DisplayName "Allow Custom RDP PortNumber" -Direction Inbound -Protocol TCP -LocalPort $PortNumber -Action Allow 
        Write-Host $result3.PrimaryStatus

        if($result3.PrimaryStatus -eq '0k') 
        { 
            Write-Host "已经完成 RDP 端口对应防火墙策略的添加！" -ForegroundColor Green 
        } 
        else 
        { 
            Write-Host "添加RDP 端口对应防火墙策略失败" -ForegroundColor Red 
        } 
        Write-Host 
        Write-Host "完成 RDP 端口修改！"
     }
     #恢复默认端口
     2 { 
        Write-Host 
        Write-Host "正在恢复系统默认端口…" 
        Set-ItemProperty -Path 'hklm:SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp' -Name 'PortNumber' -Value 3389
        Set-ItemProperty -Path 'hklm:SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber' -Value 3389
        Write-Host "正在重启 Remote Desktop Services… "
        Restart-Service termservice -Force 
        Write-Host "正在删除防火墙设置… "
        Remove-NetFirewallRule -DisplayName "Allow Custom RDP PortNumber" 
        write-host "完成恢复！" -ForegroundColor Green 
       } 
    
}