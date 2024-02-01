$jobs = @(
    { Invoke-RestMethod -Uri "https://api.example.com/data" -ErrorAction Stop },
    { Invoke-Command -ComputerName "RemoteComputer" -ScriptBlock { throw "Ein Fehler ist aufgetreten." } -ErrorAction Stop }
)

$results = Invoke-HBSJob -Jobs $jobs

if ($results.Success) {
    Write-Host "Alle Jobs wurden erfolgreich ausgeführt. Ergebnisse:"
    $results.Results
} else {
    Write-Host "Einige Jobs sind fehlgeschlagen. Fehler:"
    $results.Errors
}

Write-Host "Details siehe Log-Datei: HBSJobLog.txt"
