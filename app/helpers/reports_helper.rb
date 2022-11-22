module ReportsHelper
  def formatted_duration(total_minute)
    duration = ""
    hours = total_minute / 60
    minutes = (total_minute) % 60
    if hours > 0
      duration = "#{hours} #{'hr'.pluralize(hours)}"
      duration += " and #{minutes} #{'minute'.pluralize(minutes)}" if minutes > 0
    else
      duration = "#{minutes} #{'minute'.pluralize(minutes)}"
    end
    duration
  end

end
