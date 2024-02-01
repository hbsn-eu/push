function Invoke-HBSJob {
    param (
        [scriptblock[]]$Jobs
    )

    $jobResults = @()
    $jobList = @()

    foreach ($job in $Jobs) {
        $jobList += Start-Job -ScriptBlock $job
    }

    # Warte auf die Fertigstellung aller Jobs
    $jobList | Wait-Job

    # Ergebnisse sammeln
    foreach ($job in $jobList) {
        $jobResults += Receive-Job -Job $job
        Remove-Job -Job $job
    }

    # Ergebnisse zurückgeben
    return $jobResults
}
