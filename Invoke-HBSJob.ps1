function Invoke-HBSJob {
    param (
        [scriptblock[]]$Jobs
    )

    $jobResults = @()
    $jobList = @()
    $errorList = @()
    $logPath = "HBSJobLog.txt"

    # Initialisiert das Logging
    if (Test-Path $logPath) {
        Remove-Item $logPath -Force
    }

    foreach ($job in $Jobs) {
        $jobList += Start-Job -ScriptBlock $job -ErrorAction SilentlyContinue
    }

    # Logge Start der Jobs
    Add-Content -Path $logPath -Value "Job Start: $(Get-Date)"

    # Warte auf die Fertigstellung aller Jobs
    $jobList | Wait-Job

    # Ergebnisse und Fehler sammeln und loggen
    foreach ($job in $jobList) {
        if ($job.State -eq 'Failed') {
            $error = $job.ChildJobs[0].JobStateInfo.Reason
            $errorList += $error
            Add-Content -Path $logPath -Value "Fehler in Job $($job.Id): $error"
        } else {
            $result = Receive-Job -Job $job
            $jobResults += $result
            Add-Content -Path $logPath -Value "Erfolg in Job $($job.Id): Ergebnis gesammelt"
        }
        Remove-Job -Job $job
    }

    # Logge Abschluss der Jobs
    Add-Content -Path $logPath -Value "Job Ende: $(Get-Date)"

    # Fehlerbehandlung und Erfolgsrückmeldung
    if ($errorList.Count -gt 0) {
        $result = @{
            Success = $false
            Results = $jobResults
            Errors = $errorList
        }
    } else {
        $result = @{
            Success = $true
            Results = $jobResults
            Errors = $null
        }
    }

    # Ergebnisobjekt zurückgeben
    return $result
}
