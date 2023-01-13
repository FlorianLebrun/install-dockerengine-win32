
function Enable-DockerEngine-WindowsFeature {
    Enable-WindowsOptionalFeature -Online -FeatureName containers -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
}

Enable-DockerEngine-WindowsFeature
