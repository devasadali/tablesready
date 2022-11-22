# Keeps the Last 5 log files which are rotated at every 10MB
#Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'), 5, 10.megabytes)
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))