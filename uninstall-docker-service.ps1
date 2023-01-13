
function Uninstall-DockerEngine {
   Write-Output "> DockerEngine previous service will be removed"
   Stop-Service -Name "docker"
   dockerd --unregister-service
}

Set-Location -Path "$PSScriptRoot"
Uninstall-DockerEngine
