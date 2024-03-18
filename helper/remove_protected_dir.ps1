$directoryPath = "C:\DockerEngine\my"

$items = Get-ChildItem -Path $directoryPath -Recurse
foreach ($item in $items) {
   &icacls $item.FullName /grant "Users:(F)" /c
}

Get-ChildItem -Path $directoryPath -Recurse | Remove-Item -Force
