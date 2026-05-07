# Claude Worker Script (Safe Naming Version)
# Updated by Antigravity

Write-Host "--- Claude AI Worker Started (Safe Naming Mode) ---" -ForegroundColor Cyan

if (!(Test-Path "brain/tasks_done")) { New-Item -ItemType Directory "brain/tasks_done" }

while ($true) {
    # Quét các file có tiền tố WAIT_
    $tasks = Get-ChildItem "brain/tasks_queue/WAIT_*.txt"
    
    if ($tasks.Count -gt 0) {
        foreach ($task in $tasks) {
            $taskBaseName = $task.BaseName.Replace("WAIT_", "")
            $workingName = "WORK_$taskBaseName.working"
            $workingPath = Join-Path $task.Directory.FullName $workingName
            
            # Đổi tên sang WORK_
            Rename-Item -Path $task.FullName -NewName $workingName -ErrorAction SilentlyContinue
            
            if (Test-Path $workingPath) {
                Write-Host "[EXEC] Processing: $taskBaseName" -ForegroundColor Yellow
                $prompt = Get-Content $workingPath -Raw
                
                # Thực thi Claude Code
                claude -p "$prompt"
                
                if ($LASTEXITCODE -eq 0) {
                    $finalName = "DONE_$taskBaseName.txt"
                    $finalPath = Join-Path "brain/tasks_done" $finalName
                    Write-Host "[OK] Finished: $taskBaseName" -ForegroundColor Green
                } else {
                    $finalName = "FAIL_$taskBaseName.txt"
                    $finalPath = Join-Path "brain/tasks_done" $finalName
                    Write-Host "[FAIL] Error in: $taskBaseName" -ForegroundColor Red
                }
                
                if (Test-Path $finalPath) { Remove-Item $finalPath }
                Move-Item $workingPath $finalPath
                
                git add .
                git commit -m "worker: finished $finalName"
                git push origin master
                [console]::beep(1000, 300)
            }
        }
    }
    Start-Sleep -Seconds 5
}
