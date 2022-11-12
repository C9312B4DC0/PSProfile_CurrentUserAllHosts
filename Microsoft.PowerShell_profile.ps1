<#
██╗███████╗███████╗███╗   ██╗███████╗ ██████╗ ███████╗████████╗
██║██╔════╝██╔════╝████╗  ██║██╔════╝██╔═══██╗██╔════╝╚══██╔══╝
██║███████╗█████╗  ██╔██╗ ██║███████╗██║   ██║█████╗     ██║
██║╚════██║██╔══╝  ██║╚██╗██║╚════██║██║   ██║██╔══╝     ██║
██║███████║███████╗██║ ╚████║███████║╚██████╔╝██║        ██║
╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝        ╚═╝
.NOTES
    Version:        1.0
    Author:         C9312B4DC0
    File Name:      BASEPOWERSHELLPROFILE.ps1
    Credit:         ᶘ ᵒᴥᵒᶅ
    Company:        ISENSOFT
    Creation Date:  (╬ಠ益ಠ)
    URL:            (ノಠ益ಠ)ノ彡┻━┻
#>

#desktop

#---> Import Modules
Import-Module -Name PSFramework, PSModuleDevelopment, PSUtil, Terminal-Icons, Watch, PoshRSJob, PSReadLine, Uptime

Set-PSFConfig -FullName psutil.keybinding.copyall -Value 'Ctrl+Alt+C'
Set-PSFConfig -FullName psutil.keybinding.expandalias -Value 'Ctrl+Q'

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

#---> Functions
function reload { Invoke-Command { & "powershell.exe" } -NoNewSc\watchope } #---> Credit: Winston Fassett ( Link: https://stackoverflow.com/a/5501909 )
function reboot { shutdown /r /t 0 /f }
function poweroff { shutdown /s /t 0 /f }
function hosts { Invoke-Item c:\windows\system32\drivers\etc\hosts }
function verb { Get-Verb | Sort-Object -Property Verb }
function incoming { Set-Location -Path 'C:\!Incoming' }
function scratch { Set-Location -Path 'C:\!Scratch' }
function repositories { Set-Location -Path 'C:\!Repositories' }
function onedrive { Set-Location -Path $ENV:OneDrive }
function temp { Set-Location -Path 'C:\!Temp' }
function tools { Set-Location -Path 'C:\!Tools' }
function projects { Set-Location -Path 'C:\!Projects' }
function scripts { Set-Location -Path 'C:\!Sctipts' }
function logs { Set-Location -Path $ENV:OneDrive\!Logs }
function home { Set-Location -Path $HOME }
function New-Username { [System.Convert]::ToString( $( Get-Random -Minimum 100000000000 -Maximum 999999999999 ), 16 ).ToUpper() }

function New-XKPassword {
    #---> Credit to 45413 on GitHub (https://gist.github.com/45413/9fc7726f054810cf49b8471a7b986e76)
    [CmdletBinding(DefaultParameterSetName = 'default', SupportsShouldProcess = $true, PositionalBinding = $false, ConfirmImpact = 'Medium')]
    [Alias()]
    [OutputType([String[]])]
    Param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false, ParameterSetName = 'default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 10)]
        [int]$Count = 1,

        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false, ParameterSetName = 'default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $true })]
        [ValidateRange(2, 10)]
        [int]$Words = 3
    )

    $requestPayload = @{
        a = "genpw"
        n = $Count
        c = @{
            "num_words"                 = $Words;
            "word_length_min"           = 4;
            "word_length_max"           = 8;
            "case_transform"            = "RANDOM";
            "separator_character"       = "RANDOM";
            "separator_alphabet"        = "!", "@", "$", "%", "^", "&", "*", "-", "_", "+", "=", ":", "|", "~", "?", "/", ".", ";", ":", "<", ">", "(", ")", "[", "]", "{", "}";
            "padding_digits_before"     = 2;
            "padding_digits_after"      = 2;
            "padding_type"              = "FIXED";
            "padding_character"         = "RANDOM";
            "symbol_alphabet"           = "!", "@", "$", "%", "^", "&", "*", "-", "_", "+", "=", ":", "|", "~", "?", "/", ".", ";", ":", "<", ">", "(", ")", "[", "]", "{", "}";
            "padding_characters_before" = 2;
            "padding_characters_after"  = 2;
            "random_increment"          = "AUTO"
        } | ConvertTo-Json
    }

    if ($PSCmdlet.ShouldProcess( "https://xkpasswd.net", "Submit request for $Count passwords" ) ) {
        $results = Invoke-WebRequest -Uri "https://xkpasswd.net/s/index.cgi" -Method "POST" -ContentType "application/x-www-form-urlencoded; charset=UTF-8" -Body $requestPayload
        $results = $results.Content | ConvertFrom-Json
        $results.passwords
    }
}

function New-RandomPassword {
    #---> This isn't mine, but I don't remember who created it...
    param (
        [Parameter()]
        [int] $length = 24,
        [int] $amountOfNonAlphanumeric = 6
    )
    Add-Type -AssemblyName 'System.Web'
    return [System.Web.Security.Membership]::GeneratePassword( $length, $amountOfNonAlphanumeric )
}

#---> Credit: theSysadminChannel (Link: https://thesysadminchannel.com/get-uptime-last-reboot-status-multiple-computers-powershell/ )
function Get-Uptime {
    $OSData = Get-WmiObject Win32_OperatingSystem -ErrorAction Stop
    $UptimeData = ( Get-Date ) - $OSData.ConvertToDateTime( $OSData.LastBootUpTime )
    ( [string]$UptimeData.Days + " Days, " + $UptimeData.Hours + " Hours, " + $UptimeData.Minutes + " Minutes, " + $UptimeData.Seconds + " Seconds" )
}

function Watch-Command {
    [CmdletBinding()]
    Param (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]

        [string[]]
        $ComputerName = $env:COMPUTERNAME
    )

    while ($true) { <your command here> | Out-Host; Sleep 2; Clear }
}




#---> Set up logging/transcription

#---> Apply custom Oh My Posh! theme