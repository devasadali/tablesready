class WalkIn < Booking
  # set checkin to true
  after_create :set_checkin
  after_save :set_noshow_job
end
