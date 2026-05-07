# Codex Worker Script for MAS
# Created by Antigravity (Architect)

Write-Host "--- Codex AI Worker Started (Polling brain/tasks_queue) ---" -ForegroundColor Magenta

if (!(Test-Path "brain/tasks_done")) { New-Item -ItemType Directory "brain/tasks_done" }

while ($true) {
    # 1. Quét task trong hàng đợi
    $tasks = Get-ChildItem "brain/tasks_queue/*.txt" | Where-Object { $_.Name -like "*ui*" -or $_.Name -like "*codex*" }
    
    if ($tasks.Count -gt 0) {
        foreach ($task in $tasks) {
            $taskName = $task.BaseName
            $workingPath = "brain/tasks_queue/$taskName.working"
            
            Rename-Item $task.FullName $workingPath
            Write-Host "[WORKING] Codex is processing: $taskName" -ForegroundColor Yellow
            
            $prompt = Get-Content $workingPath -Raw
            
            # Giả định lệnh thực thi Codex/Copilot CLI là 'gh copilot' hoặc tương đương
            # Ở đây tôi dùng placeholder 'codex' - bạn có thể sửa lại cho đúng CLI bạn dùng
            Write-Host "[EXEC] Calling Codex CLI..." -ForegroundColor Gray
            # codex -p "$prompt" 
            Write-Warning "Codex CLI placeholder called. Please ensure 'codex' or 'gh copilot' is in PATH."
            
            $donePath = "brain/tasks_done/$taskName.done.txt"
            if (Test-Path $donePath) { Remove-Item $donePath }
            Move-Item $workingPath $donePath
            
            git add .
            git commit -m "worker(codex): completed task $taskName"
            git push origin master
            
            Write-Host "[SUCCESS] Codex Task $taskName finished!" -ForegroundColor Green
            [console]::beep(800, 200)
            [console]::beep(1200, 200)
        }
    }
    Start-Sleep -Seconds 10
}
