#---> Declarations
$INCOMING = 'C:\!Incoming'
$SCRATCH = 'C:\!Scratch'
$REPOSITORIES = 'C:\!Repositories'
$ONEDRIVE = $ENV:OneDrive

#---> Import Modules


#---> Functions
#---> Winston Fassett ( Link: https://stackoverflow.com/a/5501909 )
function reload { Invoke-Command { & "powershell.exe" } -NoNewScope }
function reboot { shutdown /r /t 0 /f }
function poweroff { shutdown /s /t 0 /f }
function hosts { Invoke-Item c:\windows\system32\drivers\etc\hosts }
function incoming { Set-Location -Path $INCOMING }
function scratch { Set-Location -Path $SCRATCH }
function repositories { Set-Location -Path $REPOSITORIES }
function onedrive { Set-Location -Path $ONEDRIVE }

#!Scripts
#!Temp
#User profile (home)
#desktop


#---> Credit: theSysadminChannel (Link: https://thesysadminchannel.com/get-uptime-last-reboot-status-multiple-computers-powershell/ )
function uptime {
    $OSData = Get-WmiObject Win32_OperatingSystem -ErrorAction Stop
    $UptimeData = ( Get-Date ) - $OSData.ConvertToDateTime( $OSData.LastBootUpTime )
    ( [string]$UptimeData.Days + " Days, " + $UptimeData.Hours + " Hours, " + $UptimeData.Minutes + " Minutes, " + $UptimeData.Seconds + " Seconds" )
}

function watch {
    [CmdletBinding()]
    Param (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]

        [string[]]
        $ComputerName = $env:COMPUTERNAME
    )

    while ($true) { <your command here> | Out-Host; Sleep 5; Clear }
}





#---> Set up logging/transcription

#---> Apply custom Oh My Posh! theme