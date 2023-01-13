# Install docker deamon

When you use containers for first time in windows, run in powershell with __admin mode__ this script:
```
Start-Process "powershell" "-NoExit .\enable-windows-features.ps1" -Verb runAs
```
_note_: Restart the computer when you have run _enable-windows-features.ps1_

To install docker service, run in powershell with __admin mode__ this script:
```
Start-Process "powershell" "-NoExit $pwd\install-docker-service.ps1" -Verb runAs
```

# Uninstall docker deamon

To uninstall docker service, run in powershell with __admin mode__ this script:
```
Start-Process "powershell" "-NoExit $pwd\uninstall-docker-service.ps1" -Verb runAs
```

# Use with Mongo

Start mongo container:
```
docker run --name mongodb -d -p 27017:27017 mongo
```

Install Mongo Compass from [here](https://www.mongodb.com/fr-fr/products/compass)

