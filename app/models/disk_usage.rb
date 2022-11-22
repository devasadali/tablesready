class DiskUsage
  def self.send_alert
    disk_usage = `df / | grep / | awk '{ print $5}' | sed 's/%//g'`.to_i
    puts "disk size used: #{disk_usage}%"

    alert_send = true

    case disk_usage
    when 85
      puts "disk used is 85%"
    when 90
      puts "disk used is 90%"
    when 95
      puts "disk used is 95%"
    else
      alert_send = false
      # puts "disk is only #{disk_usage}% used:"
    end

    if alert_send
      AlertMailer.disk_usage_alert(disk_usage).deliver
    end

    # reschedule disk check after 10 minutes
    time = Time.now + 20.minutes
    DiskUsage.delay(run_at: time).send_alert
  end
end