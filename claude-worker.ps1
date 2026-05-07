# Claude Worker Script for MAS
# Created by Antigravity (Architect)

Write-Host "--- Claude AI Worker Started (Polling brain/tasks_queue) ---" -ForegroundColor Cyan

# Đảm bảo thư mục tồn tại
if (!(Test-Path "brain/tasks_done")) { New-Item -ItemType Directory "brain/tasks_done" }

while ($true) {
    # 1. Quét task trong hàng đợi
    $tasks = Get-ChildItem "brain/tasks_queue/*.txt" | Where-Object { $_.Extension -eq ".txt" }
    
    if ($tasks.Count -gt 0) {
        foreach ($task in $tasks) {
            $taskName = $task.BaseName
            $workingPath = "brain/tasks_queue/$taskName.working"
            
            # 2. Đánh dấu đang thực hiện
            Rename-Item $task.FullName $workingPath
            Write-Host "[WORKING] Starting task: $taskName" -ForegroundColor Yellow
            
            # 3. Đọc prompt
            $prompt = Get-Content $workingPath -Raw
            
            # 4. Thực thi Claude Code CLI
            # LƯU Ý: Đảm bảo bạn đã cài đặt @anthropic-ai/claude-code
            Write-Host "[EXEC] Calling Claude Code..." -ForegroundColor Gray
            claude --print-config > $null # Kiểm tra CLI
            claude -p "$prompt"
            
            # 5. Hoàn tất & Di chuyển
            $donePath = "brain/tasks_done/$taskName.done.txt"
            if (Test-Path $donePath) { Remove-Item $donePath }
            Move-Item $workingPath $donePath
            
            # 6. Cập nhật Git
            Write-Host "[GIT] Syncing results..." -ForegroundColor Blue
            git add .
            git commit -m "worker: completed task $taskName"
            git push origin master
            
            # 7. Âm thanh thông báo & Beep (Quy tắc MAS)
            Write-Host "[SUCCESS] Task $taskName finished!" -ForegroundColor Green
            [console]::beep(1000, 200)
            Start-Sleep -Milliseconds 100
            [console]::beep(1500, 300)
        }
    }
    
    # Nghỉ 5 giây rồi quét lại
    Start-Sleep -Seconds 5
}
