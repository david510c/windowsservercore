FROM microsoft/windowsservercore

MAINTAINER david@davidchen.blog

SHELL   ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN     New-LocalUser -Name '"RDP"' -Password '"RDP"' -AccountNeverExpires -Description '"RDP User"' -FullName '"RDP"' -UserMayNotChangePassword
RUN     Add-LocalGroupMember -Group "Administrators" -Member "RDP"

RUN     New-LocalUser -Name '"MicrosoftAccount\emaildavid@yahoo.com"' -Description '"David's Microsoft Account"' -FullName '"David Chen"'
RUN     Add-LocalGroupMember -Group "Administrators" -Member "MicrosoftAccount\emaildavid@yahoo.com"

#  Enable Remote Desktop
RUN     (Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTsConnections(1,1) | Out-Null
RUN     (Get-WmiObject -Class "Win32_TSGeneralSetting" -Namespace root\cimv2\TerminalServices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0) | Out-Null
RUN     Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

EXPOSE    8000
EXPOSE    3389

SHELL     ["powershell"]
