
function Remove-MachinePath-With-Executable {
    param (
        [string] $ExecName
    )
    $curPaths = [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    $newPaths = ""
    ForEach ($pth in $curPaths.Split(";")) {
        if ($pth -and -not (Test-Path "$pth\$ExecName")) {
            $newPaths += ";" + $pth
        }
    }
    [Environment]::SetEnvironmentVariable("Path", $newPaths, [System.EnvironmentVariableTarget]::Machine)
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
}

function Add-MachinePath-With-Executable {
    param (
        [string] $Path,
        [string] $ExecName
    )
    $curPaths = [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    if ($Path -and (Test-Path "$Path\$ExecName")) {
        $newPaths = $curPaths + ";" + $Path
        [Environment]::SetEnvironmentVariable("Path", $newPaths, [System.EnvironmentVariableTarget]::Machine)
    }
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
}

function Install-DockerEngine {
    param (
        [string] $InstallDirectory,
        [string] $Version
    )
    $dockerPath = "$InstallDirectory\docker-$Version"
    $dataPath = "$InstallDirectory\data"

    # Uninstall previous docker service
    try {
        Get-Service "docker" -ErrorAction "Stop" | Out-Null
        Write-Output "> DockerEngine previous service will be removed"
        try {
            Stop-Service -Name "docker" -PassThru | Out-Null
            dockerd --unregister-service
        }
        catch {
            Write-Error "DockerEngine previous service cannot be removed"
        }
    }
    catch {
        Write-Output "Note: DockerEngine has no previous running service"
    }

    # Setup docker directory
    if (-not (Test-Path $dockerPath)) {
        Write-Output "> DockerEngine will be installed at: $dockerPath"
        
        $archName = "docker-$Version.zip"
        $archPath = "$PSScriptRoot/$archName"
        if (-not (Test-Path $archPath)) {
            # Download installed archive when not present
            curl.exe -o "$archPath" -LO "https://download.docker.com/win/static/stable/x86_64/$archName"
        }
        Expand-Archive "$archPath" -DestinationPath "$InstallDirectory" -Force
        Rename-Item "$InstallDirectory/docker" "docker-$Version"
    }
    else {
        Write-Output "Note: DockerEngine already installed at: $dockerPath"
    }

    # Add docker directory to PATH env
    if (-not $env:Path.Contains($dockerPath)) {
        Write-Output "> DockerEngine added in env PATH"
        Remove-MachinePath-With-Executable "docker.exe"
        Add-MachinePath-With-Executable -Path "$dockerPath" -ExecName "docker.exe"
    }
    else {
        Write-Output "Note: DockerEngine already declared in env PATH"
    }

    # Install service
    Write-Output "> DockerEngine service will be started"
    $usersGroup = Gwmi win32_group -Filter "Domain='$env:computername' and SID='S-1-5-32-545'" 
    dockerd --group "$($usersGroup.Name)" --data-root "$dataPath" --register-service
    Start-Service docker
}

Set-Location -Path "$PSScriptRoot"
Install-DockerEngine -InstallDirectory "C:\DockerEngine" -Version "20.10.22"
