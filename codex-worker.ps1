# Codex Worker Script (Safe Naming Version)
# Updated by Antigravity

Write-Host "--- Codex AI Worker Started (Safe Naming Mode) ---" -ForegroundColor Magenta

if (!(Test-Path "brain/tasks_done")) { New-Item -ItemType Directory "brain/tasks_done" }

while ($true) {
    $tasks = Get-ChildItem "brain/tasks_queue/WAIT_*.txt" | Where-Object { $_.Name -like "*ui*" -or $_.Name -like "*codex*" }
    
    if ($tasks.Count -gt 0) {
        foreach ($task in $tasks) {
            $taskBaseName = $task.BaseName.Replace("WAIT_", "")
            $workingName = "WORK_$taskBaseName.working"
            $workingPath = Join-Path $task.Directory.FullName $workingName
            
            Rename-Item -Path $task.FullName -NewName $workingName -ErrorAction SilentlyContinue
            
            if (Test-Path $workingPath) {
                Write-Host "[EXEC] Codex Processing: $taskBaseName" -ForegroundColor Yellow
                
                $finalName = "DONE_$taskBaseName.txt"
                $finalPath = Join-Path "brain/tasks_done" $finalName
                
                if (Test-Path $finalPath) { Remove-Item $finalPath }
                Move-Item $workingPath $finalPath
                
                git add .
                git commit -m "worker(codex): finished $finalName"
                git push origin master
                [console]::beep(800, 200)
            }
        }
    }
    Start-Sleep -Seconds 10
}
