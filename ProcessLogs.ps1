$scriptPath = split-path -parent $MyInvocation.MyCommand.ScriptBlock.File

$WOW_INSTALL = "HKLM:\SOFTWARE\WOW6432Node\Blizzard Entertainment\World of Warcraft"
$WOW_DIR = (Get-ItemProperty -Path $WOW_INSTALL -Name "InstallPath").InstallPath
$WOW_DIR = (Get-Item $WOW_DIR).Parent.FullName

$wtfPath = Join-Path -Path $WOW_DIR -ChildPath "_retail_\WTF\Account"
$accFolderList = Get-ChildItem -Path $wtfPath -Directory -Force -ErrorAction SilentlyContinue

# copy file
Function CopyLogFile($logFile) {
    $myLogDir = "$scriptPath\Logs"
    Write-Output $myLogDir
    $logs = Get-ChildItem -Path $myLogDir -File -Filter "*.lua" -Force -ErrorAction SilentlyContinue
    $cnt = $logs.Length

    $dst = "$myLogDir\CovenantMissionRobot_{0:D3}.lua" -f $cnt
    Copy-Item -Path $logFile -Destination $dst

    if (Test-Path -Path $logFile) {
        Remove-Item -LiteralPath $logFile
    }

    $bak ="$logFile.bak"
    if (Test-Path -Path $bak) {
        Remove-Item -LiteralPath $bak
    }

    $dst
}

Function ProcessLogFile($logFile) {

}

Function ExecSql($logFile) {

}

foreach ($accFolder in $accFolderList) {
    if ($accFolder.Name -like '*#1') {
        $logFile = Join-Path -Path $accFolder.FullName -ChildPath "SavedVariables\CovenantMissionRobot.lua"
        if (Test-Path -Path $logFile) {
            if ($logFile.Length -gt 20000000) {
                Write-Output $logFile
                $file = CopyLogFile $logFile
                $file = ProcessLogFile $file
                ExecSql $file
            }
        }
    }
}
