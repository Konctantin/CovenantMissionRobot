$WOW_INSTALL_KEY = "HKLM:\SOFTWARE\WOW6432Node\Blizzard Entertainment\World of Warcraft"

$WOW_DIR = (Get-ItemProperty -Path $WOW_INSTALL_KEY -Name "InstallPath").InstallPath
$WOW_DIR = (Get-Item $WOW_DIR).Parent.FullName

$ADDON = "CovenantMissionRobot"
$ADDON_FOLDER = Join-Path -Path $WOW_DIR -ChildPath "_retail_\Interface\AddOns\$ADDON"

Write-Output $ADDON_FOLDER

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

Write-Output "Cleanup addon path: $ADDON_FOLDER"
Remove-Item -LiteralPath $ADDON_FOLDER -Force -Recurse

Write-Output "Copy addon from $scriptPath\$ADDON to $ADDON_FOLDER"
Copy-Item -Path $scriptPath\$ADDON -Filter "*.*" -Recurse -Destination $ADDON_FOLDER -Container





$ADDON = "EasyFollowerUP"
$ADDON_FOLDER = Join-Path -Path $WOW_DIR -ChildPath "_retail_\Interface\AddOns\$ADDON"

Write-Output $ADDON_FOLDER

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

Write-Output "Cleanup addon path: $ADDON_FOLDER"
Remove-Item -LiteralPath $ADDON_FOLDER -Force -Recurse

Write-Output "Copy addon from $scriptPath\$ADDON to $ADDON_FOLDER"
Copy-Item -Path $scriptPath\$ADDON -Filter "*.*" -Recurse -Destination $ADDON_FOLDER -Container
