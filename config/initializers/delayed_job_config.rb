# 失敗したジョブを消さない
Delayed::Worker.destroy_failed_jobs = false
# リトライしない
Delayed::Worker.max_attempts = 0
