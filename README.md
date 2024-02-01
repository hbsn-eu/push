# push
# Beispiel-Skriptblöcke für die parallele Ausführung
$job1 = { Invoke-RestMethod -Uri "https://api.example.com/data" }
$job2 = { Invoke-Command -ComputerName "RemoteComputer" -ScriptBlock { param($path) Get-Content $path } -ArgumentList "C:\example.txt" }

# Funktion aufrufen und Ergebnisse erhalten
$results = Invoke-HBSJob -Jobs @($job1, $job2)

# Ergebnisse ausgeben
$results
