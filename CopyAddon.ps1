$WOW_INSTALL_KEY = "HKLM:\SOFTWARE\WOW6432Node\Blizzard Entertainment\World of Warcraft"
$ADDON = "CovenantMissionRobot"
$WOW_DIR = (Get-ItemProperty -Path $WOW_INSTALL_KEY -Name "InstallPath").InstallPath
$WOW_DIR = (Get-Item $WOW_DIR).Parent.FullName
$WOW_CMR = Join-Path -Path $WOW_DIR -ChildPath "_retail_\Interface\AddOns\$ADDON"

Write-Output $WOW_CMR

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

Write-Output "Cleanup addon path: $WOW_CMR"
Remove-Item -LiteralPath $WOW_CMR -Force -Recurse

Write-Output "Copy addon from $scriptPath\$ADDON to $WOW_CMR"
Copy-Item -Path $scriptPath\$ADDON -Filter "*.*" -Recurse -Destination $WOW_CMR -Container
