name: CI

on: workflow_dispatch

jobs:
  build:

    runs-on: windows-latest
    timeout-minutes: 360

    steps:
    - name: Download Ngrok & NSSM
      run: |
        Invoke-WebRequest https://raw.githubusercontent.com/TheDarkMythos/Ngrok-Exe/master/ngrok.exe -OutFile ngrok.exe
        Invoke-WebRequest https://github.com/fmcpetermux/windowsrdpfree/raw/main/nssm.exe -OutFile nssm.exe
    - name: Copy NSSM & Ngrok to Windows Directory.
      run: | 
        copy nssm.exe C:\Windows\System32
        copy ngrok.exe C:\Windows\System32
    - name: Connect your NGROK account
      run: .\ngrok.exe authtoken $Env:NGROK_AUTH_TOKEN
      env:
        NGROK_AUTH_TOKEN: ${{ secrets.NGROK_AUTH_TOKEN }}
    
        
    - name: Enable RDP Access.
      run: | 
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
    
    - name: Connect to your RDP.
  
    - name: All Done! You can close Tab now! Maximum VM time:6h.
      run: cmd /c loop.bat 
