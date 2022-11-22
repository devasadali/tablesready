namespace :disk_usage do

  desc "Send alert if disk space is 85%, 90% || 95%"
  task :send_alert => :environment do
    time = Time.now + 10.minutes
    DiskUsage.delay(run_at: time).send_alert
  end
end