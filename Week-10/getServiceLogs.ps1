# Storyline: View the event logs, check for the correct log, then print results

function  get_services() {
    cls

    $runningServices = Get-Service | Where { $_.Status -eq "running" }
    $runningArray = @()

    foreach ($tempRunning in $runningServices) 
    {
        $runningArray += $tempRunning
    }

    $stoppedServices = Get-Service | Where { $_.Status -eq "stopped" }
    $stoppedArray = @()

    foreach ($tempStopped in $stoppedServices)
    {
        $stoppedArray += $tempStopped
    }

    $Choice = Read-Host -Prompt "View all, running or stopped services? ['q' to quit]"

    if ($Choice -match "^[qQ]$")
    {
        break
    } elseif ($Choice -match "^running$") {
        write-host -BackgroundColor Green -ForegroundColor white "Loading running services..."
        sleep 2

    $runningArray | Out-Host

    Read-Host -Prompt "Press enter to continue..."
    get_services

    } elseif ($Choice -match "^stopped$") {
        write-host -BackgroundColor Green -ForegroundColor white "Loading stopped services..."
        sleep 2

    $stoppedArray | Out-Host

    Read-Host -Prompt "Press enter to continue..."
    get_services
    
    } elseif ($Choice -match "^all$") {
        write-host -BackgroundColor Green -ForegroundColor white "Loading all services..."
        sleep 2

    $runningArray | Out-Host
    $stoppedArray | Out-Host

    Read-Host -Prompt "Press enter to continue..."
    get_services
    } else {
        write-Host -BackgroundColor Red -ForegroundColor White "Invalid selection"
        sleep 2

        get_services
    }
}

get_services